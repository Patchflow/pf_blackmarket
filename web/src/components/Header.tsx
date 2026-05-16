import { Badge } from "@mantine/core";
import { ShoppingBasketIcon, XIcon } from "lucide-react";
import { useCartCount, useCartStore } from "@/stores/useCartStore";
import { useNuiStore } from "@/stores/useNuiStore";

export default function Header() {
	const { close } = useNuiStore();
	const { open } = useCartStore();
	const itemCount = useCartCount();

	return (
		<header className="h-14 shrink-0 w-full border-b border-b-dark-5">
			<div className="flex h-full items-center w-full px-6 justify-between">
				<div>
				</div>
				<div className="flex items-center gap-4">
					<div className="relative">
						<ShoppingBasketIcon
							className="cursor-pointer transition-transform duration-150 hover:scale-110"
							onClick={open}
							size={20}
						/>
						<div className="absolute -right-1.5 -top-1.5 pointer-events-none">
							{itemCount > 0 && (
								<div key={itemCount} className="animate-badge-pop">
									<Badge fz={"xs"} fw={400} size="sm" circle>
										{itemCount}
									</Badge>
								</div>
							)}
						</div>
					</div>
					<XIcon className="cursor-pointer transition-transform duration-150 hover:scale-110" onClick={close} size={20} />
				</div>
			</div>
		</header>
	);
}
