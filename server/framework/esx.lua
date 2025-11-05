local ESX = exports["es_extended"]:getSharedObject()

---@class FrameworkServer
local Framework = {}

---@param source number
---@return number
function Framework.GetPlayerMoney(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return 0 end

    return xPlayer.getAccount("bank").money
end

---@param source number
---@param amount number
---@return boolean
function Framework.RemovePlayerMoney(source, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return false end

    xPlayer.removeAccountMoney("bank", amount)
    return true
end

---@param source number
---@param amount number
---@return boolean
function Framework.AddPlayerMoney(source, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return false end

    xPlayer.addAccountMoney("bank", amount)
    return true
end

return Framework
