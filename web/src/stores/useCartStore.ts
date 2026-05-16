import { create } from "zustand";
import { immer } from "zustand/middleware/immer";
import { type IConfigItem, useConfigStore } from "@/stores/useConfigStore";

export interface ICartItem extends IConfigItem {
	quantity: number;
	category: string;
}

export const cartItemKey = (name: string, category: string) =>
	`${category}:${name}`;

export interface CartState {
	opened: boolean;
	open: () => void;
	close: () => void;

	items: ICartItem[];
	addItem: (itemName: string, quantity: number) => void;
	removeItem: (itemName: string, category: string) => void;
	updateQuantity: (itemName: string, category: string, quantity: number) => void;
}

export const useCartStore = create<CartState>()(
	immer((set) => ({
		opened: false,
		open: () => set({ opened: true }),
		close: () => set({ opened: false }),

		items: [],
		addItem: (itemName, quantity) =>
			set((state) => {
				if (Number.isNaN(quantity)) return;
				if (quantity < 1) return;

				const { categories, activeCategoryId } = useConfigStore.getState();
				if (!activeCategoryId) return;
				if (!categories[activeCategoryId]) return;

				const key = cartItemKey(itemName, activeCategoryId);
				const existingItem = state.items.find(
					(item) => cartItemKey(item.name, item.category) === key,
				);

				if (!existingItem) {
					const item = categories[activeCategoryId].items.find(
						(i) => i.name === itemName,
					);
					if (!item) return;

					if (quantity > item.maxAmount) quantity = item.maxAmount;

					state.items.push({ ...item, quantity, category: activeCategoryId });
					return;
				}

				if (existingItem.quantity + quantity > existingItem.maxAmount) {
					existingItem.quantity = existingItem.maxAmount;
					return;
				}

				existingItem.quantity += quantity;
			}),
		removeItem: (itemName, category) =>
			set((state) => {
				const key = cartItemKey(itemName, category);
				state.items = state.items.filter(
					(item) => cartItemKey(item.name, item.category) !== key,
				);
			}),
		updateQuantity: (itemName, category, quantity) =>
			set((state) => {
				if (Number.isNaN(quantity)) return;
				if (quantity < 1) return;

				const key = cartItemKey(itemName, category);
				const existingItem = state.items.find(
					(item) => cartItemKey(item.name, item.category) === key,
				);
				if (!existingItem) return;

				if (quantity > existingItem.maxAmount)
					quantity = existingItem.maxAmount;

				existingItem.quantity = quantity;
			}),
	})),
);

export const useCartCount = () => {
	return useCartStore((state) => state.items.length);
};

export const useCartTotal = () => {
	const items = useCartStore((state) => state.items);
	return items.reduce((total, item) => total + item.price * item.quantity, 0);
};