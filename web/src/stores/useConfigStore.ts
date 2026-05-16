import { create } from "zustand";
import en from "../../../locales/en.json";

export type LocaleKey = keyof typeof en;

export interface IConfigItem {
	name: string;
	label: string;
	price: number;
	maxAmount: number;
}

export type Category = {
	label: string;
	icon: string;
	items: IConfigItem[];
};

export type Config = {
	imageUrl: string;
	categories: Record<string, Category>;
	locale: Record<LocaleKey, string>;
};

interface ConfigState {
	imageUrl: string | null;
	categories: Record<string, Category>;
	locale: Record<LocaleKey, string>;

	activeCategoryId: string | undefined;
	setActiveCategoryId: (id: string) => void;

	setConfig: (config: Config) => void;
	setLocale: (locale: Record<LocaleKey, string>) => void;
}

export const useConfigStore = create<ConfigState>()((set) => ({
	imageUrl: null,
	categories: {},
	locale: en,

	activeCategoryId: undefined,
	setActiveCategoryId: (id) => set({ activeCategoryId: id }),

	setConfig: (config) =>
		set((state) => ({
			...state,
			...config,
			activeCategoryId: Object.keys(config.categories)[0],
		})),

	setLocale: (locale) =>
		set((state) => ({
			...state,
			locale: { ...state.locale, ...locale },
		})),
}));