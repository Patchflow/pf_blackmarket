import { create } from "zustand";
import { NuiCallbackType } from "@/constants/nuiCallbackType";
import { fetchNui } from "@/utils/fetchNui";

interface NuiState {
	visible: boolean;
	setVisible: (visible: boolean) => void;
	close: () => void;
}

export const useNuiStore = create<NuiState>()((set) => ({
	visible: false,
	setVisible: (visible) => set({ visible }),
	close: () => {
		set({ visible: false });
		fetchNui(NuiCallbackType.NUI_CLOSE).catch(console.error);
	},
}));
