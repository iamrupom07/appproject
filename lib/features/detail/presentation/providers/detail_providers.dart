import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../products/data/product_dto.dart';
import '../../../products/data/product_providers.dart';
import '../../domain/machine_detail_model.dart';

// ─── Active Detail Tab ────────────────────────────────────────────────────────

enum DetailTab { overview, specifications, features, shipping }

final detailTabProvider = StateProvider.autoDispose<DetailTab>(
  (ref) => DetailTab.overview,
);

// ─── Active Gallery Index ─────────────────────────────────────────────────────

final galleryIndexProvider = StateProvider.autoDispose<int>((ref) => 0);

// ─── Machine Detail Data (real API) ──────────────────────────────────────────

/// Fetches a single product and converts it to [MachineDetailModel].
final machineDetailProvider =
    FutureProvider.autoDispose.family<MachineDetailModel, String>(
  (ref, id) async {
    final dto = await ref.watch(productDetailProvider(id).future);
    return _dtoToDetailModel(dto);
  },
);

// ─── Conversion ───────────────────────────────────────────────────────────────

MachineDetailModel _dtoToDetailModel(ProductDto dto) {
  final specs = [
    if (dto.partNumber != null)
      MachineSpec(
          label: 'Part Number', value: dto.partNumber!, iconAsset: 'weight'),
    MachineSpec(
        label: 'Condition', value: dto.conditionLabel, iconAsset: 'shield'),
    if (dto.compatibility != null)
      MachineSpec(
          label: 'Compatible',
          value: dto.compatibility!,
          iconAsset: 'bucket'),
    if (dto.categoryName != null)
      MachineSpec(
          label: 'Category', value: dto.categoryName!, iconAsset: 'power'),
  ];

  final techDetails = [
    if (dto.partNumber != null)
      TechDetail(
          label: 'Part Number', value: dto.partNumber!, iconAsset: 'engine'),
    if (dto.compatibility != null)
      TechDetail(
          label: 'Compatibility',
          value: dto.compatibility!,
          iconAsset: 'weight'),
    TechDetail(
        label: 'Condition', value: dto.conditionLabel, iconAsset: 'shield'),
    if (dto.categoryName != null)
      TechDetail(
          label: 'Category', value: dto.categoryName!, iconAsset: 'bucket'),
    if (dto.origin != null)
      TechDetail(label: 'Origin', value: dto.origin!, iconAsset: 'calendar'),
    if (dto.brandName != null)
      TechDetail(
          label: 'Brand', value: dto.brandName!, iconAsset: 'clock'),
    TechDetail(
        label: 'Quantity',
        value: dto.quantity.toString(),
        iconAsset: 'power'),
  ];

  // Build gallery — use real images, pad with placeholder if empty
  final galleryUrls = dto.images.isNotEmpty
      ? dto.images
      : [
          'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800&q=80'
        ];

  // Features string — join list with bullet prefix
  final featuresText = dto.features.isNotEmpty
      ? dto.features.map((f) => '• $f').join('\n')
      : '• Contact us for details';

  return MachineDetailModel(
    id: dto.id,
    totalImages: galleryUrls.length,
    galleryUrls: galleryUrls,
    specs: specs,
    techDetails: techDetails,
    description: dto.description,
    features: featuresText,
    shippingInfo: dto.shippingInfo ??
        'Contact us to arrange shipping or pickup.',
    has3DView: false,
  );
}
