import type { MantineThemeOverride } from "@mantine/core";
import { DEFAULT_COLORS } from "@/styles/mantineColors";

export const mantineTheme: MantineThemeOverride = {
	colors: DEFAULT_COLORS,
	fontFamily: "Manrope, sans-serif",

	focusRing: "never",
	components: {},
};

export const forceColorScheme: "light" | "dark" = "dark";
