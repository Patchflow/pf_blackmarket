---@type Config
return {
	ImageUrl = "nui://ox_inventory/web/images/",

	PaymentType = PaymentType.BANK,
	CashItem = "money",

	DiscordWebhook = "https://discord.com/api/webhooks/1391769874199740587/UI_ZiBqDkbVSVADN3lunvjkvmLWuRvLmM2ritVZeo1PYvSn_FZJ_qCpZYGAuc6GKvaGx",

	Logging = {
		Enabled = true,
		UseOxLogger = true,
		UseDiscordWebhook = true,
	},

	Peds = {
		{
			model = "g_m_m_chiboss_01",
			coords = vector4(-133.4801, -673.6423, 48.2314, 71.5525),
			scenario = "WORLD_HUMAN_STAND_IMPATIENT"
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
