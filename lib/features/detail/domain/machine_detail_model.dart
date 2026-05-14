/// Extended detail model for a machine's product page.
/// Pure domain — no Flutter imports.
/// The base [MachineModel] is passed separately via navigation extras.
class MachineSpec {
  const MachineSpec({
    required this.label,
    required this.value,
    required this.iconAsset, // mapped to IconData in the widget layer
  });

  final String label;
  final String value;
  final String iconAsset;
}

class TechDetail {
  const TechDetail({
    required this.label,
    required this.value,
    required this.iconAsset,
  });

  final String label;
  final String value;
  final String iconAsset;
}

class MachineDetailModel {
  const MachineDetailModel({
    required this.id,
    required this.totalImages,
    required this.galleryUrls,
    required this.specs,
    required this.techDetails,
    required this.description,
    required this.features,
    required this.shippingInfo,
    required this.conditionNotes,
    this.has3DView = false,
  });

  final String id;

  /// Total image count shown in the "1 / N" counter.
  final int totalImages;

  /// Ordered gallery URLs — first item is the hero.
  final List<String> galleryUrls;

  /// Four stat chips shown under the price row (weight, HP, bucket, dig depth).
  final List<MachineSpec> specs;

  /// Key-value pairs in the Technical Details grid.
  final List<TechDetail> techDetails;

  final String description;
  final String features;
  final String shippingInfo;
  final String conditionNotes;
  final bool has3DView;
}
