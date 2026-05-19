import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../home/domain/machine_model.dart';
import '../../../contact/domain/contact_model.dart';

/// "Upon Request" price label (tappable → Get Quotation dialog) + stock pill.
class PriceStockRow extends StatelessWidget {
  const PriceStockRow({
    super.key,
    required this.status,
    this.machineName = '',
  });

  final StockStatus status;
  final String machineName;

  Future<void> _openQuotationDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (ctx) => _QuotationDialog(machineName: machineName),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // ── Tappable price area ──────────────────────────────────────────────
        GestureDetector(
          onTap: () => _openQuotationDialog(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Price',
                style: AppTextStyles.bodySmall,
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Text(
                    'Upon Request',
                    style: AppTextStyles.priceLarge.copyWith(fontSize: 18),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.gold,
                      borderRadius: BorderRadius.circular(AppSizes.radiusPill),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.chat_bubble_rounded,
                          color: Colors.white,
                          size: 11,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Get Quotation',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Spacer(),
        _StockPill(status: status),
      ],
    );
  }
}

// ─── Quotation Dialog ─────────────────────────────────────────────────────────

class _QuotationDialog extends StatelessWidget {
  const _QuotationDialog({required this.machineName});
  final String machineName;

  Future<void> _openMessenger(BuildContext context) async {
    final message = machineName.isNotEmpty
        ? 'Hi! I would like to get a quotation for: $machineName'
        : 'Hi! I would like to get a quotation for one of your machines.';
    final encoded = Uri.encodeComponent(message);
    final uri = Uri.parse('${ContactData.messengerUrl}?text=$encoded');
    Navigator.of(context).pop();
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      // Fallback: open messenger URL without prefilled text
      final fallback = Uri.parse(ContactData.messengerUrl);
      if (await canLaunchUrl(fallback)) {
        await launchUrl(fallback, mode: LaunchMode.externalApplication);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      ),
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      actionsPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFF0084FF).withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.chat_bubble_rounded,
              color: Color(0xFF0084FF),
              size: 28,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Get a Quotation',
            style: AppTextStyles.headingMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            machineName.isNotEmpty
                ? 'Request pricing for "$machineName" via Messenger. Our team will reply promptly.'
                : 'Request pricing via Messenger. Our team will reply promptly.',
            style: AppTextStyles.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
        ],
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.divider),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                ),
                child: Text(
                  'Cancel',
                  style: AppTextStyles.buttonLabel.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: () => _openMessenger(context),
                icon: const Icon(Icons.chat_bubble_rounded,
                    size: 16, color: Colors.white),
                label: Text(
                  'Ask for Quote',
                  style: AppTextStyles.buttonLabel.copyWith(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0084FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─── Extended Stock Pill (dot + label) ────────────────────────────────────────

class _StockPill extends StatelessWidget {
  const _StockPill({required this.status});

  final StockStatus status;

  Color get _color {
    switch (status) {
      case StockStatus.inStock:
        return AppColors.inStock;
      case StockStatus.lowStock:
        return AppColors.lowStock;
      case StockStatus.outOfStock:
        return AppColors.outOfStock;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _color;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spaceMd,
        vertical: AppSizes.spaceSm,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppSizes.radiusPill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                status.label,
                style: AppTextStyles.labelMedium.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
              if (status == StockStatus.inStock)
                Text(
                  'Available Now',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: color.withValues(alpha: 0.75),
                    fontSize: 10,
                  ),
                ),
              if (status == StockStatus.lowStock)
                Text(
                  'Hurry — Few Left',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: color.withValues(alpha: 0.75),
                    fontSize: 10,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}