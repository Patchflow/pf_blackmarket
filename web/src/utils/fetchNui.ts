import type { NuiCallbackType } from "@/constants/nuiCallbackType";

export async function fetchNui<T = unknown>(
	eventName: keyof typeof NuiCallbackType,
	data?: unknown,
): Promise<T> {
	const options = {
		method: "POST",
		headers: {
			"Content-Type": "application/json; charset=UTF-8",
		},
		body: JSON.stringify(data),
	};

	const resourceName = window.GetParentResourceName
		? window.GetParentResourceName()
		: "pf_blackmarket";

	try {
		const response = await fetch(
			`https://${resourceName}/${eventName}`,
			options,
		);

		if (!response.ok) {
			throw new Error(`NUI request failed: ${response.status}`);
		}

		return await response.json();
	} catch (error) {
		console.error(`fetchNui error for ${eventName}:`, error);
		throw error;
	}
}
