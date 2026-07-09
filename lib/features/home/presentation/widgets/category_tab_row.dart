import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../features/products/data/product_dto.dart';
import '../../../../../features/products/data/product_providers.dart';
import '../../../inventory/presentation/providers/inventory_providers.dart';
import '../../domain/machine_model.dart';
import '../providers/home_providers.dart';

/// Max number of real API categories shown before collapsing the rest
/// into a single "Others" tab.
const int _kMaxVisibleCategories = 5;

/// Sentinel id used to identify the synthetic "Others" tab.
const String _kOthersTabId = '__others__';

/// Horizontal scrollable category text chips driven by real API data.
///
/// Falls back to a shimmer skeleton while loading and gracefully handles
/// errors by showing the static fallback list.
class CategoryTabRow extends ConsumerWidget {
  const CategoryTabRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final selected = ref.watch(selectedCategoryProvider);

    return categoriesAsync.when(
      loading: () => _CategoryShimmer(),
      error: (_, __) => _StaticCategoryTabRow(selected: selected, ref: ref),
      data: (categories) {
        // Only show the first N real categories; anything beyond that is
        // tucked behind a single "Others" tab that opens the Inventory
        // screen, where the full category list is available to filter by.
        final visibleCategories =
            categories.take(_kMaxVisibleCategories).toList();
        final overflowCategories =
            categories.length > _kMaxVisibleCategories
                ? categories.skip(_kMaxVisibleCategories).toList()
                : const <CategoryDto>[];

        // Build tabs: "All" first, then visible API categories, then
        // "Others" if there's overflow.
        final tabs = <_TabData>[
          const _TabData(
            id: null,
            label: 'All',
            category: MachineCategory.all,
          ),
          ...visibleCategories.map(_tabFromDto),
          if (overflowCategories.isNotEmpty)
            const _TabData(
              id: _kOthersTabId,
              label: 'Others',
            ),
        ];

        return SizedBox(
          height: 44,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceMd),
            itemCount: tabs.length,
            separatorBuilder: (_, __) =>
                const SizedBox(width: AppSizes.spaceSm),
            itemBuilder: (context, index) {
              final tab = tabs[index];
              final isOthers = tab.id == _kOthersTabId;
              final isSelected = isOthers
                  ? _isOverflowSelected(selected, overflowCategories)
                  : _isSelected(selected, tab);
              return _CategoryTabItem(
                item: tab,
                isSelected: isSelected,
                onTap: () {
                  _openInventoryForSelection(
                    context,
                    ref,
                    isOthers
                        ? const CategorySelection.all()
                        : _selectionFromTab(tab),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}

// ─── Map CategoryDto → _TabData ───────────────────────────────────────────────

_TabData _tabFromDto(CategoryDto dto) {
  return _TabData(
    id: dto.id,
    label: dto.name,
    category: _matchCategory(dto.name),
  );
}

MachineCategory? _matchCategory(String label) {
  if (label.toLowerCase() == 'all') return MachineCategory.all;
  for (final cat in MachineCategory.values) {
    if (cat.label.toLowerCase() == label.toLowerCase()) return cat;
    if (cat.label.toLowerCase().contains(label.toLowerCase())) return cat;
    if (label.toLowerCase().contains(cat.label.toLowerCase())) return cat;
  }
  return null;
}

bool _isSelected(CategorySelection selected, _TabData tab) {
  if (tab.id != null) return selected.id == tab.id;
  if (tab.category != null) {
    return selected.id == null && selected.category == tab.category;
  }
  return selected.id == null &&
      selected.label.toLowerCase() == tab.label.toLowerCase();
}

/// Whether the current selection matches one of the categories collapsed
/// into the "Others" tab — used to highlight "Others" when the user has
/// filtered by a category that isn't shown directly on the home screen.
bool _isOverflowSelected(
  CategorySelection selected,
  List<CategoryDto> overflowCategories,
) {
  if (selected.id == null) return false;
  return overflowCategories.any((c) => c.id == selected.id);
}

CategorySelection _selectionFromTab(_TabData tab) {
  final id = tab.id;
  if (id != null) {
    return CategorySelection.fromApi(
      id: id,
      label: tab.label,
      category: tab.category,
    );
  }

  final category = tab.category;
  if (category != null) {
    return CategorySelection.fromCategory(category);
  }

  return CategorySelection(label: tab.label);
}

void _openInventoryForSelection(
  BuildContext context,
  WidgetRef ref,
  CategorySelection selection,
) {
  ref.read(selectedCategoryProvider.notifier).state = selection;
  ref.read(inventoryCategoryProvider.notifier).state = selection;
  context.go('/inventory');
}

// ─── Tab Data ─────────────────────────────────────────────────────────────────

class _TabData {
  const _TabData({
    required this.id,
    required this.label,
    this.category,
  });

  final String? id; // null = "All"
  final String label;
  final MachineCategory? category;
}

// ─── Tab Item (text-only pill chip) ──────────────────────────────────────────

class _CategoryTabItem extends StatelessWidget {
  const _CategoryTabItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final _TabData item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.gold : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSizes.radiusPill),
        border: Border.all(
          color: isSelected ? AppColors.gold : AppColors.divider,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSizes.radiusPill),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.spaceMd,
              vertical: AppSizes.spaceXs,
            ),
            child: Center(
              child: Text(
                item.label,
                style: AppTextStyles.labelMedium.copyWith(
                  color: isSelected
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Shimmer Skeleton ─────────────────────────────────────────────────────────

class _CategoryShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const widths = [56.0, 96.0, 88.0, 104.0, 80.0, 92.0];
    return SizedBox(
      height: 44,
      child: Shimmer.fromColors(
        baseColor: AppColors.shimmerBase,
        highlightColor: AppColors.shimmerHighlight,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceMd),
          itemCount: widths.length,
          separatorBuilder: (_, __) =>
              const SizedBox(width: AppSizes.spaceSm),
          itemBuilder: (_, index) => Container(
            width: widths[index],
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.shimmerBase,
              borderRadius: BorderRadius.circular(AppSizes.radiusPill),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Static fallback (used on error) ─────────────────────────────────────────

class _StaticCategoryTabRow extends StatelessWidget {
  const _StaticCategoryTabRow({
    required this.selected,
    required this.ref,
  });

  final CategorySelection selected;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    const staticCategories = [
      _TabData(
        id: null,
        label: 'All',
        category: MachineCategory.all,
      ),
      _TabData(
        id: null,
        label: 'Engine Parts',
        category: MachineCategory.engineParts,
      ),
      _TabData(
        id: null,
        label: 'Hydraulics',
        category: MachineCategory.hydraulics,
      ),
      _TabData(
        id: null,
        label: 'Undercarriage',
        category: MachineCategory.undercarriage,
      ),
      _TabData(
        id: null,
        label: 'Ground Engaging Tools',
        category: MachineCategory.groundEngaging,
      ),
      _TabData(
        id: null,
        label: 'Electrical',
        category: MachineCategory.electrical,
      ),
    ];

    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceMd),
        itemCount: staticCategories.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSizes.spaceSm),
        itemBuilder: (context, index) {
          final item = staticCategories[index];
          final isSelected = _isSelected(selected, item);
          return _CategoryTabItem(
            item: item,
            isSelected: isSelected,
            onTap: () {
              _openInventoryForSelection(
                context,
                ref,
                _selectionFromTab(item),
              );
            },
          );
        },
      ),
    );
  }
}
