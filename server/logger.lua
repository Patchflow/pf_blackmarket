---@type Config
local Config = lib.load("config.config")

---@class Logger
local Logger = {}

---@param source number
---@return string
local function getPlayerName(source)
	return GetPlayerName(source) or "Unknown Player"
end

---@param items CartItemData[]
---@return string
local function formatItemList(items)
	local itemStrings = {}
	for i = 1, #items do
		local item = items[i]
		itemStrings[#itemStrings + 1] = ("%dx %s"):format(item.quantity, item.name)
	end
	return table.concat(itemStrings, ", ")
end

---@param reason string?
---@return string
local function getLocalizedError(reason)
	if not reason then
		return locale("error.purchase_failed")
	end

	local key = "error." .. reason
	return locale(key)
end

---@param source number
---@param items CartItemData[]
---@param totalPrice number
---@param success boolean
---@param reason string?
function Logger.LogPurchase(source, items, totalPrice, success, reason)
	if not Config.Logging.Enabled then
		return
	end

	local playerName = getPlayerName(source)
	local itemList = formatItemList(items)

	if Config.Logging.UseOxLogger then
		if success then
			lib.logger(
				tostring(source),
				LogEvent.PURCHASE_SUCCESS,
				locale("log.purchase_success", #items, totalPrice) .. " | Items: " .. itemList,
				"blackmarket",
				"purchase",
				Config.PaymentType
			)
		else
			local localizedError = getLocalizedError(reason)
			lib.logger(
				tostring(source),
				LogEvent.PURCHASE_FAILED,
				locale("log.purchase_failed", localizedError, #items, totalPrice) .. " | Items: " .. itemList,
				"blackmarket",
				"purchase_failed",
				reason or PurchaseError.PURCHASE_FAILED
			)
		end
	end

	if Config.Logging.UseDiscordWebhook and Config.DiscordWebhook and Config.DiscordWebhook ~= "" then
		Logger.SendDiscordLog(playerName, itemList, totalPrice, success, reason)
	end
end

---@param playerName string
---@param itemList string
---@param totalPrice number
---@param success boolean
---@param reason string?
function Logger.SendDiscordLog(playerName, itemList, totalPrice, success, reason)
	local color = success and 3066993 or 15158332
	local localizedError = getLocalizedError(reason)
	local title = success and locale("log.discord_title_success") or locale("log.discord_title_failed", localizedError)

	local embed = {
		{
			title = title,
			color = color,
			fields = {
				{
					name = locale("log.discord_player"),
					value = playerName,
					inline = true
				},
				{
					name = locale("log.discord_total_price"),
					value = ("$%s"):format(lib.math.groupdigits(totalPrice)),
					inline = true
				},
				{
					name = locale("log.discord_items"),
					value = itemList,
					inline = false
				}
			},
			footer = {
				text = "Patchflow - Blackmarket"
			},
			timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
		}
	}

	PerformHttpRequest(Config.DiscordWebhook, function() end, "POST", json.encode({
		username = "Patchflow - Blackmarket",
		embeds = embed
	}), {
		["Content-Type"] = "application/json"
	})
end

return Logger
