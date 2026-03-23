---@type Config
return {
	ImageUrl = "nui://ox_inventory/web/images/",

	Stores = {
		downtown = {
			PaymentType = PaymentType.BANK,
			CashItem = "money",
			RelocationSchedule = CronSchedule.EVERY_30_MINUTES,
			Peds = {
				{
					model = "g_m_m_chiboss_01",
					scenario = "WORLD_HUMAN_STAND_IMPATIENT",
					possibleLocations = {
						vector4(-133.4801, -673.6423, 48.2314, 71.5525),
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
		},
		downtown2 = {
			PaymentType = PaymentType.BANK,
			CashItem = "money",
			RelocationSchedule = CronSchedule.EVERY_30_MINUTES,
			Peds = {
				{
					model = "g_m_m_chiboss_01",
					scenario = "WORLD_HUMAN_STAND_IMPATIENT",
					possibleLocations = {
						vector4(-132.9495, -672.3704, 48.2297, 71.5525),
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
	}
}
