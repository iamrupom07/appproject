import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../providers/detail_providers.dart';

/// Horizontal scrollable tab bar with an animated gold underline indicator.
/// Drives [detailTabProvider].
class DetailTabBar extends ConsumerWidget {
  const DetailTabBar({super.key});

  static const _tabs = DetailTab.values;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final active = ref.watch(detailTabProvider);

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceMd),
        itemCount: _tabs.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSizes.spaceLg),
        itemBuilder: (context, i) {
          final tab = _tabs[i];
          final isActive = tab == active;
          return _TabItem(
            label: _label(tab),
            isActive: isActive,
            onTap: () => ref.read(detailTabProvider.notifier).state = tab,
          );
        },
      ),
    );
  }

  static String _label(DetailTab tab) => switch (tab) {
        DetailTab.overview => 'Overview',
        DetailTab.specifications => 'Specifications',
        DetailTab.features => 'Features',
        DetailTab.shipping => 'Shipping',
        DetailTab.condition => 'Condition',
      };
}

// ─── Single Tab Item ──────────────────────────────────────────────────────────

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: isActive
                ? AppTextStyles.headingSmall.copyWith(fontSize: 14)
                : AppTextStyles.bodySmall.copyWith(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
            child: Text(label),
          ),
          const SizedBox(height: 4),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 2,
            width: isActive ? 24 : 0,
            decoration: BoxDecoration(
              color: AppColors.gold,
              borderRadius: BorderRadius.circular(AppSizes.radiusPill),
            ),
          ),
        ],
      ),
    );
  }
}
