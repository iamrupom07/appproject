import '../../home/domain/machine_model.dart';

/// Extends [MachineModel] with spare-parts-specific display fields.
class InventoryMachineModel {
  const InventoryMachineModel({
    required this.machine,
    required this.partNumber,
    required this.compatibility,
    required this.condition,
    this.totalImages = 1,
  });

  final MachineModel machine;

  /// e.g. 'KOM-SA6D102-001'
  final String partNumber;

  /// e.g. 'PC200-8, PC210LC-8'
  final String compatibility;

  /// e.g. 'Used – Good' / 'New – OEM' / 'Refurbished'
  final String condition;

  /// Total photos in this part's gallery (shown as "1/N" on image)
  final int totalImages;

  // ── Convenience pass-throughs ──────────────────────────────────────────────
  String get id => machine.id;
  String get name => machine.name;
  String get subtitle => machine.subtitle;
  MachineCategory get category => machine.category;
  StockStatus get status => machine.status;
  String get imageUrl => machine.imageUrl;
  int? get discountPercent => machine.discountPercent;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InventoryMachineModel && other.id == id);

  @override
  int get hashCode => id.hashCode;
}
