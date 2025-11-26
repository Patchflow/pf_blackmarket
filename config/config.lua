---@type Config
return {
	ImageUrl = "nui://ox_inventory/web/images/",

	PaymentType = PaymentType.BANK,
	CashItem = "money",

	DiscordWebhook = "",

	Logging = {
		Enabled = true,
		UseOxLogger = true,
		UseDiscordWebhook = true,
	},
	Peds = {
		{
			model = "g_m_m_chiboss_01",
			scenario = "WORLD_HUMAN_STAND_IMPATIENT",
			possibleLocations = {
				vector4(-133.4801, -673.6423, 48.2314, 71.5525),
				vector4(-141.2106, -665.0565, 48.2223, 249.8132),
				vector4(-143.6719, -672.1041, 48.2334, 340.1633),
			}
		}
	},

	Categories = {
		weapons = {
			label = "Weapons",
			icon = "fas fa-gun",
			items = {
				{ name = "WEAPON_PISTOL", label = "Pistol", price = 5000, maxAmount = 1 }
			}
		},
		materials = {
			label = "Materials",
			icon = "fas fa-box",
			items = {
				{ name = "iron", label = "Iron", price = 100, maxAmount = 50 }
			}
		}
	}
}
