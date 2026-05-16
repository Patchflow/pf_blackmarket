declare global {
	interface Window {
		GetParentResourceName?: () => string;
		invokeNative?: () => void;
	}
}

export {};
