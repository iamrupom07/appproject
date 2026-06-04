import '../../home/domain/machine_model.dart';
import '../../inventory/domain/inventory_machine_model.dart';

/// DTO that maps directly to the backend Product + populated categoryId fields.
class ProductDto {
  const ProductDto({
    required this.id,
    required this.name,
    this.origin,
    this.partNumber,
    this.brandName,
    required this.quantity,
    this.categoryId,
    this.categoryName,
    required this.condition,
    this.compatibility,
    required this.description,
    this.features = const [],
    this.shippingInfo,
    this.conditionNotes,
    this.images = const [],
    this.status,
    this.createdAt,
  });

  final String id;
  final String name;
  final String? origin;
  final String? partNumber;
  final String? brandName;
  final int quantity;
  final String? categoryId;
  final String? categoryName; // from populated categoryId.name
  final String condition; // 'new' | 'used' | 'refurbished'
  final String? compatibility;
  final String description;
  final List<String> features;
  final String? shippingInfo;
  final String? conditionNotes;
  final List<String> images;
  final String? status; // 'active' | 'draft'
  final DateTime? createdAt;

  factory ProductDto.fromJson(Map<String, dynamic> json) {
    String? catId;
    String? catName;
    final cat = json['categoryId'];
    if (cat is Map<String, dynamic>) {
      catId = _stringOrNull(cat['_id']) ?? _stringOrNull(cat['id']);
      catName = _stringOrNull(cat['name']);
    } else if (cat is String) {
      catId = cat;
    }

    return ProductDto(
      id: _stringOrNull(json['_id']) ?? _stringOrNull(json['id']) ?? '',
      name: _stringOrNull(json['name']) ?? '',
      origin: _stringOrNull(json['origin']),
      partNumber: _stringOrNull(json['partNumber']),
      brandName: _stringOrNull(json['brandName']),
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      categoryId: catId,
      categoryName: catName,
      condition: _stringOrNull(json['condition']) ?? 'used',
      compatibility: _stringOrNull(json['compatibility']),
      description: _stringOrNull(json['description']) ?? '',
      features: _stringList(json['features']),
      shippingInfo: _stringOrNull(json['shippingInfo']),
      conditionNotes: _stringOrNull(json['conditionNotes']),
      images: _stringList(json['images']),
      status: _stringOrNull(json['status']),
      createdAt: _dateTimeOrNull(json['createdAt']),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  String get primaryImage =>
      images.isNotEmpty ? images.first : _kPlaceholderImage;

  String get conditionLabel {
    switch (condition) {
      case 'new':
        return 'New – OEM';
      case 'refurbished':
        return 'Refurbished';
      default:
        return 'Used – Good';
    }
  }

  /// Client requirement: all items are always shown as "In Stock" regardless
  /// of the quantity value in the database.
  StockStatus get stockStatus => StockStatus.inStock;

  MachineCategory get machineCategory {
    final name = (categoryName ?? '').toLowerCase();
    for (final cat in MachineCategory.values) {
      if (cat == MachineCategory.all) continue;
      if (name.contains(cat.label.toLowerCase()) ||
          cat.label.toLowerCase().contains(name)) {
        return cat;
      }
    }
    return MachineCategory.all;
  }

  bool get isNew =>
      createdAt != null && DateTime.now().difference(createdAt!).inDays <= 14;

  /// Convert to the [MachineModel] used across the Home and Favorites screens.
  MachineModel toMachineModel() {
    return MachineModel(
      id: id,
      name: name,
      subtitle: compatibility ?? categoryName ?? '',
      category: machineCategory,
      status: stockStatus,
      imageUrl: primaryImage,
      categoryId: categoryId,
      categoryName: categoryName,
      isFeatured: false,
      isNew: isNew,
      isRecentlyAdded: isNew,
    );
  }

  /// Convert to the richer [InventoryMachineModel] used on the Inventory screen.
  InventoryMachineModel toInventoryModel() {
    return InventoryMachineModel(
      machine: toMachineModel(),
      partNumber: partNumber ?? '—',
      compatibility: compatibility ?? '—',
      condition: conditionLabel,
      totalImages: images.length.clamp(1, 99),
    );
  }
}

// ─── Category DTO ─────────────────────────────────────────────────────────────

class CategoryDto {
  const CategoryDto({
    required this.id,
    required this.name,
    this.description,
  });

  final String id;
  final String name;
  final String? description;

  factory CategoryDto.fromJson(Map<String, dynamic> json) {
    return CategoryDto(
      id: _stringOrNull(json['_id']) ?? _stringOrNull(json['id']) ?? '',
      name: _stringOrNull(json['name']) ?? '',
      description: _stringOrNull(json['description']),
    );
  }
}

// ─── Fallback ─────────────────────────────────────────────────────────────────

String? _stringOrNull(dynamic value) {
  if (value is String) return value;
  return null;
}

List<String> _stringList(dynamic value) {
  if (value is! List) return const [];
  return value.whereType<String>().toList();
}

DateTime? _dateTimeOrNull(dynamic value) {
  if (value is String) return DateTime.tryParse(value);
  if (value is DateTime) return value;
  return null;
}

const _kPlaceholderImage =
    'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800&q=80';
