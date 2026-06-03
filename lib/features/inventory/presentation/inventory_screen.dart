import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shimmer/shimmer.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/utils/messenger_launcher.dart';
import 'providers/inventory_providers.dart';
import 'widgets/inventory_bottom_bar.dart';
import 'widgets/filter_bottom_sheet.dart';
import 'widgets/inventory_category_bar.dart';
import 'widgets/inventory_filter_bar.dart';
import 'widgets/inventory_header_bar.dart';
import 'widgets/inventory_list_card.dart';
import 'widgets/inventory_machine_card.dart';
import 'widgets/inventory_result_header.dart';
import 'widgets/inventory_search_bar.dart';

/// Full Inventory screen.
/// Composes all sub-widgets; all state lives in providers.
class InventoryScreen extends ConsumerWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final machines = ref.watch(filteredInventoryProvider);
    final viewMode = ref.watch(inventoryViewModeProvider);
    final isLoading = ref.watch(inventoryLoadingProvider);
    final apiError = ref.watch(inventoryErrorProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppColors.pageBackground,
        body: Stack(
          children: [
            // ── Scrollable content ─────────────────────────────────────────
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // ── Status bar safe area ──────────────────────────────────
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: MediaQuery.of(context).padding.top,
                  ),
                ),

                // ── Header ────────────────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSizes.spaceMd,
                      AppSizes.spaceMd,
                      AppSizes.spaceMd,
                      0,
                    ),
                    child: InventoryHeaderBar(
                      machineCount: machines.length,
                    ),
                  ),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: AppSizes.spaceMd),
                ),

                // ── Search bar ────────────────────────────────────────────
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.spaceMd,
                    ),
                    child: InventorySearchBar(),
                  ),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: AppSizes.spaceMd),
                ),

                // ── Category bar ──────────────────────────────────────────
                const SliverToBoxAdapter(child: InventoryCategoryBar()),

                const SliverToBoxAdapter(
                  child: SizedBox(height: AppSizes.spaceMd),
                ),

                // ── Filter bar ────────────────────────────────────────────
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.spaceMd,
                    ),
                    child: InventoryFilterBar(),
                  ),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: AppSizes.spaceMd),
                ),

                // ── Result header ─────────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.spaceMd,
                    ),
                    child: InventoryResultHeader(count: machines.length),
                  ),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: AppSizes.spaceMd),
                ),

                // ── Error banner ──────────────────────────────────────────
                if (apiError != null)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.spaceMd),
                      child: Container(
                        padding: const EdgeInsets.all(AppSizes.spaceMd),
                        margin:
                            const EdgeInsets.only(bottom: AppSizes.spaceMd),
                        decoration: BoxDecoration(
                          color: AppColors.outOfStock.withValues(alpha: 0.1),
                          borderRadius:
                              BorderRadius.circular(AppSizes.radiusSm),
                          border: Border.all(
                              color: AppColors.outOfStock
                                  .withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.wifi_off_rounded,
                                color: AppColors.outOfStock, size: 18),
                            const SizedBox(width: AppSizes.spaceSm),
                            const Expanded(
                              child: Text(
                                'Could not load inventory. Check your connection.',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                // ── Machine grid or list ───────────────────────────────────
                if (isLoading)
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                        AppSizes.spaceMd, 0, AppSizes.spaceMd, 96),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: AppSizes.spaceMd,
                        mainAxisSpacing: AppSizes.spaceMd,
                        childAspectRatio: 0.62,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, _) => Shimmer.fromColors(
                          baseColor: AppColors.shimmerBase,
                          highlightColor: AppColors.shimmerHighlight,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.shimmerBase,
                              borderRadius:
                                  BorderRadius.circular(AppSizes.radiusMd),
                            ),
                          ),
                        ),
                        childCount: 6,
                      ),
                    ),
                  )
                else if (machines.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: _EmptyState(),
                  )
                else if (viewMode == InventoryViewMode.grid)
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSizes.spaceMd,
                      0,
                      AppSizes.spaceMd,
                      96,
                    ),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: AppSizes.spaceMd,
                        mainAxisSpacing: AppSizes.spaceMd,
                        childAspectRatio: 0.62,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => InventoryMachineCard(
                          machine: machines[index],
                        ),
                        childCount: machines.length,
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSizes.spaceMd,
                      0,
                      AppSizes.spaceMd,
                      96,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => Padding(
                          padding: const EdgeInsets.only(
                            bottom: AppSizes.spaceMd,
                          ),
                          child: InventoryListCard(
                            machine: machines[index],
                          ),
                        ),
                        childCount: machines.length,
                      ),
                    ),
                  ),
              ],
            ),

            // ── Sticky bottom bar ──────────────────────────────────────────
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Builder(
                builder: (ctx) => InventoryBottomBar(
                  onRefineTap: () => showFilterBottomSheet(ctx),
                  onCallTap: callAbroz,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Empty State ──────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 64,
            color: AppColors.textSecondary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No machines found',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
