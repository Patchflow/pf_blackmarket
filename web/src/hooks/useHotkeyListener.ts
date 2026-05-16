import { useHotkeys } from "@mantine/hooks";
import { useCartStore } from "@/stores/useCartStore";
import { useCheckoutStore } from "@/stores/useCheckoutStore";
import { useNuiStore } from "@/stores/useNuiStore";

export default function useHotkeyListener() {
	useHotkeys([["escape", () => {
		if (!useNuiStore.getState().visible) return;

		if (useCheckoutStore.getState().opened) {
			useCheckoutStore.getState().close();
		} else if (useCartStore.getState().opened) {
			useCartStore.getState().close();
		} else {
			useNuiStore.getState().close();
		}
	}]]);

	return null;
}