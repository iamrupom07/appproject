import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../providers/detail_providers.dart';

/// Full-bleed hero image with:
///  - "1 / N" counter badge (bottom-left)
///  - "View in 3D" button (bottom-right, optional)
///  - Horizontal thumbnail strip below the hero
class DetailImageGallery extends ConsumerWidget {
  const DetailImageGallery({
    super.key,
    required this.galleryUrls,
    required this.totalImages,
    required this.has3DView,
  });

  final List<String> galleryUrls;
  final int totalImages;
  final bool has3DView;

  static const double _heroHeight = 340.0;
  static const double _thumbSize = 72.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeIndex = ref.watch(galleryIndexProvider);
    final heroUrl = galleryUrls.isNotEmpty
        ? galleryUrls[activeIndex.clamp(0, galleryUrls.length - 1)]
        : '';

    return Column(
      children: [
        // ── Hero Image ──────────────────────────────────────────────────────
        Stack(
          children: [
            _HeroImage(url: heroUrl, height: _heroHeight),

            // Counter badge — bottom left
            Positioned(
              bottom: AppSizes.spaceMd,
              left: AppSizes.spaceMd,
              child: _CounterBadge(
                current: activeIndex + 1,
                total: totalImages,
              ),
            ),

            // 3D button — bottom right
            if (has3DView)
              Positioned(
                bottom: AppSizes.spaceMd,
                right: AppSizes.spaceMd,
                child: _View3DButton(onTap: () {}),
              ),
          ],
        ),

        // ── Thumbnail Strip ─────────────────────────────────────────────────
        Container(
          color: AppColors.cardBackground,
          padding: const EdgeInsets.fromLTRB(
            AppSizes.spaceMd,
            AppSizes.spaceMd,
            AppSizes.spaceMd,
            0,
          ),
          child: SizedBox(
            height: _thumbSize,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _thumbCount,
              separatorBuilder: (_, __) =>
                  const SizedBox(width: AppSizes.spaceSm),
              itemBuilder: (context, index) {
                if (index < galleryUrls.length) {
                  final isActive = index == activeIndex;
                  return _Thumbnail(
                    url: galleryUrls[index],
                    isActive: isActive,
                    size: _thumbSize,
                    onTap: () =>
                        ref.read(galleryIndexProvider.notifier).state = index,
                  );
                }
                // "+N more" tile
                final remaining = totalImages - galleryUrls.length;
                return _MoreTile(count: remaining, size: _thumbSize);
              },
            ),
          ),
        ),
      ],
    );
  }

  /// Show all gallery URLs + one "+N" tile if there are more.
  int get _thumbCount =>
      galleryUrls.length + (totalImages > galleryUrls.length ? 1 : 0);
}

// ─── Hero Image ───────────────────────────────────────────────────────────────

class _HeroImage extends StatelessWidget {
  const _HeroImage({required this.url, required this.height});

  final String url;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.cover,
        placeholder: (_, __) => Shimmer.fromColors(
          baseColor: AppColors.shimmerBase,
          highlightColor: AppColors.shimmerHighlight,
          child: Container(color: AppColors.shimmerBase),
        ),
        errorWidget: (_, __, ___) => Container(
          color: AppColors.pageBackground,
          child: const Icon(
            Icons.image_not_supported_outlined,
            size: 48,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

// ─── Counter Badge ────────────────────────────────────────────────────────────

class _CounterBadge extends StatelessWidget {
  const _CounterBadge({required this.current, required this.total});

  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.45),
        borderRadius: BorderRadius.circular(AppSizes.radiusPill),
      ),
      child: Text(
        '$current / $total',
        style: AppTextStyles.labelMedium.copyWith(color: Colors.white),
      ),
    );
  }
}

// ─── View in 3D Button ────────────────────────────────────────────────────────

class _View3DButton extends StatelessWidget {
  const _View3DButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.45),
          borderRadius: BorderRadius.circular(AppSizes.radiusPill),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.view_in_ar_rounded, size: 16, color: Colors.white),
            const SizedBox(width: 4),
            Text(
              'View in 3D',
              style: AppTextStyles.labelMedium.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Thumbnail ────────────────────────────────────────────────────────────────

class _Thumbnail extends StatelessWidget {
  const _Thumbnail({
    required this.url,
    required this.isActive,
    required this.size,
    required this.onTap,
  });

  final String url;
  final bool isActive;
  final double size;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          border: Border.all(
            color: isActive ? AppColors.gold : Colors.transparent,
            width: 2.5,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.radiusSm - 1),
          child: CachedNetworkImage(
            imageUrl: url,
            fit: BoxFit.cover,
            placeholder: (_, __) => Shimmer.fromColors(
              baseColor: AppColors.shimmerBase,
              highlightColor: AppColors.shimmerHighlight,
              child: Container(color: AppColors.shimmerBase),
            ),
            errorWidget: (_, __, ___) => Container(
              color: AppColors.pageBackground,
              child: const Icon(Icons.image_not_supported_outlined,
                  size: 20, color: AppColors.textSecondary),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── +N More Tile ─────────────────────────────────────────────────────────────

class _MoreTile extends StatelessWidget {
  const _MoreTile({required this.count, required this.size});

  final int count;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.pageBackground,
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      ),
      child: Center(
        child: Text(
          '+$count',
          style: AppTextStyles.headingMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
