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

/// Horizontal scrollable category icon tabs driven by real API data.
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
        // Build tabs: "All" first, then one per real API category
        final tabs = <_TabData>[
          const _TabData(
            id: null,
            label: 'All',
            icon: Icons.apps_rounded,
            category: MachineCategory.all,
          ),
          ...categories.map(_tabFromDto),
        ];

        return SizedBox(
          height: 108,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceMd),
            itemCount: tabs.length,
            itemBuilder: (context, index) {
              final tab = tabs[index];
              final isSelected = _isSelected(selected, tab);
              return _CategoryTabItem(
                item: tab,
                isSelected: isSelected,
                onTap: () {
                  _openInventoryForSelection(
                    context,
                    ref,
                    _selectionFromTab(tab),
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
    icon: _iconForCategoryName(dto.name),
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

IconData _iconForCategoryName(String name) {
  final n = name.toLowerCase();
  if (n.contains('engine') && n.contains('support')) {
    return Icons.support_rounded;
  }
  if (n.contains('engine')) return Icons.settings_rounded;
  if (n.contains('hydraulic') && n.contains('pump')) {
    return Icons.compress_rounded;
  }
  if (n.contains('hydraulic')) return Icons.water_rounded;
  if (n.contains('undercarriage')) return Icons.layers_rounded;
  if (n.contains('chassis')) return Icons.architecture_rounded;
  if (n.contains('electrical') || n.contains('cabin')) {
    return Icons.electrical_services_rounded;
  }
  if (n.contains('ground')) return Icons.hardware_rounded;
  if (n.contains('arm') || n.contains('boom') || n.contains('bucket')) {
    return Icons.precision_manufacturing_rounded;
  }
  if (n.contains('control') || n.contains('valve') || n.contains('pump')) {
    return Icons.tune_rounded;
  }
  if (n.contains('radiator')) return Icons.device_thermostat_rounded;
  if (n.contains('swing')) return Icons.rotate_right_rounded;
  if (n.contains('turn') || n.contains('table')) return Icons.sync_rounded;
  if (n.contains('dozer')) return Icons.construction_rounded;
  return Icons.category_rounded;
}

// ─── Tab Item ─────────────────────────────────────────────────────────────────

class _TabData {
  const _TabData({
    required this.id,
    required this.label,
    required this.icon,
    this.category,
  });

  final String? id; // null = "All"
  final String label;
  final IconData icon;
  final MachineCategory? category;
}

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
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 82,
        margin: const EdgeInsets.only(right: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Icon box ──────────────────────────────────────────────────────
            Stack(
              clipBehavior: Clip.none,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.gold.withValues(alpha: 0.2)
                        : AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected ? AppColors.gold : AppColors.divider,
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.gold.withValues(alpha: 0.28),
                              blurRadius: 14,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                  ),
                  child: Center(
                    child: Icon(
                      item.icon,
                      size: isSelected ? 28 : 26,
                      color:
                          isSelected ? AppColors.gold : AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 7),

            // ── Label ─────────────────────────────────────────────────────────
            Text(
              item.label,
              style: AppTextStyles.labelSmall.copyWith(
                color: isSelected ? AppColors.gold : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w400,
                fontSize: 11,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 5),

            // ── Active indicator dot ───────────────────────────────────────────
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              width: isSelected ? 22 : 6,
              height: 3,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.gold
                    : AppColors.divider.withValues(alpha: 0),
                borderRadius: BorderRadius.circular(AppSizes.radiusPill),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Shimmer Skeleton ─────────────────────────────────────────────────────────

class _CategoryShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 108,
      child: Shimmer.fromColors(
        baseColor: AppColors.shimmerBase,
        highlightColor: AppColors.shimmerHighlight,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceMd),
          itemCount: 6,
          itemBuilder: (_, __) => Container(
            width: 82,
            margin: const EdgeInsets.only(right: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.shimmerBase,
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                const SizedBox(height: 7),
                Container(
                  width: 50,
                  height: 10,
                  decoration: BoxDecoration(
                    color: AppColors.shimmerBase,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
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
        icon: Icons.apps_rounded,
        category: MachineCategory.all,
      ),
      _TabData(
        id: null,
        label: 'Engine Parts',
        icon: Icons.settings_rounded,
        category: MachineCategory.engineParts,
      ),
      _TabData(
        id: null,
        label: 'Hydraulics',
        icon: Icons.water_rounded,
        category: MachineCategory.hydraulics,
      ),
      _TabData(
        id: null,
        label: 'Undercarriage',
        icon: Icons.layers_rounded,
        category: MachineCategory.undercarriage,
      ),
      _TabData(
          id: null,
          label: 'Ground Engaging Tools',
          icon: Icons.hardware_rounded,
          category: MachineCategory.groundEngaging),
      _TabData(
          id: null,
          label: 'Electrical',
          icon: Icons.electrical_services_rounded,
          category: MachineCategory.electrical),
    ];

    return SizedBox(
      height: 108,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceMd),
        itemCount: staticCategories.length,
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
