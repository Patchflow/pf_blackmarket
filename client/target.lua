local Config = load(LoadResourceFile(cache.resource, "config/config.cl.lua"), "@@" .. cache.resource)()

local spawnedPeds = {}

local function cleanupPeds(storeId)
	local peds = spawnedPeds[storeId]
	if not peds then return end

	for _, ped in ipairs(peds) do
		if DoesEntityExist(ped) then
			exports.ox_target:removeLocalEntity(ped, "blackmarket_open_" .. storeId)
			SetEntityAsMissionEntity(ped, true, true)
			DeleteEntity(ped)
		end
	end
	spawnedPeds[storeId] = {}
end

local function spawnPeds(storeId, pedConfigs, positions)
	spawnedPeds[storeId] = {}

	for i, pedConfig in ipairs(pedConfigs) do
		local coords = positions[i]
		if not coords then break end

		lib.requestModel(pedConfig.model)
		local ped = CreatePed(4, pedConfig.model, coords.x, coords.y, coords.z - 1, coords.w, false, false)
		SetModelAsNoLongerNeeded(pedConfig.model)

		if ped == 0 then
			lib.print.error(("Failed to create ped '%s' for store '%s'"):format(pedConfig.model, storeId))
			goto continue
		end

		SetEntityAsMissionEntity(ped, true, true)
		FreezeEntityPosition(ped, true)
		SetEntityInvincible(ped, true)
		SetBlockingOfNonTemporaryEvents(ped, true)

		if pedConfig.scenario then
			TaskStartScenarioInPlace(ped, pedConfig.scenario, 0, true)
		end

		exports.ox_target:addLocalEntity(ped, {
			{
				name = "blackmarket_open_" .. storeId,
				icon = "fas fa-shopping-cart",
				label = locale("ui.open_blackmarket"),
				distance = 4,
				onSelect = function()
					ToggleNui(true, storeId)
				end
			}
		})

		spawnedPeds[storeId][#spawnedPeds[storeId] + 1] = ped

		::continue::
	end
end

CreateThread(function()
	while GetResourceState("ox_target") ~= "started" do
		Wait(100)
	end

	local allPositions = lib.callback.await("pf_blackmarket:server:getPedPositions")
	if not allPositions then return end

	for storeId, store in pairs(Config.Stores) do
		local positions = allPositions[storeId]
		if positions then
			spawnPeds(storeId, store.Peds, positions)
		end
	end
end)

RegisterNetEvent("pf_blackmarket:client:relocatePeds", function(storeId, positions)
	if type(storeId) ~= "string" or type(positions) ~= "table" then return end

	local store = Config.Stores[storeId]
	if not store then return end

	if GetActiveStoreId() == storeId then
		ToggleNui(false)
	end

	cleanupPeds(storeId)
	spawnPeds(storeId, store.Peds, positions)
end)

AddEventHandler("onResourceStop", function(resourceName)
	if resourceName == cache.resource then
		for storeId in pairs(spawnedPeds) do
			cleanupPeds(storeId)
		end
	end
end)
