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
      catId = cat['_id'] as String?;
      catName = cat['name'] as String?;
    } else if (cat is String) {
      catId = cat;
    }

    return ProductDto(
      id: (json['_id'] ?? json['id']) as String,
      name: json['name'] as String,
      origin: json['origin'] as String?,
      partNumber: json['partNumber'] as String?,
      brandName: json['brandName'] as String?,
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      categoryId: catId,
      categoryName: catName,
      condition: json['condition'] as String? ?? 'used',
      compatibility: json['compatibility'] as String?,
      description: json['description'] as String? ?? '',
      features: (json['features'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      shippingInfo: json['shippingInfo'] as String?,
      conditionNotes: json['conditionNotes'] as String?,
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      status: json['status'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
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
      id: (json['_id'] ?? json['id']) as String,
      name: json['name'] as String,
      description: json['description'] as String?,
    );
  }
}

// ─── Fallback ─────────────────────────────────────────────────────────────────

const _kPlaceholderImage =
    'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800&q=80';
