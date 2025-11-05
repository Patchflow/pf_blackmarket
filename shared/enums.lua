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
