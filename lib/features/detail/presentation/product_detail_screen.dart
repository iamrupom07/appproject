import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../home/domain/machine_model.dart';
import '../../home/presentation/providers/home_providers.dart';
import '../../contact/domain/contact_model.dart';
import 'providers/detail_providers.dart';
import 'widgets/detail_action_bar.dart';
import 'widgets/detail_image_gallery.dart';
import 'widgets/detail_tab_bar.dart';
import 'widgets/price_stock_row.dart';
import 'widgets/spec_chip.dart';
import 'widgets/tech_detail_row.dart';

class ProductDetailScreen extends ConsumerWidget {
  const ProductDetailScreen({super.key, required this.machineId});

  final String machineId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(machineDetailProvider(machineId));
    final isSaved = ref.watch(
      favoritesProvider.select((favs) => favs.contains(machineId)),
    );

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: detailAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.gold),
        ),
        error: (e, _) => Center(
          child:
          Text('Failed to load details', style: AppTextStyles.bodyMedium),
        ),
        data: (detail) {
          final activeTab = ref.watch(detailTabProvider);

          return Stack(
            children: [
              // ── Scrollable content ─────────────────────────────────────
              CustomScrollView(
                slivers: [
                  // Back button overlaying the gallery
                  SliverToBoxAdapter(
                    child: Stack(
                      children: [
                        DetailImageGallery(
                          galleryUrls: detail.galleryUrls,
                          totalImages: detail.totalImages,
                          has3DView: detail.has3DView,
                        ),
                        SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.all(AppSizes.spaceSm),
                            child: _BackButton(),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Info card ──────────────────────────────────────────
                  SliverToBoxAdapter(
                    child: Container(
                      color: AppColors.cardBackground,
                      padding: const EdgeInsets.fromLTRB(
                        AppSizes.spaceMd,
                        AppSizes.spaceMd,
                        AppSizes.spaceMd,
                        0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Machine name — comes from the home model via id
                          _MachineNameRow(machineId: machineId),
                          const SizedBox(height: AppSizes.spaceMd),

                          // Price + stock badge
                          _PriceRowById(machineId: machineId),
                          const SizedBox(height: AppSizes.spaceMd),

                          // Spec chips row
                          SizedBox(
                            height: 80,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: detail.specs.length,
                              separatorBuilder: (_, __) =>
                              const SizedBox(width: AppSizes.spaceSm),
                              itemBuilder: (context, i) {
                                final spec = detail.specs[i];
                                return SpecChip(
                                  iconAsset: spec.iconAsset,
                                  value: spec.value,
                                  label: spec.label,
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: AppSizes.spaceMd),
                        ],
                      ),
                    ),
                  ),

                  // ── Tab bar ────────────────────────────────────────────
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _StickyTabBarDelegate(
                      child: Container(
                        color: AppColors.cardBackground,
                        child: Column(
                          children: [
                            const DetailTabBar(),
                            const Divider(
                              height: 1,
                              color: AppColors.divider,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // ── Tab content ────────────────────────────────────────
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSizes.spaceMd),
                      child: switch (activeTab) {
                        DetailTab.overview => _OverviewTab(
                          description: detail.description,
                        ),
                        DetailTab.specifications => _SpecificationsTab(
                          techDetails: detail.techDetails,
                        ),
                        DetailTab.features => _FeaturesTab(
                          features: detail.features,
                        ),
                        DetailTab.shipping => _ShippingTab(
                          shippingInfo: detail.shippingInfo,
                        ),
                        DetailTab.condition => _ConditionTab(
                          conditionNotes: detail.conditionNotes,
                        ),
                      },
                    ),
                  ),

                  // Bottom padding for action bar
                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              ),

              // ── Sticky bottom action bar ───────────────────────────────
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: DetailActionBar(
                  isSaved: isSaved,
                  onSave: () =>
                      ref.read(favoritesProvider.notifier).toggle(machineId),
                  onMessage: () async {
                    final uri = Uri.parse(ContactData.messengerUrl);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(
                        uri,
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  },
                  onCall: () async {
                    final uri = Uri.parse(ContactData.phoneNumber);
                    if (await canLaunchUrl(uri)) await launchUrl(uri);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ─── Back Button ──────────────────────────────────────────────────────────────

class _BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pop(),
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.40),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.arrow_back_rounded,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}

// ─── Machine Name Row (reads from home provider by id) ───────────────────────

class _MachineNameRow extends ConsumerWidget {
  const _MachineNameRow({required this.machineId});
  final String machineId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final machines = ref.watch(filteredMachinesProvider);
    final machine = machines.firstWhere(
          (m) => m.id == machineId,
      orElse: () => MachineModel(
        id: machineId,
        name: 'Machine #$machineId',
        subtitle: '',
        category: MachineCategory.all,

        status: StockStatus.inStock,
        imageUrl: '',
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          machine.name,
          style: AppTextStyles.headingLarge,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        if (machine.subtitle.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            machine.subtitle,
            style: AppTextStyles.bodyMedium,
          ),
        ],
      ],
    );
  }
}

// ─── Price + Stock row reading from home provider ─────────────────────────────

class _PriceRowById extends ConsumerWidget {
  const _PriceRowById({required this.machineId});
  final String machineId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final machines = ref.watch(filteredMachinesProvider);
    final machine = machines.firstWhere(
          (m) => m.id == machineId,
      orElse: () => MachineModel(
        id: machineId,
        name: '',
        subtitle: '',
        category: MachineCategory.all,

        status: StockStatus.inStock,
        imageUrl: '',
      ),
    );

    return PriceStockRow(status: machine.status, machineName: machine.name);
  }
}

// ─── Tab content panels ───────────────────────────────────────────────────────

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({required this.description});
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Overview', style: AppTextStyles.headingMedium),
        const SizedBox(height: AppSizes.spaceSm),
        Text(description, style: AppTextStyles.bodyMedium),
      ],
    );
  }
}

class _SpecificationsTab extends StatelessWidget {
  const _SpecificationsTab({required this.techDetails});
  final List techDetails;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Technical Details', style: AppTextStyles.headingMedium),
        const SizedBox(height: AppSizes.spaceMd),
        ...techDetails.map(
              (td) => Column(
            children: [
              TechDetailRow(
                iconAsset: td.iconAsset,
                label: td.label,
                value: td.value,
              ),
              const Divider(color: AppColors.divider, height: AppSizes.spaceLg),
            ],
          ),
        ),
      ],
    );
  }
}

class _FeaturesTab extends StatelessWidget {
  const _FeaturesTab({required this.features});
  final String features;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Features', style: AppTextStyles.headingMedium),
        const SizedBox(height: AppSizes.spaceSm),
        Text(features, style: AppTextStyles.bodyMedium),
      ],
    );
  }
}

class _ShippingTab extends StatelessWidget {
  const _ShippingTab({required this.shippingInfo});
  final String shippingInfo;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Shipping & Delivery', style: AppTextStyles.headingMedium),
        const SizedBox(height: AppSizes.spaceSm),
        Text(shippingInfo, style: AppTextStyles.bodyMedium),
      ],
    );
  }
}

class _ConditionTab extends StatelessWidget {
  const _ConditionTab({required this.conditionNotes});
  final String conditionNotes;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Condition', style: AppTextStyles.headingMedium),
        const SizedBox(height: AppSizes.spaceSm),
        Text(conditionNotes, style: AppTextStyles.bodyMedium),
      ],
    );
  }
}

// ─── Sticky Tab Bar Delegate ──────────────────────────────────────────────────

class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  const _StickyTabBarDelegate({required this.child});
  final Widget child;

  @override
  double get minExtent => 41;

  @override
  double get maxExtent => 41;

  @override
  Widget build(
      BuildContext context,
      double shrinkOffset,
      bool overlapsContent,
      ) =>
      child;

  @override
  bool shouldRebuild(_StickyTabBarDelegate oldDelegate) =>
      oldDelegate.child != child;
}