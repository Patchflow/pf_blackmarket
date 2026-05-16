import type { MessagePayload } from "@/events/types";
import { useConfigStore } from "@/stores/useConfigStore";

function handleSetConfig(payload: MessagePayload<"SET_CONFIG">) {
	useConfigStore.getState().setConfig(payload);
}

function handleSetLocale(payload: MessagePayload<"SET_LOCALE">) {
	useConfigStore.getState().setLocale(payload);
}

export const configHandlers = {
	SET_CONFIG: handleSetConfig,
	SET_LOCALE: handleSetLocale,
};
