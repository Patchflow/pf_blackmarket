if cache.resource ~= "pf_blackmarket" then
	lib.print.error("Resource name must be 'pf_blackmarket' for proper functionality.")
	return
end

local Config = load(LoadResourceFile(cache.resource, "config/config.cl.lua"), "@@" .. cache.resource)()

local Logger = lib.load("server.logger")

local function LoadFramework()
	if GetResourceState("es_extended") == "started" then
		return lib.load("server.framework.esx")
	end
	if GetResourceState("qbx_core") == "started" then
		return lib.load("server.framework.qbx")
	end

	lib.print.error(locale("error.no_framework"))
	return nil
end

local Framework = LoadFramework()

local function validatePurchase(categories, category, itemName, quantity)
	local categoryData = categories[category]
	if not categoryData then
		return false, PurchaseError.INVALID_CATEGORY, nil
	end

	local itemData
	for i = 1, #categoryData.items do
		local item = categoryData.items[i]
		if item.name == itemName then
			itemData = item
			break
		end
	end

	if not itemData then
		return false, PurchaseError.INVALID_ITEM, nil
	end

	if quantity <= 0 or quantity > itemData.maxAmount then
		return false, PurchaseError.INVALID_QUANTITY, nil
	end

	return true, nil, itemData
end

local function validateCartItems(categories, items)
	local totalWeight = 0
	local totalPrice = 0
	local validatedItems = {}

	for i = 1, #items do
		local cartItem = items[i]
		local success, error, itemData = validatePurchase(
			categories,
			cartItem.category,
			cartItem.name,
			cartItem.quantity
		)

		if not success or not itemData then
			return false, error or PurchaseError.VALIDATION_FAILED, {}, 0, 0
		end

		local itemInfo = exports.ox_inventory:Items(cartItem.name)
		if not itemInfo then
			return false, PurchaseError.INVALID_ITEM, {}, 0, 0
		end

		totalWeight = totalWeight + (itemInfo.weight * cartItem.quantity)
		totalPrice = totalPrice + (itemData.price * cartItem.quantity)

		validatedItems[#validatedItems + 1] = {
			name = cartItem.name,
			quantity = cartItem.quantity,
			metadata = itemData.metadata or {}
		}
	end

	return true, nil, validatedItems, totalPrice, totalWeight
end

local function checkPlayerFunds(source, store, totalPrice)
	local playerMoney = 0
	if store.PaymentType == PaymentType.CASH then
		playerMoney = exports.ox_inventory:Search(source, "count", store.CashItem) or 0
	elseif Framework then
		playerMoney = Framework.GetPlayerMoney(source)
	end

	return playerMoney >= totalPrice
end

local function processPayment(source, store, totalPrice)
	if store.PaymentType == PaymentType.CASH then
		return exports.ox_inventory:RemoveItem(source, store.CashItem, totalPrice)
	elseif Framework then
		return Framework.RemovePlayerMoney(source, totalPrice)
	end
	return false
end

local function refundPayment(source, store, totalPrice)
	if store.PaymentType == PaymentType.CASH then
		exports.ox_inventory:AddItem(source, store.CashItem, totalPrice)
	elseif Framework then
		Framework.AddPlayerMoney(source, totalPrice)
	end
end

local function addItemsToInventory(source, store, validatedItems, totalPrice)
	for i = 1, #validatedItems do
		local item = validatedItems[i]
		local addSuccess = exports.ox_inventory:AddItem(source, item.name, item.quantity, item.metadata)

		if not addSuccess then
			refundPayment(source, store, totalPrice)

			for j = 1, i - 1 do
				local prevItem = validatedItems[j]
				exports.ox_inventory:RemoveItem(source, prevItem.name, prevItem.quantity, prevItem.metadata)
			end

			return false, PurchaseError.INVENTORY_FULL
		end
	end

	return true
end

local processingPlayers = {}

local storePositions = {}

local function pickPedPositions(peds)
	local positions = {}
	for _, pedConfig in ipairs(peds) do
		positions[#positions + 1] = pedConfig.possibleLocations[math.random(#pedConfig.possibleLocations)]
	end
	return positions
end

for storeId, store in pairs(Config.Stores) do
	storePositions[storeId] = pickPedPositions(store.Peds)

	lib.cron.new(store.RelocationSchedule, function()
		storePositions[storeId] = pickPedPositions(store.Peds)
		TriggerClientEvent("pf_blackmarket:client:relocatePeds", -1, storeId, storePositions[storeId])
	end, { maxDelay = 60 })
end

lib.callback.register("pf_blackmarket:server:getPedPositions", function()
	return storePositions
end)

AddEventHandler("playerDropped", function()
	processingPlayers[source] = nil
end)

lib.callback.register("pf_blackmarket:server:processPurchase", function(source, data)
	if processingPlayers[source] then
		return { success = false, reason = PurchaseError.PURCHASE_FAILED }
	end

	processingPlayers[source] = true

	local ok, result = pcall(function()
		if not Framework then
			Logger.LogPurchase(source, data.storeId or "unknown", data.items, 0, "unknown", false, PurchaseError.NO_FRAMEWORK)
			return { success = false, reason = PurchaseError.NO_FRAMEWORK }
		end

		if type(data.items) ~= "table" or #data.items == 0 then
			return { success = false, reason = PurchaseError.VALIDATION_FAILED }
		end

		for _, item in ipairs(data.items) do
			if type(item.name) ~= "string" or type(item.quantity) ~= "number" or type(item.category) ~= "string" then
				return { success = false, reason = PurchaseError.VALIDATION_FAILED }
			end

			if item.quantity ~= math.floor(item.quantity) or item.quantity <= 0 then
				return { success = false, reason = PurchaseError.INVALID_QUANTITY }
			end
		end

		local storeId = data.storeId
		local store = storeId and Config.Stores[storeId]

		if not store then
			Logger.LogPurchase(source, storeId or "unknown", data.items, 0, "unknown", false, PurchaseError.INVALID_STORE)
			return { success = false, reason = PurchaseError.INVALID_STORE }
		end

		local positions = storePositions[storeId]
		if not positions or #positions == 0 then
			Logger.LogPurchase(source, storeId, data.items, 0, store.PaymentType, false, PurchaseError.TOO_FAR)
			return { success = false, reason = PurchaseError.TOO_FAR }
		end

		local playerPos = GetEntityCoords(GetPlayerPed(source))
		local isNearPed = false

		for i = 1, #positions do
			local pedPos = positions[i]
			if #(playerPos - vec3(pedPos.x, pedPos.y, pedPos.z)) <= 4.0 then
				isNearPed = true
				break
			end
		end

		if not isNearPed then
			Logger.LogPurchase(source, storeId, data.items, 0, store.PaymentType, false, PurchaseError.TOO_FAR)
			return { success = false, reason = PurchaseError.TOO_FAR }
		end

		local success, error, validatedItems, totalPrice, totalWeight = validateCartItems(store.Categories, data.items)
		if not success then
			Logger.LogPurchase(source, storeId, data.items, totalPrice, store.PaymentType, false, error)
			return { success = false, reason = error }
		end

		if not exports.ox_inventory:CanCarryWeight(source, totalWeight) then
			Logger.LogPurchase(source, storeId, data.items, totalPrice, store.PaymentType, false, PurchaseError.INSUFFICIENT_WEIGHT)
			return { success = false, reason = PurchaseError.INSUFFICIENT_WEIGHT }
		end

		if not checkPlayerFunds(source, store, totalPrice) then
			Logger.LogPurchase(source, storeId, data.items, totalPrice, store.PaymentType, false, PurchaseError.INSUFFICIENT_FUNDS)
			return { success = false, reason = PurchaseError.INSUFFICIENT_FUNDS }
		end

		if not processPayment(source, store, totalPrice) then
			Logger.LogPurchase(source, storeId, data.items, totalPrice, store.PaymentType, false, PurchaseError.PAYMENT_FAILED)
			return { success = false, reason = PurchaseError.PAYMENT_FAILED }
		end

		local itemSuccess, itemError = addItemsToInventory(source, store, validatedItems, totalPrice)
		if not itemSuccess then
			Logger.LogPurchase(source, storeId, data.items, totalPrice, store.PaymentType, false, itemError)
			return { success = false, reason = itemError }
		end

		Logger.LogPurchase(source, storeId, data.items, totalPrice, store.PaymentType, true, nil)
		return { success = true }
	end)

	processingPlayers[source] = nil

	if not ok then
		lib.print.error("processPurchase error: " .. tostring(result))
		return { success = false, reason = PurchaseError.PURCHASE_FAILED }
	end

	return result
end)
