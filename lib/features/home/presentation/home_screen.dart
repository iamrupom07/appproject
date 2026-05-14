import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import 'providers/home_providers.dart';
import 'widgets/category_tab_row.dart';
import 'widgets/featured_banner_carousel.dart';
import 'widgets/home_header_bar.dart';
import 'widgets/machine_grid_card.dart';
import 'widgets/recently_added_card.dart';
import 'widgets/section_header.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final featured = ref.watch(featuredMachinesProvider);
    final trending = ref.watch(trendingMachinesProvider);
    final recentlyAdded = ref.watch(recentlyAddedProvider);
    final dateLabel = DateFormat('EEEE, MMMM d, y').format(DateTime.now());

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
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
              avatarUrl: 'https://i.pravatar.cc/150?img=11',
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: AppSizes.spaceLg)),
          SliverToBoxAdapter(
            child: FeaturedBannerCarousel(machines: featured),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: AppSizes.spaceLg)),
          const SliverToBoxAdapter(child: CategoryTabRow()),
          const SliverToBoxAdapter(child: SizedBox(height: AppSizes.spaceLg)),
          SliverToBoxAdapter(
            child: SectionHeader(
              title: 'Trending Inventory',
              onSeeAll: () {},
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: AppSizes.spaceMd)),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 248,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceMd),
                itemCount: trending.length,
                separatorBuilder: (_, __) => const SizedBox(width: AppSizes.spaceSm),
                itemBuilder: (_, index) => SizedBox(
                  width: 160,
                  child: MachineGridCard(machine: trending[index]),
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: AppSizes.spaceLg)),
          SliverToBoxAdapter(
            child: SectionHeader(
              title: 'Recently Added',
              onSeeAll: () {},
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: AppSizes.spaceMd)),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 160,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceMd),
                itemCount: recentlyAdded.length,
                separatorBuilder: (_, __) => const SizedBox(width: AppSizes.spaceSm),
                itemBuilder: (_, index) => SizedBox(
                  width: 180,
                  child: RecentlyAddedCard(machine: recentlyAdded[index]),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: AppSizes.spaceLg + AppSizes.navBarHeight),
          ),
        ],
      ),
    );
  }
}