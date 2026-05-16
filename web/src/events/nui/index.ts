import type { MessagePayload } from "@/events/types";
import { useCartStore } from "@/stores/useCartStore";
import { useCheckoutStore } from "@/stores/useCheckoutStore";
import { useNuiStore } from "@/stores/useNuiStore";

function handleNuiToggle(payload: MessagePayload<"NUI_TOGGLE">) {
	useNuiStore.getState().setVisible(payload);

	if (!payload) {
		useCartStore.setState({ items: [], opened: false });
		useCheckoutStore.getState().close();
	}
}

export const nuiHandlers = {
	NUI_TOGGLE: handleNuiToggle,
};
