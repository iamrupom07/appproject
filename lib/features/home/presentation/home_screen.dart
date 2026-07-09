import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:shimmer/shimmer.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../products/data/product_providers.dart';
import 'providers/home_providers.dart';
import 'widgets/category_tab_row.dart';
import 'widgets/home_header_bar.dart';
import 'widgets/machine_grid_card.dart';
import 'widgets/recently_added_card.dart';
import 'widgets/section_header.dart';
import 'widgets/split_section.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trending = ref.watch(trendingMachinesProvider);
    final recentlyAdded = ref.watch(recentlyAddedProvider);
    final isLoading = ref.watch(machinesLoadingProvider);
    final error = ref.watch(machinesErrorProvider);
    final dateLabel = DateFormat('EEEE, MMMM d, y').format(DateTime.now());

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: RefreshIndicator(
        color: AppColors.gold,
        onRefresh: () => _refreshHomeData(ref),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(
                height: MediaQuery.of(context).padding.top + AppSizes.spaceMd,
              ),
            ),
            SliverToBoxAdapter(
              child: HomeHeaderBar(
                userName: 'User',
                dateLabel: dateLabel,
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: AppSizes.spaceMd)),

            // ── Tappable search bar ────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSizes.spaceMd),
                child: GestureDetector(
                  onTap: () => context.push('/search'),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(AppSizes.radiusPill),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: AppSizes.spaceMd),
                        const Icon(
                          Icons.search_rounded,
                          color: AppColors.textSecondary,
                          size: 20,
                        ),
                        const SizedBox(width: AppSizes.spaceSm),
                        Expanded(
                          child: Text(
                            'Search machinery, model, brand...',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: AppSizes.spaceMd),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: AppSizes.spaceLg)),
            const SliverToBoxAdapter(child: HomeSplitSection()),
            const SliverToBoxAdapter(child: SizedBox(height: AppSizes.spaceLg)),
            const SliverToBoxAdapter(child: CategoryTabRow()),
            const SliverToBoxAdapter(child: SizedBox(height: AppSizes.spaceLg)),

            // ── Error banner ───────────────────────────────────────────────
            if (error != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSizes.spaceMd),
                  child: Container(
                    padding: const EdgeInsets.all(AppSizes.spaceMd),
                    decoration: BoxDecoration(
                      color: AppColors.outOfStock.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                      border: Border.all(
                          color: AppColors.outOfStock.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.wifi_off_rounded,
                            color: AppColors.outOfStock, size: 18),
                        const SizedBox(width: AppSizes.spaceSm),
                        Expanded(
                          child: Text(
                            'Could not load inventory. Check your connection.',
                            style: AppTextStyles.bodySmall
                                .copyWith(color: AppColors.outOfStock),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // ── Trending ───────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: SectionHeader(
                title: 'Trending Inventory',
                onSeeAll: () => context.go('/inventory'),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: AppSizes.spaceMd)),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 248,
                child: isLoading
                    ? const _HorizontalShimmer(itemWidth: 160, height: 248)
                    : trending.isEmpty
                        ? const _EmptySection(
                            message: 'No products available yet')
                        : ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSizes.spaceMd),
                            itemCount: trending.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: AppSizes.spaceSm),
                            itemBuilder: (_, index) => SizedBox(
                              width: 160,
                              child: MachineGridCard(machine: trending[index]),
                            ),
                          ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: AppSizes.spaceLg)),

            // ── Recently Added ─────────────────────────────────────────────
            SliverToBoxAdapter(
              child: SectionHeader(
                title: 'Recently Added',
                onSeeAll: () => context.go('/inventory'),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: AppSizes.spaceMd)),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 160,
                child: isLoading
                    ? const _HorizontalShimmer(itemWidth: 180, height: 160)
                    : recentlyAdded.isEmpty
                        ? const _EmptySection(message: 'No recent additions')
                        : ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSizes.spaceMd),
                            itemCount: recentlyAdded.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: AppSizes.spaceSm),
                            itemBuilder: (_, index) => SizedBox(
                              width: 180,
                              child: RecentlyAddedCard(
                                  machine: recentlyAdded[index]),
                            ),
                          ),
              ),
            ),

            SliverToBoxAdapter(
              child: SizedBox(
                height: AppSizes.spaceLg +
                    AppSizes.navBarHeight +
                    MediaQuery.of(context).padding.bottom,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Shimmer skeleton for horizontal lists ────────────────────────────────────

Future<void> _refreshHomeData(WidgetRef ref) async {
  try {
    await Future.wait([
      ref.refresh(allProductsProvider.future),
      ref.refresh(categoriesProvider.future),
    ]);
  } catch (_) {
    // Existing provider error UI handles failed refreshes.
  }
}

class _HorizontalShimmer extends StatelessWidget {
  const _HorizontalShimmer({required this.itemWidth, required this.height});
  final double itemWidth;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceMd),
        itemCount: 4,
        separatorBuilder: (_, __) => const SizedBox(width: AppSizes.spaceSm),
        itemBuilder: (_, __) => Container(
          width: itemWidth,
          height: height,
          decoration: BoxDecoration(
            color: AppColors.shimmerBase,
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          ),
        ),
      ),
    );
  }
}

// ─── Empty section fallback ───────────────────────────────────────────────────

class _EmptySection extends StatelessWidget {
  const _EmptySection({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: AppTextStyles.bodySmall
            .copyWith(color: AppColors.textSecondary.withValues(alpha: 0.6)),
      ),
    );
  }
}
