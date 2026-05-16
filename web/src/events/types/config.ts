import type { Config } from "@/stores/useConfigStore";

export type ConfigMessages = {
	action: "SET_CONFIG";
	data: Config;
} | {
	action: "SET_LOCALE";
	data: Record<string, string>;
};
