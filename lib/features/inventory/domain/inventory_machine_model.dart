import '../../home/domain/machine_model.dart';

/// Extends [MachineModel] with inventory-specific display fields.
/// The base [MachineModel] stays clean; specs live here.
class InventoryMachineModel {
  const InventoryMachineModel({
    required this.machine,
    required this.operatingWeightKg,
    required this.capacityM3,
    required this.capacityLabel,
    this.totalImages = 1,
  });

  final MachineModel machine;

  /// e.g. 22200
  final int operatingWeightKg;

  /// e.g. 1.0
  final double capacityM3;

  /// e.g. 'Bucket Capacity' or 'Blade Capacity'
  final String capacityLabel;

  /// Total photos in this machine's gallery (shown as "1/N" on image)
  final int totalImages;

  // ── Convenience pass-throughs ──────────────────────────────────────────────
  String get id => machine.id;
  String get name => machine.name;
  String get subtitle => machine.subtitle;
  MachineCategory get category => machine.category;
  double get price => machine.price;
  StockStatus get status => machine.status;
  String get imageUrl => machine.imageUrl;

  String get formattedWeight {
    final s = operatingWeightKg
        .toString()
        .replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
    return '$s kg';
  }

  String get formattedCapacity => '${capacityM3.toStringAsFixed(1)} m\u00B3';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InventoryMachineModel && other.id == id);

  @override
  int get hashCode => id.hashCode;
}
