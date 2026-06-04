/// Domain model for a heavy machinery item.
/// Intentionally kept pure — no Flutter imports, no JSON logic here.
/// Serialization lives in the data layer.
class MachineModel {
  const MachineModel({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.category,
    required this.status,
    required this.imageUrl,
    this.categoryId,
    this.categoryName,
    this.isFeatured = false,
    this.isNew = false,
    this.isRecentlyAdded = false,
    this.discountPercent,
  });

  final String id;
  final String name;
  final String subtitle;
  final MachineCategory category;
  final StockStatus status;
  final String imageUrl;
  final String? categoryId;
  final String? categoryName;
  final bool isFeatured;
  final bool isNew;
  final bool isRecentlyAdded;

  /// Nullable — null means no active discount.
  /// Used to show a discount badge on cards.
  final int? discountPercent;

  bool matchesCategorySelection(CategorySelection selection) {
    if (selection.isAll) return true;

    final selectedId = selection.id;
    if (selectedId != null) {
      return categoryId == selectedId;
    }

    final selectedCategory = selection.category;
    if (selectedCategory != null && selectedCategory != MachineCategory.all) {
      return category == selectedCategory;
    }

    final selectedLabel = selection.label.trim().toLowerCase();
    final ownCategoryLabel = (categoryName ?? category.label).toLowerCase();
    return ownCategoryLabel == selectedLabel ||
        ownCategoryLabel.contains(selectedLabel) ||
        selectedLabel.contains(ownCategoryLabel);
  }

  MachineModel copyWith({
    String? id,
    String? name,
    String? subtitle,
    MachineCategory? category,
    StockStatus? status,
    String? imageUrl,
    String? categoryId,
    String? categoryName,
    bool? isFeatured,
    bool? isNew,
    bool? isRecentlyAdded,
    int? discountPercent,
  }) {
    return MachineModel(
      id: id ?? this.id,
      name: name ?? this.name,
      subtitle: subtitle ?? this.subtitle,
      category: category ?? this.category,
      status: status ?? this.status,
      imageUrl: imageUrl ?? this.imageUrl,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      isFeatured: isFeatured ?? this.isFeatured,
      isNew: isNew ?? this.isNew,
      isRecentlyAdded: isRecentlyAdded ?? this.isRecentlyAdded,
      discountPercent: discountPercent ?? this.discountPercent,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is MachineModel && other.id == id);

  @override
  int get hashCode => id.hashCode;
}

class CategorySelection {
  const CategorySelection({
    this.id,
    required this.label,
    this.category,
  });

  const CategorySelection.all()
      : id = null,
        label = 'All',
        category = MachineCategory.all;

  factory CategorySelection.fromCategory(MachineCategory category) {
    return CategorySelection(
      label: category.label,
      category: category,
    );
  }

  factory CategorySelection.fromApi({
    required String id,
    required String label,
    MachineCategory? category,
  }) {
    return CategorySelection(
      id: id,
      label: label,
      category: category,
    );
  }

  final String? id;
  final String label;
  final MachineCategory? category;

  bool get isAll {
    return id == null &&
        (category == null || category == MachineCategory.all) &&
        label.toLowerCase() == 'all';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is CategorySelection &&
            other.id == id &&
            other.label == label &&
            other.category == category);
  }

  @override
  int get hashCode => Object.hash(id, label, category);
}

enum MachineCategory {
  all('All'),
  engineParts('Engine Parts'),
  hydraulics('Hydraulics'),
  undercarriage('Undercarriage'),
  chassis('Chassis'),
  electrical('Electrical'),
  groundEngaging('Ground Engaging Tools'),
  armBoomBucket('Arm/Boom & Bucket'),
  controlValve('Control Valve / Main Pump'),
  engineSupport('Engine Support Parts'),
  hydraulicPump('Hydraulic Pump Spares'),
  radiator('Radiator'),
  cabinElectrical('Cabin & Electrical Spares'),
  swingMotor('Swing Motor'),
  turnTable('Turn Table'),
  dozer('Dozer');

  const MachineCategory(this.label);
  final String label;
}

enum StockStatus {
  inStock('In Stock'),
  lowStock('Low Stock'),
  outOfStock('Out of Stock');

  const StockStatus(this.label);
  final String label;
}
