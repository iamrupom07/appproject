import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../domain/machine_model.dart';
import '../providers/home_providers.dart';

/// Horizontal scrollable category icon tabs.
class CategoryTabRow extends ConsumerWidget {
  const CategoryTabRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedCategoryProvider);

    return SizedBox(
      height:
          108, // enough for icon (60) + gap (6) + label (24) + dot (8) + breathing room
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceMd),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final item = _categories[index];
          final isSelected = selected == item.category;
          return _CategoryTabItem(
            item: item,
            isSelected: isSelected,
            onTap: () => ref.read(selectedCategoryProvider.notifier).state =
                item.category,
          );
        },
      ),
    );
  }
}

// ─── Tab Item ─────────────────────────────────────────────────────────────────

class _CategoryTabItem extends StatelessWidget {
  const _CategoryTabItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final _CategoryData item;
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
                        ? AppColors.gold.withOpacity(0.12)
                        : AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected ? AppColors.gold : AppColors.divider,
                      width: isSelected ? 1.5 : 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.gold.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                  ),
                  child: Center(
                    child: Icon(
                      item.icon,
                      size: 26,
                      color:
                          isSelected ? AppColors.gold : AppColors.textSecondary,
                    ),
                  ),
                ),

                // "NEW" badge
                if (item.isNew)
                  Positioned(
                    top: -5,
                    right: -5,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.textPrimary,
                        borderRadius:
                            BorderRadius.circular(AppSizes.radiusPill),
                        border: Border.all(
                          color: AppColors.pageBackground,
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        'NEW',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.textOnDark,
                          fontSize: 7,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.3,
                        ),
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
                color: isSelected
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
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
              width: isSelected ? 18 : 0,
              height: 3,
              decoration: BoxDecoration(
                color: AppColors.gold,
                borderRadius: BorderRadius.circular(AppSizes.radiusPill),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Category Data ────────────────────────────────────────────────────────────

class _CategoryData {
  const _CategoryData({
    required this.category,
    required this.label,
    required this.icon,
    this.isNew = false,
  });

  final MachineCategory category;
  final String label;
  final IconData icon;
  final bool isNew;
}

const List<_CategoryData> _categories = [
  _CategoryData(
    category: MachineCategory.engineParts,
    label: 'Engine\nParts',
    icon: Icons.settings_rounded,
  ),
  _CategoryData(
    category: MachineCategory.hydraulics,
    label: 'Hydraulics',
    icon: Icons.water_rounded,
  ),
  _CategoryData(
    category: MachineCategory.undercarriage,
    label: 'Under-\ncarriage',
    icon: Icons.layers_rounded,
  ),
  _CategoryData(
    category: MachineCategory.groundEngaging,
    label: 'Ground\nEngaging',
    icon: Icons.hardware_rounded,
  ),
  _CategoryData(
    category: MachineCategory.electrical,
    label: 'Electrical',
    icon: Icons.electrical_services_rounded,
    isNew: true,
  ),
];
