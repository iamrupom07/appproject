import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../domain/inventory_filter_model.dart';
import '../providers/inventory_providers.dart';

/// Shows the filter bottom sheet and returns when dismissed.
/// Call via [showFilterBottomSheet].
Future<void> showFilterBottomSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _FilterBottomSheet(),
  );
}

// ─── Sheet widget ──────────────────────────────────────────────────────────────

class _FilterBottomSheet extends ConsumerStatefulWidget {
  const _FilterBottomSheet();

  @override
  ConsumerState<_FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends ConsumerState<_FilterBottomSheet> {
  late InventoryFilters _draft;

  @override
  void initState() {
    super.initState();
    // Start with a copy of current filters so the user can cancel
    _draft = ref.read(inventoryFiltersProvider);
  }

  void _apply() {
    final notifier = ref.read(inventoryFiltersProvider.notifier);
    notifier.setBrand(_draft.brand);
    notifier.setCondition(_draft.condition);
    notifier.setAvailability(_draft.availability);
    notifier.setSort(_draft.sort);
    Navigator.of(context).pop();
  }

  void _reset() => setState(() => _draft = const InventoryFilters());

  int get _activeCount {
    int count = 0;
    if (_draft.brand != BrandFilter.all) count++;
    if (_draft.condition != ConditionFilter.all) count++;
    if (_draft.availability != AvailabilityFilter.all) count++;
    if (_draft.sort != SortOption.relevance) count++;
    return count;
  }

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      margin: EdgeInsets.only(bottom: bottomPad),
      decoration: const BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Drag handle ──────────────────────────────────────────────────
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 4),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // ── Header ───────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.spaceMd, AppSizes.spaceSm, AppSizes.spaceSm, 0),
            child: Row(
              children: [
                Text('Refine Search', style: AppTextStyles.headingMedium),
                const Spacer(),
                if (_activeCount > 0)
                  TextButton(
                    onPressed: _reset,
                    child: Text(
                      'Clear all',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.gold,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 20),
                  color: AppColors.textSecondary,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: AppColors.divider),

          // ── Filter sections ───────────────────────────────────────────────
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.spaceMd, vertical: AppSizes.spaceSm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sort
                  _SectionTitle(title: 'Sort By'),
                  const SizedBox(height: AppSizes.spaceSm),
                  _ChipGroup<SortOption>(
                    values: SortOption.values,
                    selected: _draft.sort,
                    label: (v) => v.label,
                    onSelected: (v) => setState(() => _draft = _draft.copyWith(sort: v)),
                  ),

                  const SizedBox(height: AppSizes.spaceMd),

                  // Brand
                  _SectionTitle(title: 'Brand'),
                  const SizedBox(height: AppSizes.spaceSm),
                  _ChipGroup<BrandFilter>(
                    values: BrandFilter.values,
                    selected: _draft.brand,
                    label: (v) => v.label,
                    onSelected: (v) => setState(() => _draft = _draft.copyWith(brand: v)),
                  ),

                  const SizedBox(height: AppSizes.spaceMd),

                  // Condition
                  _SectionTitle(title: 'Condition'),
                  const SizedBox(height: AppSizes.spaceSm),
                  _ChipGroup<ConditionFilter>(
                    values: ConditionFilter.values,
                    selected: _draft.condition,
                    label: (v) => v.label,
                    onSelected: (v) =>
                        setState(() => _draft = _draft.copyWith(condition: v)),
                  ),

                  const SizedBox(height: AppSizes.spaceMd),

                  // Availability
                  _SectionTitle(title: 'Availability'),
                  const SizedBox(height: AppSizes.spaceSm),
                  _ChipGroup<AvailabilityFilter>(
                    values: AvailabilityFilter.values,
                    selected: _draft.availability,
                    label: (v) => v.label,
                    onSelected: (v) =>
                        setState(() => _draft = _draft.copyWith(availability: v)),
                  ),

                  const SizedBox(height: AppSizes.spaceLg),
                ],
              ),
            ),
          ),

          // ── Apply button ─────────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(AppSizes.spaceMd, 0, AppSizes.spaceMd,
                AppSizes.spaceMd + MediaQuery.of(context).padding.bottom),
            child: GestureDetector(
              onTap: _apply,
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.gold,
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.gold.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    _activeCount > 0
                        ? 'Apply Filters ($_activeCount active)'
                        : 'Apply Filters',
                    style: AppTextStyles.headingSmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Section Title ────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTextStyles.headingSmall.copyWith(
        fontSize: 13,
        color: AppColors.textSecondary,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

// ─── Generic Chip Group ───────────────────────────────────────────────────────

class _ChipGroup<T> extends StatelessWidget {
  const _ChipGroup({
    required this.values,
    required this.selected,
    required this.label,
    required this.onSelected,
  });

  final List<T> values;
  final T selected;
  final String Function(T) label;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: values.map((v) {
        final isSelected = v == selected;
        return GestureDetector(
          onTap: () => onSelected(v),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.gold : AppColors.pageBackground,
              borderRadius: BorderRadius.circular(AppSizes.radiusPill),
              border: Border.all(
                color: isSelected ? AppColors.gold : AppColors.divider,
                width: 1.5,
              ),
            ),
            child: Text(
              label(v),
              style: AppTextStyles.labelSmall.copyWith(
                color: isSelected ? Colors.white : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
