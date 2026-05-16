import type { ConfigMessages } from "@/events/types/config";
import type { NuiMessages } from "@/events/types/nui";

export type AppMessage = NuiMessages | ConfigMessages;

export type MessageType = AppMessage["action"];
export type MessagePayload<T extends MessageType> = Extract<
	AppMessage,
	{ action: T }
>["data"];
