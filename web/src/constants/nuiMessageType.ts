export const NuiMessageType = {
	NUI_TOGGLE: "NUI_TOGGLE",
	SET_CONFIG: "SET_CONFIG",
	SET_LOCALE: "SET_LOCALE",
} as const;

export type NuiMessage = (typeof NuiMessageType)[keyof typeof NuiMessageType];
