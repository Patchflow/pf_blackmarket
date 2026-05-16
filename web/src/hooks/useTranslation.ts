import { useCallback } from "react";
import { useConfigStore, type LocaleKey } from "@/stores/useConfigStore";

export function useTranslation() {
	const locale = useConfigStore((state) => state.locale);

	const t = useCallback(
		(key: LocaleKey, ...args: (string | number)[]): string => {
			let text = locale[key];

			if (!text) {
				console.warn(`Missing translation key: ${key}`);
				return key;
			}

			if (args.length > 0) {
				args.forEach((value) => {
					text = text.replace("%s", String(value));
				});
			}

			text = text.replace(/\$\{([^}]+)\}/g, (match, refKey) => {
				return locale[refKey as LocaleKey] || match;
			});

			return text;
		},
		[locale],
	);

	return { t };
}
