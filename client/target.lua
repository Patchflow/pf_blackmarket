---@type Config
local Config = lib.load("config.config")

local spawnedPeds = {}

local function cleanupPeds()
	for _, ped in ipairs(spawnedPeds) do
		if DoesEntityExist(ped) then
			exports.ox_target:removeLocalEntity(ped, "blackmarket_open")
			SetEntityAsMissionEntity(ped, true, true)
			DeleteEntity(ped)
		end
	end
	spawnedPeds = {}
end

---@param positions vector4[]
local function spawnPeds(positions)
	for i, pedConfig in ipairs(Config.Peds) do
		local coords = positions[i]
		if not coords then break end

		lib.requestModel(pedConfig.model)
		local ped = CreatePed(4, pedConfig.model, coords.x, coords.y, coords.z - 1, coords.w, false, false)
		SetEntityAsMissionEntity(ped, true, true)
		FreezeEntityPosition(ped, true)
		SetEntityInvincible(ped, true)
		SetBlockingOfNonTemporaryEvents(ped, true)
		SetModelAsNoLongerNeeded(pedConfig.model)

		if pedConfig.scenario then
			TaskStartScenarioInPlace(ped, pedConfig.scenario, 0, true)
		end

		exports.ox_target:addLocalEntity(ped, {
			{
				name = "blackmarket_open",
				icon = "fas fa-shopping-cart",
				label = locale("ui.open_blackmarket"),
				distance = 4,
				onSelect = function()
					ToggleNui(true)
				end
			}
		})

		spawnedPeds[#spawnedPeds + 1] = ped
	end
end

CreateThread(function()
	while GetResourceState("ox_target") ~= "started" do
		Wait(100)
	end

	local positions = lib.callback.await("pf_blackmarket:server:getPedPositions")
	if positions then
		spawnPeds(positions)
	end
end)

RegisterNetEvent("pf_blackmarket:client:relocatePeds", function(positions)
	cleanupPeds()
	spawnPeds(positions)
end)

AddEventHandler("onResourceStop", function(resourceName)
	if resourceName == cache.resource then
		cleanupPeds()
	end
end)
