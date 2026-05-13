import 'package:ab_abroz_inventory/features/home/presentation/providers/home_providers.dart';
import 'package:ab_abroz_inventory/features/home/presentation/widgets/category_chip_row.dart';
import 'package:ab_abroz_inventory/features/home/presentation/widgets/filter_fab.dart';
import 'package:ab_abroz_inventory/features/home/presentation/widgets/home_search_bar.dart';
import 'package:ab_abroz_inventory/features/home/presentation/widgets/machine_list_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';

/// Home screen — thin orchestration layer only.
/// All logic lives in providers; all UI atoms live in widgets.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final machines = ref.watch(filteredMachinesProvider);
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: Stack(
        children: [
          // ── Main Scrollable Content ────────────────────────────────────────
          CustomScrollView(
            slivers: [
              // ── Sticky App Bar ─────────────────────────────────────────────
              SliverPersistentHeader(
                pinned: true,
                delegate: _StickyHeaderDelegate(
                  topPadding: topPadding,
                  child: _HomeHeader(topPadding: topPadding),
                ),
              ),

              // ── Category Chips ─────────────────────────────────────────────
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: AppSizes.spaceSm,
                    bottom: AppSizes.spaceMd,
                  ),
                  child: CategoryChipRow(),
                ),
              ),

              // ── Machine List ───────────────────────────────────────────────
              machines.isEmpty
                  ? const SliverFillRemaining(
                      hasScrollBody: false,
                      child: _EmptyState(),
                    )
                  : SliverPadding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSizes.spaceMd,
                        0,
                        AppSizes.spaceMd,
                        // Extra bottom padding so FAB doesn't cover last card
                        80 + AppSizes.spaceMd,
                      ),
                      sliver: SliverList.separated(
                        itemCount: machines.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: AppSizes.spaceMd),
                        itemBuilder: (context, index) =>
                            MachineListCard(machine: machines[index]),
                      ),
                    ),
            ],
          ),

          // ── Filters FAB (bottom-left floating) ────────────────────────────
          Positioned(
            bottom: AppSizes.spaceLg,
            left: AppSizes.spaceMd,
            child: FilterFab(
              onTap: () => _showFiltersSheet(context),
            ),
          ),
        ],
      ),
    );
  }

  void _showFiltersSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusLg),
        ),
      ),
      builder: (_) => const _FiltersPlaceholderSheet(),
    );
  }
}

// ─── Sticky Header ─────────────────────────────────────────────────────────────

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({required this.topPadding});
  final double topPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.pageBackground,
      padding: EdgeInsets.fromLTRB(
        AppSizes.spaceMd,
        topPadding + AppSizes.spaceSm,
        AppSizes.spaceMd,
        AppSizes.spaceMd,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Find Your', style: AppTextStyles.displayMedium),
                    Text(
                      'Equipment',
                      style: AppTextStyles.displayMedium.copyWith(
                        color: AppColors.gold,
                      ),
                    ),
                  ],
                ),
              ),
              // Logo mark
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.gold,
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                ),
                child: const Center(
                  child: Text(
                    'A',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                      height: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spaceMd),
          HomeSearchBar(
            onFilterTap: () => _showFiltersSheet(context),
          ),
        ],
      ),
    );
  }

  void _showFiltersSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusLg),
        ),
      ),
      builder: (_) => const _FiltersPlaceholderSheet(),
    );
  }
}

// ─── Sticky Header Delegate ────────────────────────────────────────────────────

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  _StickyHeaderDelegate({
    required this.topPadding,
    required this.child,
  });

  final double topPadding;
  final Widget child;

  // Header height: top safe area + greeting + search bar + padding
  double get _height => topPadding + 160;

  @override
  double get minExtent => _height;

  @override
  double get maxExtent => _height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  bool shouldRebuild(_StickyHeaderDelegate old) => old.topPadding != topPadding;
}

// ─── Empty State ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.construction_rounded,
            size: 64,
            color: AppColors.textSecondary.withOpacity(0.4),
          ),
          const SizedBox(height: AppSizes.spaceMd),
          Text(
            'No machinery found',
            style: AppTextStyles.headingMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSizes.spaceXs),
          Text(
            'Try a different search or category',
            style: AppTextStyles.bodySmall,
          ),
        ],
      ),
    );
  }
}

// ─── Filters Sheet Placeholder ─────────────────────────────────────────────────

class _FiltersPlaceholderSheet extends StatelessWidget {
  const _FiltersPlaceholderSheet();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.spaceLg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          const SizedBox(height: AppSizes.spaceLg),
          Text('Filters', style: AppTextStyles.displayMedium),
          const SizedBox(height: AppSizes.spaceSm),
          Text(
            'Advanced filters coming soon.',
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(height: AppSizes.spaceLg),
        ],
      ),
    );
  }
}
