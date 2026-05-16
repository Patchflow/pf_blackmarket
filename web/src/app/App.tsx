import { Overlay } from "@mantine/core";
import { useEffect } from "react";
import CartDrawer from "@/components/Cart/CartDrawer";
import ItemGrid from "@/components/Gallery/GalleryGrid";
import Header from "@/components/Header";
import CheckoutModal from "@/components/Modal/CheckoutModal";
import Sidebar from "@/components/Sidebar";
import { NuiCallbackType } from "@/constants/nuiCallbackType";
import { useConfigStore } from "@/stores/useConfigStore";
import { useNuiStore } from "@/stores/useNuiStore";
import { fetchNui } from "@/utils/fetchNui";
import { isEnvBrowser } from "@/utils/isEnvBrowser";

function seedDebugConfig() {
	useConfigStore.getState().setConfig({
		imageUrl: "https://docs.fivem.net/weapons",
		categories: {
			weapons: {
				label: "Weapons",
				icon: "gun",
				items: [
					{ name: "WEAPON_PISTOL", label: "Pistol", price: 2500, maxAmount: 3 },
					{ name: "WEAPON_SMG", label: "SMG", price: 7800, maxAmount: 2 },
					{ name: "WEAPON_CARBINERIFLE", label: "Carbine Rifle", price: 14500, maxAmount: 1 },
					{ name: "WEAPON_PUMPSHOTGUN", label: "Pump Shotgun", price: 9200, maxAmount: 2 },
					{ name: "WEAPON_SNIPERRIFLE", label: "Sniper Rifle", price: 21000, maxAmount: 1 },
					{ name: "WEAPON_MICROSMG", label: "Micro SMG", price: 5400, maxAmount: 3 },
				],
			},
			ammo: {
				label: "Ammunition",
				icon: "box",
				items: [
					{ name: "WEAPON_PISTOL", label: "9mm Rounds", price: 120, maxAmount: 20 },
					{ name: "WEAPON_SMG", label: "SMG Ammo", price: 200, maxAmount: 15 },
					{ name: "WEAPON_CARBINERIFLE", label: "Rifle Ammo", price: 350, maxAmount: 10 },
					{ name: "WEAPON_PUMPSHOTGUN", label: "Shotgun Shells", price: 180, maxAmount: 15 },
				],
			},
			armor: {
				label: "Protection",
				icon: "shield",
				items: [
					{ name: "WEAPON_PISTOL", label: "Body Armor", price: 3200, maxAmount: 5 },
					{ name: "WEAPON_SMG", label: "Heavy Armor", price: 6500, maxAmount: 3 },
				],
			},
			misc: {
				label: "Miscellaneous",
				icon: "wrench",
				items: [
					{ name: "WEAPON_PISTOL", label: "Lockpick", price: 450, maxAmount: 10 },
					{ name: "WEAPON_SMG", label: "Radio Jammer", price: 8900, maxAmount: 1 },
					{ name: "WEAPON_CARBINERIFLE", label: "GPS Tracker", price: 1200, maxAmount: 5 },
				],
			},
		},
		locale: {} as Record<string, string>,
	});
}

export default function App() {
	const { visible } = useNuiStore();

	useEffect(() => {
		if (isEnvBrowser()) {
			seedDebugConfig();
			return;
		}
		fetchNui(NuiCallbackType.REQUEST_CONFIG).catch(console.error);
	}, []);

	return (
		<div
			style={{
				opacity: visible ? 1 : isEnvBrowser() ? 1 : 0,
			}}
			className="h-screen duration-300 flex flex-col items-center justify-center"
		>
			<Overlay zIndex={0} opacity={0.75} />

			<div
				style={{
					height: 800,
					width: 1200,
				}}
				className="relative z-10 flex-col bg-dark-9 overflow-hidden rounded-xl border border-dark-6"
			>
				<div className="flex h-full w-full">
					<Sidebar />
					<div className="relative h-full flex w-full flex-col">
						<Header />

						<div className="relative flex flex-col h-[calc(100%-56px)] w-full p-5">
							<ItemGrid />
						</div>
					</div>
				</div>

				<CartDrawer />
				<CheckoutModal />
			</div>
		</div>
	);
}