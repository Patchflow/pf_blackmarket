import { ActionIcon, Divider, Image, NumberInput, Text } from "@mantine/core";
import { ChevronDownIcon, ChevronUpIcon, Trash2Icon } from "lucide-react";
import { useTranslation } from "@/hooks/useTranslation";
import { useCartStore } from "@/stores/useCartStore";
import { validateItemQuantity } from "@/utils/itemQuantity";

interface CartItemProps {
	name: string;
	label: string;
	price: number;
	quantity: number;
	maxAmount: number;
	category: string;
	imageUrl: string | null;
}

export default function CartItem(props: CartItemProps) {
	const { removeItem, updateQuantity } = useCartStore();
	const { t } = useTranslation();

	const onQuantityChange = (val: string | number | undefined) => {
		const quantityValidated = validateItemQuantity(val, props.maxAmount);
		if (quantityValidated === null) return;
		updateQuantity(props.name, props.category, quantityValidated);
	};

	return (
		<div className="flex flex-col gap-3 pr-1.5">
			<div className="flex items-center gap-3 group">
				<div className="relative h-12 shrink-0 w-12 flex p-1 items-center justify-center">
					<Image
						alt=""
						src={`${props.imageUrl}/${props.name}.png`}
						fallbackSrc="https://docs.fivem.net/weapons/WEAPON_PISTOL.png"
						className="group-hover:opacity-25"
					/>
					<button
						type="button"
						onClick={() => removeItem(props.name, props.category)}
						className="absolute cursor-pointer top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 opacity-0 group-hover:opacity-100 transition-opacity duration-200"
					>
						<Trash2Icon size={20} className="text-red-400" />
					</button>
				</div>
				<div className="flex gap-2 justify-between items-center w-full">
					<div className="flex flex-col gap-2">
						<Text fw={500} size="sm">
							{props.label}
						</Text>
						<Divider />
						<Text size="sm">
							{t("ui.price", props.price)}
						</Text>
					</div>
					<div className="flex items-center gap-4">
						<div className="flex flex-col w-full">
							<ActionIcon
								w={60}
								h={16}
								color="#c1c2c5"
								variant="transparent"
								styles={{ root: { transform: "none" } }}
								className="shrink-0"
								onClick={() => updateQuantity(props.name, props.category, props.quantity + 1)}
							>
								<ChevronUpIcon size={16} />
							</ActionIcon>
							<NumberInput
								variant="filled"
								w={60}
								defaultValue={1}
								value={props.quantity}
								min={1}
								max={props.maxAmount}
								clampBehavior="strict"
								allowDecimal={false}
								allowNegative={false}
								allowLeadingZeros={false}
								onChange={onQuantityChange}
								classNames={{
									input:
										"!h-[20px] !min-h-[20px] !bg-transparent !border-0 !text-center",
								}}
								hideControls
							/>
							<ActionIcon
								w={60}
								h={16}
								color="#c1c2c5"
								variant="transparent"
								styles={{ root: { transform: "none" } }}
								className="shrink-0"
								onClick={() => updateQuantity(props.name, props.category, props.quantity - 1)}
							>
								<ChevronDownIcon size={16} />
							</ActionIcon>
						</div>
					</div>
				</div>
			</div>
			<Divider className="!border-t-dark-6" />
		</div>
	);
}