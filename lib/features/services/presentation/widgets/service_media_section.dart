import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

/// Displays either a carousel of images OR a single video placeholder.
/// Pass [imageUrls] for a carousel; pass [videoUrl] for video mode.
class ServiceMediaSection extends StatefulWidget {
  const ServiceMediaSection({
    super.key,
    this.imageUrls,
    this.videoUrl,
  }) : assert(imageUrls != null || videoUrl != null,
            'Provide either imageUrls or videoUrl');

  final List<String>? imageUrls;
  final String? videoUrl;

  @override
  State<ServiceMediaSection> createState() => _ServiceMediaSectionState();
}

class _ServiceMediaSectionState extends State<ServiceMediaSection> {
  final _controller = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.videoUrl != null) {
      return _VideoPlaceholder(url: widget.videoUrl!);
    }

    final images = widget.imageUrls!;
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          child: SizedBox(
            height: 220,
            child: PageView.builder(
              controller: _controller,
              itemCount: images.length,
              onPageChanged: (i) => setState(() => _currentPage = i),
              itemBuilder: (context, index) {
                return CachedNetworkImage(
                  imageUrl: images[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  placeholder: (_, __) => Container(
                    color: AppColors.shimmerBase,
                  ),
                  errorWidget: (_, __, ___) => Container(
                    color: AppColors.pageBackground,
                    child: const Icon(Icons.image_not_supported_outlined,
                        color: AppColors.textSecondary),
                  ),
                );
              },
            ),
          ),
        ),
        if (images.length > 1) ...[
          const SizedBox(height: AppSizes.spaceSm),
          AnimatedSmoothIndicator(
            activeIndex: _currentPage,
            count: images.length,
            effect: WormEffect(
              dotHeight: 7,
              dotWidth: 7,
              activeDotColor: AppColors.gold,
              dotColor: AppColors.divider,
            ),
          ),
        ],
      ],
    );
  }
}

class _VideoPlaceholder extends StatelessWidget {
  const _VideoPlaceholder({required this.url});
  final String url;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      child: Container(
        height: 220,
        color: AppColors.darkBackground,
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Icon(Icons.play_circle_fill_rounded,
                size: 64, color: AppColors.gold),
            Positioned(
              bottom: AppSizes.spaceSm,
              left: AppSizes.spaceSm,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text('Video',
                    style: TextStyle(color: Colors.white, fontSize: 11)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
