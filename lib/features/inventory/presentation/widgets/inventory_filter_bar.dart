import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../domain/inventory_filter_model.dart';
import '../providers/inventory_providers.dart';

/// Horizontally scrollable row of filter dropdown chips.
/// Each chip opens a bottom-sheet picker for its respective filter.
class InventoryFilterBar extends ConsumerWidget {
  const InventoryFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(inventoryFiltersProvider);
    final notifier = ref.read(inventoryFiltersProvider.notifier);

    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _FilterChip(
              label: filters.brand.label,
              isActive: filters.brand != BrandFilter.all,
              onTap: () => _showBrandSheet(context, ref, notifier),
            ),
          ),
          _Divider(),
          Expanded(
            child: _FilterChip(
              label: filters.condition.label,
              isActive: filters.condition != ConditionFilter.all,
              onTap: () => _showConditionSheet(context, ref, notifier),
            ),
          ),
          _Divider(),
          Expanded(
            child: _FilterChip(
              label: filters.availability.label,
              isActive: filters.availability != AvailabilityFilter.all,
              onTap: () => _showAvailabilitySheet(context, ref, notifier),
            ),
          ),
          _Divider(),
          Expanded(
            child: _SortChip(
              label: filters.sort == SortOption.relevance
                  ? 'Sort'
                  : filters.sort.label,
              isActive: filters.sort != SortOption.relevance,
              onTap: () => _showSortSheet(context, ref, notifier),
            ),
          ),
        ],
      ),
    );
  }

  // ── Bottom Sheet Helpers ────────────────────────────────────────────────────

  void _showBrandSheet(
    BuildContext context,
    WidgetRef ref,
    InventoryFiltersNotifier notifier,
  ) {
    _showPickerSheet<BrandFilter>(
      context: context,
      title: 'Brand',
      options: BrandFilter.values,
      selected: ref.read(inventoryFiltersProvider).brand,
      labelOf: (v) => v.label,
      onSelect: notifier.setBrand,
    );
  }

  void _showConditionSheet(
    BuildContext context,
    WidgetRef ref,
    InventoryFiltersNotifier notifier,
  ) {
    _showPickerSheet<ConditionFilter>(
      context: context,
      title: 'Condition',
      options: ConditionFilter.values,
      selected: ref.read(inventoryFiltersProvider).condition,
      labelOf: (v) => v.label,
      onSelect: notifier.setCondition,
    );
  }

  void _showAvailabilitySheet(
    BuildContext context,
    WidgetRef ref,
    InventoryFiltersNotifier notifier,
  ) {
    _showPickerSheet<AvailabilityFilter>(
      context: context,
      title: 'Availability',
      options: AvailabilityFilter.values,
      selected: ref.read(inventoryFiltersProvider).availability,
      labelOf: (v) => v.label,
      onSelect: notifier.setAvailability,
    );
  }

  void _showSortSheet(
    BuildContext context,
    WidgetRef ref,
    InventoryFiltersNotifier notifier,
  ) {
    _showPickerSheet<SortOption>(
      context: context,
      title: 'Sort by',
      options: SortOption.values,
      selected: ref.read(inventoryFiltersProvider).sort,
      labelOf: (v) => v.label,
      onSelect: notifier.setSort,
    );
  }

  void _showPickerSheet<T>({
    required BuildContext context,
    required String title,
    required List<T> options,
    required T selected,
    required String Function(T) labelOf,
    required void Function(T) onSelect,
  }) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusLg),
        ),
      ),
      builder: (_) => _PickerSheet<T>(
        title: title,
        options: options,
        selected: selected,
        labelOf: labelOf,
        onSelect: (v) {
          onSelect(v);
          Navigator.pop(context);
        },
      ),
    );
  }
}

// ─── Filter Chip ──────────────────────────────────────────────────────────────

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                label,
                style: AppTextStyles.labelSmall.copyWith(
                  color: isActive ? AppColors.gold : AppColors.textSecondary,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  fontSize: 11,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 2),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 14,
              color: isActive ? AppColors.gold : AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Sort Chip (uses different icon) ─────────────────────────────────────────

class _SortChip extends StatelessWidget {
  const _SortChip({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.swap_vert_rounded,
              size: 14,
              color: isActive ? AppColors.gold : AppColors.textSecondary,
            ),
            const SizedBox(width: 3),
            Flexible(
              child: Text(
                label,
                style: AppTextStyles.labelSmall.copyWith(
                  color: isActive ? AppColors.gold : AppColors.textSecondary,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  fontSize: 11,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Vertical Divider ─────────────────────────────────────────────────────────

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 20,
      color: AppColors.divider,
    );
  }
}

// ─── Picker Bottom Sheet ──────────────────────────────────────────────────────

class _PickerSheet<T> extends StatelessWidget {
  const _PickerSheet({
    required this.title,
    required this.options,
    required this.selected,
    required this.labelOf,
    required this.onSelect,
  });

  final String title;
  final List<T> options;
  final T selected;
  final String Function(T) labelOf;
  final void Function(T) onSelect;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSizes.spaceMd,
          AppSizes.spaceMd,
          AppSizes.spaceMd,
          AppSizes.spaceSm,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(AppSizes.radiusPill),
                ),
              ),
            ),
            const SizedBox(height: AppSizes.spaceMd),
            Text(title, style: AppTextStyles.headingMedium),
            const SizedBox(height: AppSizes.spaceSm),
            ...options.map(
              (opt) => ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  labelOf(opt),
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight:
                        opt == selected ? FontWeight.w600 : FontWeight.w400,
                    color: opt == selected
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                  ),
                ),
                trailing: opt == selected
                    ? const Icon(
                        Icons.check_rounded,
                        color: AppColors.gold,
                        size: 20,
                      )
                    : null,
                onTap: () => onSelect(opt),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
