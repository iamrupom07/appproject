import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../features/home/domain/machine_model.dart';
import '../../../../../features/products/data/product_dto.dart';
import '../../../../../features/products/data/product_providers.dart';
import '../providers/inventory_providers.dart';

/// Horizontally scrollable category chip row for inventory screen.
/// Categories are loaded from the real API; falls back to static list on error.
class InventoryCategoryBar extends ConsumerWidget {
  const InventoryCategoryBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final selected = ref.watch(inventoryCategoryProvider);

    return categoriesAsync.when(
      loading: () => _CategoryBarShimmer(),
      error: (_, __) => _StaticCategoryBar(selected: selected, ref: ref),
      data: (categories) {
        final chips = <_ChipData>[
          const _ChipData(
            label: 'All',
            icon: Icons.grid_view_rounded,
            category: MachineCategory.all,
          ),
          ...categories.map(_chipFromDto),
        ];

        return SizedBox(
          height: 72,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceMd),
            itemCount: chips.length,
            separatorBuilder: (_, __) =>
                const SizedBox(width: AppSizes.spaceSm),
            itemBuilder: (context, index) {
              final chip = chips[index];
              final isActive = _isSelected(selected, chip);
              return _CategoryChip(
                chip: chip,
                isActive: isActive,
                onTap: () {
                  ref.read(inventoryCategoryProvider.notifier).state =
                      _selectionFromChip(chip);
                },
              );
            },
          ),
        );
      },
    );
  }
}

// ─── Helpers ──────────────────────────────────────────────────────────────────

_ChipData _chipFromDto(CategoryDto dto) => _ChipData(
      id: dto.id,
      label: dto.name,
      icon: _iconForName(dto.name),
      category: _matchCategory(dto.name),
    );

MachineCategory? _matchCategory(String label) {
  if (label.toLowerCase() == 'all') return MachineCategory.all;
  for (final cat in MachineCategory.values) {
    if (cat.label.toLowerCase() == label.toLowerCase()) return cat;
    if (cat.label.toLowerCase().contains(label.toLowerCase())) return cat;
    if (label.toLowerCase().contains(cat.label.toLowerCase())) return cat;
  }
  return null;
}

bool _isSelected(CategorySelection selected, _ChipData chip) {
  if (chip.id != null) return selected.id == chip.id;
  if (chip.category != null) {
    return selected.id == null && selected.category == chip.category;
  }
  return selected.id == null &&
      selected.label.toLowerCase() == chip.label.toLowerCase();
}

CategorySelection _selectionFromChip(_ChipData chip) {
  final id = chip.id;
  if (id != null) {
    return CategorySelection.fromApi(
      id: id,
      label: chip.label,
      category: chip.category,
    );
  }

  final category = chip.category;
  if (category != null) {
    return CategorySelection.fromCategory(category);
  }

  return CategorySelection(label: chip.label);
}

IconData _iconForName(String name) {
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
  if (n.contains('control') || n.contains('valve')) return Icons.tune_rounded;
  if (n.contains('radiator')) return Icons.device_thermostat_rounded;
  if (n.contains('swing')) return Icons.rotate_right_rounded;
  if (n.contains('turn') || n.contains('table')) return Icons.sync_rounded;
  if (n.contains('dozer')) return Icons.construction_rounded;
  return Icons.category_rounded;
}

// ─── Data class ───────────────────────────────────────────────────────────────

class _ChipData {
  const _ChipData({
    this.id,
    required this.label,
    required this.icon,
    this.category,
  });

  final String? id;
  final String label;
  final IconData icon;
  final MachineCategory? category;
}

// ─── Chip widget ──────────────────────────────────────────────────────────────

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.chip,
    required this.isActive,
    required this.onTap,
  });

  final _ChipData chip;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: 72,
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.gold.withValues(alpha: 0.22)
              : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          border: Border.all(
            color: isActive ? AppColors.gold : AppColors.divider,
            width: isActive ? 2 : 1,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: AppColors.gold.withValues(alpha: 0.24),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              chip.icon,
              size: 24,
              color: isActive ? AppColors.gold : AppColors.textSecondary,
            ),
            const SizedBox(height: 4),
            Text(
              chip.label,
              style: AppTextStyles.labelSmall.copyWith(
                color: isActive ? AppColors.gold : AppColors.textSecondary,
                fontWeight: isActive ? FontWeight.w800 : FontWeight.w400,
                fontSize: 9.5,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Shimmer ──────────────────────────────────────────────────────────────────

class _CategoryBarShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 72,
      child: Shimmer.fromColors(
        baseColor: AppColors.shimmerBase,
        highlightColor: AppColors.shimmerHighlight,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceMd),
          itemCount: 7,
          separatorBuilder: (_, __) => const SizedBox(width: AppSizes.spaceSm),
          itemBuilder: (_, __) => Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.shimmerBase,
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Static fallback ─────────────────────────────────────────────────────────

class _StaticCategoryBar extends StatelessWidget {
  const _StaticCategoryBar({required this.selected, required this.ref});

  final CategorySelection selected;
  final WidgetRef ref;

  static const _chips = [
    _ChipData(
      label: 'All',
      icon: Icons.grid_view_rounded,
      category: MachineCategory.all,
    ),
    _ChipData(
      label: 'Engine Parts',
      icon: Icons.settings_rounded,
      category: MachineCategory.engineParts,
    ),
    _ChipData(
      label: 'Hydraulics',
      icon: Icons.water_rounded,
      category: MachineCategory.hydraulics,
    ),
    _ChipData(
      label: 'Undercarriage',
      icon: Icons.layers_rounded,
      category: MachineCategory.undercarriage,
    ),
    _ChipData(
      label: 'Chassis',
      icon: Icons.architecture_rounded,
      category: MachineCategory.chassis,
    ),
    _ChipData(
      label: 'Electrical',
      icon: Icons.electrical_services_rounded,
      category: MachineCategory.electrical,
    ),
    _ChipData(
      label: 'Ground Engaging Tools',
      icon: Icons.hardware_rounded,
      category: MachineCategory.groundEngaging,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 72,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceMd),
        itemCount: _chips.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSizes.spaceSm),
        itemBuilder: (context, index) {
          final chip = _chips[index];
          final isActive = _isSelected(selected, chip);
          return _CategoryChip(
            chip: chip,
            isActive: isActive,
            onTap: () {
              ref.read(inventoryCategoryProvider.notifier).state =
                  _selectionFromChip(chip);
            },
          );
        },
      ),
    );
  }
}
