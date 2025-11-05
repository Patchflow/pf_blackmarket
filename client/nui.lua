local nuiVisible = false

--- @param state boolean?
function ToggleNui(state)
	if not state then
		nuiVisible = not nuiVisible
	else
		nuiVisible = state
	end

	SendNUIMessage({
		action = NuiMessageType.NUI_TOGGLE,
		data = nuiVisible
	})
	SetNuiFocus(nuiVisible, nuiVisible)

	local blurFunc = nuiVisible and TriggerScreenblurFadeIn or TriggerScreenblurFadeOut
	blurFunc(300)
end

---@param cb function
RegisterNUICallback(NuiCallbackType.NUI_CLOSE, function(_, cb)
	ToggleNui(false)
	cb("ok")
end)

---@param data PurchaseData
---@param cb function
RegisterNUICallback(NuiCallbackType.PROCESS_PURCHASE, function(data, cb)
	---@type PurchaseResult
	local response = lib.callback.await("pf_blackmarket:server:processPurchase", false, data)
	cb(response)
end)

RegisterNUICallback(NuiCallbackType.REQUEST_CONFIG, function(_, cb)
	---@type Config
	local config = lib.load("config.config")

	SendNUIMessage({
		action = NuiMessageType.SET_CONFIG,
		data = {
			imageUrl = config.ImageUrl,
			categories = config.Categories,
			locale = lib.getLocales()
		}
	})

	cb("ok")
end)

AddEventHandler("ox_lib:setLocale", function()
	SendNUIMessage({
		action = NuiMessageType.SET_LOCALE,
		data = lib.getLocales()
	})
end)