import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
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

  // Total catalogue size shown in the header subtitle
  static const int _totalMachines = 128;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final machines = ref.watch(filteredInventoryProvider);
    final viewMode = ref.watch(inventoryViewModeProvider);

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
                      machineCount: _totalMachines,
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

                // ── Machine grid or list ───────────────────────────────────
                if (machines.isEmpty)
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
