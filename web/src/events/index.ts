import { configHandlers } from "@/events/config";
import { nuiHandlers } from "@/events/nui";
import type { AppMessage } from "@/events/types";

const handlers = {
	...nuiHandlers,
	...configHandlers,
};

export function handleIncomingMessage(event: MessageEvent<AppMessage>) {
	const { action, data } = event.data;
	const handler = handlers[action];

	if (handler) handler(data as never);
	else console.warn(`Unhandled message action: ${action}`);
}
