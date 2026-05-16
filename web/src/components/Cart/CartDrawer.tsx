import { Button, Drawer, ScrollAreaAutosize, Text } from "@mantine/core";
import { ShoppingBasketIcon, XIcon } from "lucide-react";
import CartItem from "@/components/Cart/CartItem";
import { useTranslation } from "@/hooks/useTranslation";
import { cartItemKey, useCartStore, useCartTotal } from "@/stores/useCartStore";
import { useCheckoutStore } from "@/stores/useCheckoutStore";
import { useConfigStore } from "@/stores/useConfigStore";

export default function CartDrawer() {
	const { imageUrl } = useConfigStore();
	const { items, opened, close } = useCartStore();
	const { open: openCheckout } = useCheckoutStore();
	const cartTotal = useCartTotal();
	const { t } = useTranslation();

	return (
		<Drawer.Root
			opened={opened}
			onClose={close}
			closeOnEscape={false}
			position="right"
			size={335}
			withinPortal={false}
			classNames={{
				inner: "!absolute",
				overlay: "!absolute",
				content: "!bg-dark-9",
			}}
		>
			<Drawer.Overlay backgroundOpacity={0.3} />
			<Drawer.Content radius={"lg"}>
				<Drawer.Header
					h={56}
					mih={56}
					className="!bg-dark-9 border-b-dark-7 border-b"
				>
					<Drawer.Title>
						<Text fw={500} size="sm">
							{t("ui.cart")}
						</Text>
					</Drawer.Title>
					<XIcon className="cursor-pointer transition-transform duration-150 hover:scale-110" onClick={close} size={20} />
				</Drawer.Header>
				<Drawer.Body p={16} pr={6} className="h-[calc(100%-56px)]">
					{items.length === 0 ? (
						<div className="flex h-full pb-14 flex-col items-center justify-center gap-2 animate-fade-in">
							<ShoppingBasketIcon size={28} className="text-dark-3 mb-1" />
							<Text size="sm" fw={500}>{t("ui.cart_empty")}</Text>
							<Text size="xs" c="dimmed">{t("ui.cart_empty_hint")}</Text>
						</div>
					) : (
						<div className="relative flex flex-col h-full gap-3">
							<ScrollAreaAutosize
								classNames={{
									thumb: "!bg-[#1a1b1e]",
								}}
								scrollbarSize={5}
								offsetScrollbars={true}
							>
								<div className="flex flex-col gap-3">
									{items.map((item) => (
										<CartItem
											key={cartItemKey(item.name, item.category)}
											name={item.name}
											label={item.label}
											price={item.price}
											quantity={item.quantity}
											maxAmount={item.maxAmount}
											category={item.category}
											imageUrl={imageUrl}
										/>
									))}
								</div>
							</ScrollAreaAutosize>
							<div className="flex flex-col mt-auto justify-end pr-2 w-full bg-dark-9 gap-3 pt-3 border-t border-t-dark-6">
								<div className="flex justify-between">
									<Text size="sm">{t("cart.total")}</Text>
									<Text size="sm" c="blue.4" fw={500}>
										{t("ui.price", cartTotal)}
									</Text>
								</div>
								<Button fw={400} fullWidth variant="light" color="blue" onClick={openCheckout}>
									{t("cart.checkout")}
								</Button>
							</div>
						</div>
					)}
				</Drawer.Body>
			</Drawer.Content>
		</Drawer.Root>
	);
}