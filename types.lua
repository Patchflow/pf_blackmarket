---@meta

---@class ItemConfig
---@field name string
---@field label string?
---@field price number
---@field maxAmount number
---@field metadata table?

---@class CategoryConfig
---@field label string
---@field icon string
---@field items ItemConfig[]

---@class PedConfig
---@field model string
---@field possibleLocations vector4[]
---@field scenario string?

---@class LoggingConfig
---@field Enabled boolean
---@field UseOxLogger boolean
---@field UseDiscordWebhook boolean

---@class Config
---@field ImageUrl string
---@field PaymentType PaymentType
---@field CashItem string
---@field DiscordWebhook string
---@field Logging LoggingConfig
---@field Peds PedConfig[]
---@field Categories table<string, CategoryConfig>

---@class CartItemData
---@field name string
---@field quantity number
---@field category string

---@class PurchaseData
---@field items CartItemData[]

---@class PurchaseResult
---@field success boolean
---@field reason string?

---@class ValidatedItem
---@field name string
---@field quantity number
---@field metadata table?

---@class FrameworkServer
---@field GetPlayerMoney fun(source: number): number
---@field RemovePlayerMoney fun(source: number, amount: number): boolean
---@field AddPlayerMoney fun(source: number, amount: number): boolean

---@class Logger
---@field LogPurchase fun(source: number, items: CartItemData[], totalPrice: number, success: boolean, reason: string?)
---@field SendDiscordLog fun(playerName: string, itemList: string, totalPrice: number, success: boolean, reason: string?)
