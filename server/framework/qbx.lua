---@class FrameworkServer
local Framework = {}

---@param source number
---@return number
function Framework.GetPlayerMoney(source)
    local amount = exports.qbx_core:GetMoney(source, "bank")
    return amount or 0
end

---@param source number
---@param amount number
---@return boolean
function Framework.RemovePlayerMoney(source, amount)
    local success = exports.qbx_core:RemoveMoney(source, "bank", amount, "blackmarket_purchase")
    return success or false
end

---@param source number
---@param amount number
---@return boolean
function Framework.AddPlayerMoney(source, amount)
    local success = exports.qbx_core:AddMoney(source, "bank", amount, "blackmarket_refund")
    return success or false
end

return Framework
