import { create } from "zustand";
import { NuiCallbackType } from "@/constants/nuiCallbackType";
import { useCartStore } from "@/stores/useCartStore";
import { fetchNui } from "@/utils/fetchNui";

interface CheckoutState {
	opened: boolean;
	isProcessing: boolean;
	error: string | null;
	open: () => void;
	close: () => void;
	clearError: () => void;
	processPurchase: () => Promise<boolean>;
}

export const useCheckoutStore = create<CheckoutState>()((set) => ({
	opened: false,
	isProcessing: false,
	error: null,
	open: () => set({ opened: true, error: null }),
	close: () => set({ opened: false }),
	clearError: () => set({ error: null }),
	processPurchase: async () => {
		if (useCheckoutStore.getState().isProcessing) return false;
		set({ isProcessing: true, error: null });

		try {
			const { items } = useCartStore.getState();

			const purchaseData = {
				items: items.map((item) => ({
					name: item.name,
					quantity: item.quantity,
					category: item.category,
				})),
			};

			const result = await fetchNui<{ success: boolean; reason?: string }>(
				NuiCallbackType.PROCESS_PURCHASE,
				purchaseData
			);

			if (result.success) {
				useCartStore.setState({ items: [] });
				return true;
			}

			set({ error: result.reason || "purchase_failed" });
			return false;
		} catch (error) {
			console.error("Purchase error:", error);
			set({ error: "purchase_failed" });
			return false;
		} finally {
			set({ isProcessing: false });
		}
	},
}));