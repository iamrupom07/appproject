import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../screens/experts_screen.dart';
import '../screens/spare_parts_screen.dart';

/// Two-column split section replacing the Featured Carousel on the homepage.
/// Left → Experts   |   Right → Spare Parts & Mechanical Services
class SplitCategorySection extends StatelessWidget {
  const SplitCategorySection({super.key});

  void _goToExperts(BuildContext context) {
    HapticFeedback.lightImpact();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const ExpertsScreen(),
      ),
    );
  }

  void _goToSpareParts(BuildContext context) {
    HapticFeedback.lightImpact();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const SparePartsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceMd),
      child: SizedBox(
        height: 220,
        child: Row(
          children: [
            // ── Left: EXPERTS ──────────────────────────────────────────────
            Expanded(
              child: _SplitCard(
                label: 'EXPERTS',
                sublabel: 'Meet our\nspecialists',
                icon: Icons.groups_rounded,
                imageUrl:
                    'https://images.unsplash.com/photo-1601574968106-b312ac309953?w=400&q=75',
                accentColor: AppColors.gold,
                onTap: () => _goToExperts(context),
              ),
            ),

            // ── Vertical Divider ───────────────────────────────────────────
            const _VerticalSplitter(),

            // ── Right: SPARE PARTS & MECHANICAL SERVICES ───────────────────
            Expanded(
              child: _SplitCard(
                label: 'SPARE PARTS\n& SERVICES',
                sublabel: 'Genuine &\nrefurbished',
                icon: Icons.construction_rounded,
                imageUrl:
                    'https://images.unsplash.com/photo-1518459031867-a89b944bffe4?w=400&q=75',
                accentColor: const Color(0xFF5B8CFF),
                onTap: () => _goToSpareParts(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Split Card ───────────────────────────────────────────────────────────────

class _SplitCard extends StatefulWidget {
  const _SplitCard({
    required this.label,
    required this.sublabel,
    required this.icon,
    required this.imageUrl,
    required this.accentColor,
    required this.onTap,
  });

  final String label;
  final String sublabel;
  final IconData icon;
  final String imageUrl;
  final Color accentColor;
  final VoidCallback onTap;

  @override
  State<_SplitCard> createState() => _SplitCardState();
}

class _SplitCardState extends State<_SplitCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    _scale = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: GestureDetector(
        onTapDown: (_) => _ctrl.forward(),
        onTapUp: (_) async {
          await _ctrl.reverse();
          widget.onTap();
        },
        onTapCancel: () => _ctrl.reverse(),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background image
              Image.network(
                widget.imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (_, child, progress) {
                  if (progress == null) return child;
                  return Container(color: AppColors.darkBackground);
                },
                errorBuilder: (_, __, ___) =>
                    Container(color: AppColors.darkBackground),
              ),

              // Dark overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.25),
                      Colors.black.withValues(alpha: 0.72),
                    ],
                  ),
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon bubble
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: widget.accentColor.withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                      ),
                      child: Icon(widget.icon, color: Colors.white, size: 20),
                    ),

                    const Spacer(),

                    // Main label
                    Text(
                      widget.label,
                      style: AppTextStyles.headingSmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                        fontSize: 11,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.sublabel,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white70,
                        fontSize: 10,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Arrow chip
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: widget.accentColor,
                        borderRadius:
                            BorderRadius.circular(AppSizes.radiusPill),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Explore',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 10,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.arrow_forward_rounded,
                              color: Colors.white, size: 11),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Vertical Splitter ────────────────────────────────────────────────────────

class _VerticalSplitter extends StatelessWidget {
  const _VerticalSplitter();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 1.5,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  AppColors.divider,
                  Colors.transparent,
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: AppColors.gold,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: 1.5,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  AppColors.divider,
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
