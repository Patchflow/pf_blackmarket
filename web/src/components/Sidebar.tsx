import { NavLink, ScrollAreaAutosize, Text } from "@mantine/core";
import type { IconProp } from "@fortawesome/fontawesome-svg-core";
import FaIcon from "@/components/FaIcon";
import { useTranslation } from "@/hooks/useTranslation";
import { useConfigStore } from "@/stores/useConfigStore";

export default function Sidebar() {
	const { categories, setActiveCategoryId, activeCategoryId } =
		useConfigStore();
	const { t } = useTranslation();

	return (
		<aside style={{ width: 240 }} className="flex flex-col h-full border-r border-r-dark-6">
			<div className="flex h-14 items-center px-5 border-b shrink-0 border-b-dark-5">
				<Text c="dimmed" fw={600} size="sm">
					{t("ui.blackmarket")}
				</Text>
			</div>
			<div className="flex h-[calc(100%-56px)] flex-col px-4 py-5 gap-1">
				<ScrollAreaAutosize
					classNames={{
						thumb: "!bg-[#1a1b1e]",
					}}
					scrollbarSize={5}
					offsetScrollbars={true}
				>
					<div className="flex gap-1 flex-col pr-2">
						{Object.entries(categories).length === 0 ? (
							<div className="flex flex-col items-center justify-center">
								<Text size="xs" c="dimmed">{t("ui.no_categories_hint")}</Text>
							</div>
						) : (
							Object.entries(categories).map(([key, value]) => (
								<NavLink
									key={key}
									label={value.label}
									h={32}
									leftSection={<FaIcon icon={value.icon as IconProp} size="sm" />}
									classNames={{
										root: `rounded-md transition-colors duration-200 ${key === activeCategoryId ? "!bg-dark-7" : "hover:!bg-dark-7"}`,
									}}
									color={key === activeCategoryId ? "blue" : undefined}
									onClick={() => setActiveCategoryId(key)}
								/>
							))
						)}
					</div>
				</ScrollAreaAutosize>
			</div>
		</aside>
	);
}