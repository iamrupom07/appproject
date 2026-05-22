import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

/// Self-contained mock search UI used on onboarding slide 3 ("Search Smarter").
///
/// Renders:
///   • Search bar with filter icon
///   • Horizontally scrolling category chips (Excavators selected)
///   • Two machine listing cards with thumbnail, badge, name, price
///
/// Everything is static / decorative — this is a visual preview only.
class SearchPreviewWidget extends StatelessWidget {
  const SearchPreviewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.spaceLg),
      decoration: BoxDecoration(
        color: AppColors.pageBackground,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Top bar: search + filter ──────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.spaceMd,
              AppSizes.spaceMd,
              AppSizes.spaceMd,
              AppSizes.spaceSm,
            ),
            child: _SearchBar(),
          ),

          // ── Category chips ────────────────────────────────────────
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceMd),
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                _CategoryChip(label: 'Engine Parts', selected: true),
                SizedBox(width: 8),
                _CategoryChip(label: 'Hydraulics'),
                SizedBox(width: 8),
                _CategoryChip(label: 'Undercarriage'),
                SizedBox(width: 8),
                _CategoryChip(label: 'Electrical'),
              ],
            ),
          ),

          const SizedBox(height: AppSizes.spaceSm),

          // ── Machine cards ─────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.spaceMd,
              0,
              AppSizes.spaceMd,
              AppSizes.spaceMd,
            ),
            child: Column(
              children: const [
                _MachineListCard(
                  imageUrl:
                      'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=200&q=80',
                  name: 'Komatsu PC200 Engine Assembly',
                  subtitle: 'SA6D102 – PC200-8 / PC210LC',
                  price: 'Price upon request',
                ),
                SizedBox(height: AppSizes.spaceSm),
                _MachineListCard(
                  imageUrl:
                      'https://images.unsplash.com/photo-1504307651254-35680f356dfd?w=200&q=80',
                  name: 'Hydraulic Main Pump',
                  subtitle: 'HPV132 – PC200-8 / PC220-8',
                  price: 'Price upon request',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.divider, width: 1),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          const Icon(Icons.search_rounded,
              size: 18, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Search machinery...',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: AppColors.pageBackground,
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            ),
            child: const Icon(Icons.tune_rounded,
                size: 16, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.label, this.selected = false});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: selected ? AppColors.gold : Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusPill),
        border: Border.all(
          color: selected ? AppColors.gold : AppColors.divider,
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.outfit(
          fontSize: 12,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          color: selected ? Colors.white : AppColors.textPrimary,
        ),
      ),
    );
  }
}

class _MachineListCard extends StatelessWidget {
  const _MachineListCard({
    required this.imageUrl,
    required this.name,
    required this.subtitle,
    required this.price,
  });

  final String imageUrl;
  final String name;
  final String subtitle;
  final String price;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
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
          // Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            child: SizedBox(
              width: 70,
              height: 70,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: AppColors.pageBackground,
                  child: const Icon(Icons.construction_rounded,
                      color: AppColors.gold, size: 30),
                ),
              ),
            ),
          ),

          const SizedBox(width: 10),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // In-Stock badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.inStock.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppSizes.radiusPill),
                  ),
                  child: Text(
                    'In Stock',
                    style: GoogleFonts.inter(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.inStock,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  name,
                  style: GoogleFonts.outfit(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 10.5,
                    color: AppColors.textSecondary,
                    height: 1.35,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  price,
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.gold,
                  ),
                ),
              ],
            ),
          ),

          // Right actions
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Icon(Icons.chevron_right_rounded,
                  size: 20, color: AppColors.textSecondary),
              SizedBox(height: 22),
              Icon(Icons.favorite_border_rounded,
                  size: 18, color: AppColors.textSecondary),
            ],
          ),
        ],
      ),
    );
  }
}
