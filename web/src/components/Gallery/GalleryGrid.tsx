import { ScrollAreaAutosize, Text } from "@mantine/core";
import { PackageOpenIcon, LayoutGridIcon } from "lucide-react";
import Item from "@/components/Gallery/GalleryItem";
import { useTranslation } from "@/hooks/useTranslation";
import { useConfigStore } from "@/stores/useConfigStore";

export default function GalleryGrid() {
	const { categories, activeCategoryId, imageUrl } = useConfigStore();
	const { t } = useTranslation();

	const activeCategory = activeCategoryId ? categories[activeCategoryId] : null;
	const hasItems = activeCategory && activeCategory.items.length > 0 && imageUrl;

	if (!activeCategoryId) {
		return (
			<div className="flex h-full flex-col items-center justify-center gap-3 pb-10 animate-fade-in">
				<LayoutGridIcon size={32} className="text-dark-3" />
				<Text size="sm" c="dimmed">{t("item.select_category")}</Text>
			</div>
		);
	}

	if (!hasItems) {
		return (
			<div className="flex h-full flex-col items-center justify-center gap-3 pb-10 animate-fade-in">
				<PackageOpenIcon size={32} className="text-dark-3" />
				<Text size="sm" c="dimmed">{t("item.empty_category")}</Text>
			</div>
		);
	}

	return (
		<ScrollAreaAutosize
			classNames={{
				thumb: "!bg-[#1a1b1e]",
			}}
			scrollbarSize={5}
			offsetScrollbars={true}
		>
			<div key={activeCategoryId} className="grid grid-cols-3 w-full gap-4 pr-2">
				{activeCategory.items.map((item, index) => (
					<div
						key={item.name}
						className="animate-fade-in-up"
						style={{ animationDelay: `${index * 50}ms` }}
					>
						<Item
							imageUrl={imageUrl}
							name={item.name}
							label={item.label}
							price={item.price}
							maxAmount={item.maxAmount}
						/>
					</div>
				))}
			</div>
		</ScrollAreaAutosize>
	);
}
