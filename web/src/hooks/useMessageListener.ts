import { useEffect } from "react";
import { handleIncomingMessage } from "@/events";
import type { AppMessage } from "@/events/types";

export default function useMessageListener() {
	useEffect(() => {
		const listener = (event: MessageEvent<AppMessage>) => {
			handleIncomingMessage(event);
		};

		window.addEventListener("message", listener);
		return () => window.removeEventListener("message", listener);
	}, []);
}
