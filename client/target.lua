---@type Config
local Config = lib.load("config.config")

CreateThread(function()
	for _, pedConfig in ipairs(Config.Peds) do
		lib.requestModel(pedConfig.model)

		local ped = CreatePed(4, pedConfig.model, pedConfig.coords.x, pedConfig.coords.y, pedConfig.coords.z - 1, pedConfig.coords.w, false, true)
		FreezeEntityPosition(ped, true)
		SetEntityInvincible(ped, true)
		SetBlockingOfNonTemporaryEvents(ped, true)

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
	end
end)
