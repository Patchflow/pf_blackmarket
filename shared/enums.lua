---@enum PaymentType
PaymentType = {
	CASH = "cash",
	BANK = "bank"
}

---@enum PurchaseError
PurchaseError = {
	INVALID_CATEGORY = "invalid_category",
	INVALID_ITEM = "invalid_item",
	INVALID_QUANTITY = "invalid_quantity",
	INSUFFICIENT_FUNDS = "insufficient_funds",
	INSUFFICIENT_WEIGHT = "insufficient_weight",
	VALIDATION_FAILED = "validation_failed",
	PAYMENT_FAILED = "payment_failed",
	INVENTORY_FULL = "inventory_full",
	PURCHASE_FAILED = "purchase_failed",
	NO_FRAMEWORK = "no_framework",
	TOO_FAR = "too_far"
}

---@enum LogEvent
LogEvent = {
	PURCHASE_SUCCESS = "purchase_success",
	PURCHASE_FAILED = "purchase_failed"
}

---@enum CronSchedule
CronSchedule = {
	EVERY_30_MINUTES = "*/30 * * * *",
	EVERY_HOUR = "0 * * * *",
	EVERY_2_HOURS = "0 */2 * * *",
	EVERY_4_HOURS = "0 */4 * * *",
	EVERY_6_HOURS = "0 */6 * * *",
	EVERY_12_HOURS = "0 */12 * * *",
	EVERY_DAY = "0 0 * * *",
}
