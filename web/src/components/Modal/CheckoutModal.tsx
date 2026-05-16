import { Button, Divider, Image, Modal, ScrollAreaAutosize, Text, Alert } from "@mantine/core";
import { AlertCircleIcon } from "lucide-react";
import { useTranslation } from "@/hooks/useTranslation";
import { cartItemKey, useCartStore, useCartTotal } from "@/stores/useCartStore";
import { useCheckoutStore } from "@/stores/useCheckoutStore";
import { useConfigStore } from "@/stores/useConfigStore";
import type { LocaleKey } from "@/stores/useConfigStore";

export default function CheckoutModal() {
	const { imageUrl } = useConfigStore();
	const { items, close: closeCart } = useCartStore();
	const { opened, close, processPurchase, isProcessing, error, clearError } = useCheckoutStore();
	const cartTotal = useCartTotal();
	const { t } = useTranslation();

	const handleConfirmPurchase = async () => {
		const success = await processPurchase();
		if (success) {
			closeCart();
			close();
		}
	};

	const handleClose = () => {
		clearError();
		close();
	};

	return (
		<Modal
			opened={opened}
			onClose={handleClose}
			closeOnEscape={false}
			title={
				<Text fw={500} size="lg">
					{t("cart.checkout")}
				</Text>
			}
			centered
			size="md"
			classNames={{
				content: "!bg-dark-9 !rounded-md",
				header: "!bg-dark-9 !rounded-md",
				body: "!bg-dark-9 !rounded-md",
			}}
		>
			{error && (
				<Alert
					icon={<AlertCircleIcon size={16} />}
					title={t("error.purchase_failed")}
					color="red"
					withCloseButton
					onClose={clearError}
					mb="xs"
				>
					{t(`error.${error}` as LocaleKey)}
				</Alert>
			)}

			<ScrollAreaAutosize
				mah={400}
				classNames={{
					thumb: "!bg-[#1a1b1e]",
				}}
				scrollbarSize={5}
				offsetScrollbars
			>
				<div className="flex flex-col">
					{items.map((item, index) => (
						<div key={cartItemKey(item.name, item.category)}>
							<div className="flex items-center gap-3 py-3">
								<div className="relative h-16 shrink-0 w-16 flex p-1 items-center justify-center">
									<Image
										alt={item.label}
										src={`${imageUrl}/${item.name}.png`}
										fallbackSrc="https://docs.fivem.net/weapons/WEAPON_PISTOL.png"
									/>
								</div>
								<div className="flex flex-col gap-1 flex-1">
									<Text fw={500} size="sm">
										{item.label}
									</Text>
									<Text size="xs" c="dimmed">
										{t("ui.price", item.price)} × {item.quantity}
									</Text>
								</div>
								<Text fw={500} size="sm" c="blue.4">
									{t("ui.price", item.price * item.quantity)}
								</Text>
							</div>
							{index < items.length - 1 && (
								<Divider className="!border-t-dark-6" />
							)}
						</div>
					))}
				</div>
			</ScrollAreaAutosize>

			<Divider my="md" className="!border-t-dark-6" />

			<div className="flex justify-between items-center mb-6">
				<Text size="lg" fw={500}>
					{t("cart.total")}
				</Text>
				<Text size="lg" fw={600} c="blue.4">
					{t("ui.price", cartTotal)}
				</Text>
			</div>

			<div className="flex gap-3">
				<Button
					fullWidth
					variant="default"
					onClick={handleClose}
					disabled={isProcessing}
					fw={400}
				>
					{t("ui.cancel")}
				</Button>
				<Button
					fullWidth
					variant="light"
					color="blue"
					onClick={handleConfirmPurchase}
					loading={isProcessing}
					fw={400}
				>
					{t("ui.confirm_purchase")}
				</Button>
			</div>
		</Modal>
	);
}