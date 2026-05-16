import { MantineProvider } from "@mantine/core";
import { QueryClientProvider } from "@tanstack/react-query";

import App from "@/app/App";

import useHotkeyListener from "@/hooks/useHotkeyListener";
import useMessageListener from "@/hooks/useMessageListener";

import { forceColorScheme, mantineTheme } from "@/styles/mantineTheme";
import { queryClient } from "@/utils/queryClient";

export default function Root() {
	useMessageListener();
	useHotkeyListener();

	return (
		<MantineProvider
			theme={mantineTheme}
			forceColorScheme={forceColorScheme}
			defaultColorScheme={forceColorScheme}
		>
			<QueryClientProvider client={queryClient}>
				<App />
			</QueryClientProvider>
		</MantineProvider>
	);
}
