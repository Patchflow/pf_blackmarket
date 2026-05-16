export const validateItemQuantity = (
	quantity: string | number | undefined,
	maxAmount: number,
): number | null => {
	if (quantity === undefined) return null;
	if (Number.isNaN(quantity)) return null;
	if (typeof quantity === "string") return null;

	if (quantity < 1) return 1;
	if (quantity > maxAmount) return maxAmount;
	return quantity;
};
