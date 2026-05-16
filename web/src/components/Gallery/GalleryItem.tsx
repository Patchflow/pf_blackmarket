import { ActionIcon, Button, NumberInput, Text } from "@mantine/core";
import { MinusIcon, PlusIcon, ShoppingBasketIcon } from "lucide-react";
import { useState } from "react";
import { useTranslation } from "@/hooks/useTranslation";
import { useCartStore } from "@/stores/useCartStore";
import type { IConfigItem } from "@/stores/useConfigStore";
import { validateItemQuantity } from "@/utils/itemQuantity";

interface GalleryItemProps extends IConfigItem {
	imageUrl: string;
}

export default function GalleryItem(props: GalleryItemProps) {
	const { addItem } = useCartStore();
	const { t } = useTranslation();

	const [quantity, setQuantity] = useState(1);

	const onQuantityChange = (val: string | number | undefined) => {
		const quantity = validateItemQuantity(val, props.maxAmount);
		if (quantity === null) return;

		setQuantity(quantity);
	};

	return (
		<div className="flex flex-col border border-dark-7 w-full rounded-lg overflow-hidden h-full hover:border-[rgba(74,192,247,0.25)] transition-all duration-200">
			<div className="relative item-gradient h-40 flex items-center justify-center">
				<img
					className="object-cover"
					alt=""
					src={`${props.imageUrl}/${props.name}.png`}
				/>
			</div>
			<div className="flex flex-col gap-3 p-3 bg-dark-8">
				<div className="flex justify-between items-baseline">
					<Text fw={500} size="sm">
						{props.label}
					</Text>
					<Text c="blue.4" size="sm">
						{t("ui.price", props.price)}
					</Text>
				</div>
				<div className="flex items-center gap-2">
					<div className="flex w-full gap-1">
						<ActionIcon
							w={30}
							h={30}
							color="#1A1B1E"
							styles={{ root: { transform: "none" } }}
							className="shrink-0"
							disabled={quantity <= 1}
							onClick={() => onQuantityChange(quantity - 1)}
						>
							<MinusIcon size={14} />
						</ActionIcon>
						<NumberInput
							variant="filled"
							defaultValue={1}
							min={1}
							value={quantity}
							clampBehavior="strict"
							onChange={onQuantityChange}
							max={props.maxAmount}
							classNames={{
								input:
									"!h-[30px] !min-h-[30px] !bg-dark-7 !border-0 !text-center",
							}}
							hideControls
						/>
						<ActionIcon
							w={30}
							h={30}
							color="#1A1B1E"
							styles={{ root: { transform: "none" } }}
							className="shrink-0"
							disabled={quantity >= props.maxAmount}
							onClick={() => onQuantityChange(quantity + 1)}
						>
							<PlusIcon size={14} />
						</ActionIcon>
					</div>
					<div className="shrink-0">
						<Button
							h={30}
							fw={400}
							size="xs"
							variant="light"
							color="blue"
							leftSection={<ShoppingBasketIcon size={14} />}
							onClick={() => addItem(props.name, quantity)}
						>
							{t("item.add_to_cart")}
						</Button>
					</div>
				</div>
			</div>
		</div>
	);
}
