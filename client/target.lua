---@type Config
local Config = lib.load("config.config")

local spawnedPeds = {}
local pedLocations = {}

local function cleanupPeds()
	for _, ped in ipairs(spawnedPeds) do
		if DoesEntityExist(ped) then
			DeleteEntity(ped)
		end
	end
	spawnedPeds = {}
	pedLocations = {}
end

local function spawnPeds()
	for _, pedConfig in ipairs(Config.Peds) do
		local coords = pedConfig.possibleLocations[math.random(#pedConfig.possibleLocations)]

		lib.requestModel(pedConfig.model)
		local ped = CreatePed(4, pedConfig.model, coords.x, coords.y, coords.z - 1, coords.w, true, true)
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
		pedLocations[#pedLocations + 1] = coords
	end
end

CreateThread(function()
	spawnPeds()
end)

AddEventHandler("onResourceStop", function(resourceName)
	if resourceName == cache.resource then
		cleanupPeds()
	end
end)

lib.callback.register("pf_blackmarket:client:getPedLocations", function()
	return pedLocations
end)
