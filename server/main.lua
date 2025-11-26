if cache.resource ~= "pf_blackmarket" then
	lib.print.error("Resource name must be 'pf_blackmarket' for proper functionality.")
	return
end

---@type Config
local Config = lib.load("config.config")

---@type Logger
local Logger = lib.load("server.logger")

---@return FrameworkServer
local function LoadFramework()
	if GetResourceState("es_extended") == "started" then
		return lib.load("server.framework.esx")
	end
	if GetResourceState("qbx_core") == "started" then
		return lib.load("server.framework.qbx")
	end

	lib.print.error(locale("error.no_framework"))
	return {}
end

---@type FrameworkServer
local Framework = LoadFramework()

---@param category string
---@param itemName string
---@param quantity number
---@return boolean success
---@return string? error
---@return ItemConfig? itemData
local function validatePurchase(category, itemName, quantity)
	local categoryData = Config.Categories[category]
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

---@param items CartItemData[]
---@return boolean success
---@return string? error
---@return ValidatedItem[] validatedItems
---@return number totalPrice
---@return number totalWeight
local function validateCartItems(items)
	local totalWeight = 0
	local totalPrice = 0
	---@type ValidatedItem[]
	local validatedItems = {}

	for i = 1, #items do
		local cartItem = items[i]
		local success, error, itemData = validatePurchase(
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

---@param source number
---@param totalPrice number
---@return boolean success
local function checkPlayerFunds(source, totalPrice)
	local playerMoney
	if Config.PaymentType == PaymentType.CASH then
		playerMoney = exports.ox_inventory:Search(source, "count", Config.CashItem) or 0
	else
		playerMoney = Framework.GetPlayerMoney(source)
	end

	return playerMoney >= totalPrice
end

---@param source number
---@param totalPrice number
---@return boolean success
local function processPayment(source, totalPrice)
	if Config.PaymentType == PaymentType.CASH then
		return exports.ox_inventory:RemoveItem(source, Config.CashItem, totalPrice)
	else
		return Framework.RemovePlayerMoney(source, totalPrice)
	end
end

---@param source number
---@param totalPrice number
local function refundPayment(source, totalPrice)
	if Config.PaymentType == PaymentType.CASH then
		exports.ox_inventory:AddItem(source, Config.CashItem, totalPrice)
	else
		Framework.AddPlayerMoney(source, totalPrice)
	end
end

---@param source number
---@param validatedItems ValidatedItem[]
---@param totalPrice number
---@return boolean success
---@return string? error
local function addItemsToInventory(source, validatedItems, totalPrice)
	for i = 1, #validatedItems do
		local item = validatedItems[i]
		local addSuccess = exports.ox_inventory:AddItem(source, item.name, item.quantity, item.metadata)

		if not addSuccess then
			refundPayment(source, totalPrice)

			for j = 1, i - 1 do
				local prevItem = validatedItems[j]
				exports.ox_inventory:RemoveItem(source, prevItem.name, prevItem.quantity)
			end

			return false, PurchaseError.INVENTORY_FULL
		end
	end

	return true
end

---@param source number
---@param data PurchaseData
---@return PurchaseResult
lib.callback.register("pf_blackmarket:server:processPurchase", function(source, data)
	if not Framework then
		Logger.LogPurchase(source, data.items, 0, false, PurchaseError.NO_FRAMEWORK)
		return { success = false, reason = PurchaseError.NO_FRAMEWORK }
	end

	local pedLocations = lib.callback.await("pf_blackmarket:client:getPedLocations", source)
	if not pedLocations or #pedLocations == 0 then
		Logger.LogPurchase(source, data.items, 0, false, PurchaseError.TOO_FAR)
		return { success = false, reason = PurchaseError.TOO_FAR }
	end

	local playerPos = GetEntityCoords(GetPlayerPed(source))
	local isNearPed = false

	for i = 1, #pedLocations do
		local pedPos = pedLocations[i]
		if #(playerPos - vec3(pedPos.x, pedPos.y, pedPos.z)) <= 5.0 then
			isNearPed = true
			break
		end
	end

	if not isNearPed then
		Logger.LogPurchase(source, data.items, 0, false, PurchaseError.TOO_FAR)
		return { success = false, reason = PurchaseError.TOO_FAR }
	end

	local success, error, validatedItems, totalPrice, totalWeight = validateCartItems(data.items)
	if not success then
		Logger.LogPurchase(source, data.items, totalPrice, false, error)
		return { success = false, reason = error }
	end

	if not exports.ox_inventory:CanCarryWeight(source, totalWeight) then
		Logger.LogPurchase(source, data.items, totalPrice, false, PurchaseError.INSUFFICIENT_WEIGHT)
		return { success = false, reason = PurchaseError.INSUFFICIENT_WEIGHT }
	end

	if not checkPlayerFunds(source, totalPrice) then
		Logger.LogPurchase(source, data.items, totalPrice, false, PurchaseError.INSUFFICIENT_FUNDS)
		return { success = false, reason = PurchaseError.INSUFFICIENT_FUNDS }
	end

	if not processPayment(source, totalPrice) then
		Logger.LogPurchase(source, data.items, totalPrice, false, PurchaseError.PAYMENT_FAILED)
		return { success = false, reason = PurchaseError.PAYMENT_FAILED }
	end

	local itemSuccess, itemError = addItemsToInventory(source, validatedItems, totalPrice)
	if not itemSuccess then
		Logger.LogPurchase(source, data.items, totalPrice, false, itemError)
		return { success = false, reason = itemError }
	end

	Logger.LogPurchase(source, data.items, totalPrice, true, nil)
	return { success = true }
end)
