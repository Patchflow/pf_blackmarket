local Config = load(LoadResourceFile(cache.resource, "config/config.cl.lua"), "@@" .. cache.resource)()

local nuiVisible = false

local activeStoreId = nil

function GetActiveStoreId()
	return activeStoreId
end

local function sendStoreConfig(storeId)
	local store = storeId and Config.Stores[storeId]

	SendNUIMessage({
		action = NuiMessageType.SET_CONFIG,
		data = {
			imageUrl = Config.ImageUrl,
			categories = store and store.Categories or {},
			locale = lib.getLocales()
		}
	})
end

function ToggleNui(state, storeId)
	if state == nil then
		nuiVisible = not nuiVisible
	else
		nuiVisible = state
	end

	if nuiVisible and storeId then
		activeStoreId = storeId
		sendStoreConfig(storeId)
	elseif not nuiVisible then
		activeStoreId = nil
	end

	SendNUIMessage({
		action = NuiMessageType.NUI_TOGGLE,
		data = nuiVisible
	})
	SetNuiFocus(nuiVisible, nuiVisible)

	local blurFunc = nuiVisible and TriggerScreenblurFadeIn or TriggerScreenblurFadeOut
	blurFunc(300)
end

RegisterNUICallback(NuiCallbackType.NUI_CLOSE, function(_, cb)
	ToggleNui(false)
	cb("ok")
end)

RegisterNUICallback(NuiCallbackType.PROCESS_PURCHASE, function(data, cb)
	data.storeId = activeStoreId
	local response = lib.callback.await("pf_blackmarket:server:processPurchase", false, data)
	cb(response)
end)

RegisterNUICallback(NuiCallbackType.REQUEST_CONFIG, function(_, cb)
	sendStoreConfig(activeStoreId)
	cb("ok")
end)

AddEventHandler("ox_lib:setLocale", function()
	SendNUIMessage({
		action = NuiMessageType.SET_LOCALE,
		data = lib.getLocales()
	})
end)
