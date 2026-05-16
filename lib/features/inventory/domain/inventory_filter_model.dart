/// Pure domain models for inventory filtering — no Flutter imports.
/// All UI state for the filter bar lives here.

// ─── Enums ────────────────────────────────────────────────────────────────────

enum SortOption {
  relevance('Relevance'),
  nameAZ('Name: A → Z'),
  nameZA('Name: Z → A'),
  newest('Newest First');

  const SortOption(this.label);
  final String label;
}

enum BrandFilter {
  all('All Brands'),
  komatsu('Komatsu'),
  cat('CAT'),
  volvo('Volvo'),
  hitachi('Hitachi'),
  doosan('Doosan');

  const BrandFilter(this.label);
  final String label;
}

enum ConditionFilter {
  all('All Conditions'),
  newOem('New – OEM'),
  used('Used – Good'),
  refurbished('Refurbished');

  const ConditionFilter(this.label);
  final String label;
}

enum AvailabilityFilter {
  all('Availability'),
  inStock('In Stock'),
  lowStock('Low Stock'),
  outOfStock('Out of Stock');

  const AvailabilityFilter(this.label);
  final String label;
}

// ─── Composite Filter State ───────────────────────────────────────────────────

class InventoryFilters {
  const InventoryFilters({
    this.brand = BrandFilter.all,
    this.condition = ConditionFilter.all,
    this.availability = AvailabilityFilter.all,
    this.sort = SortOption.relevance,
  });

  final BrandFilter brand;
  final ConditionFilter condition;
  final AvailabilityFilter availability;
  final SortOption sort;

  bool get hasActiveFilters =>
      brand != BrandFilter.all ||
      condition != ConditionFilter.all ||
      availability != AvailabilityFilter.all ||
      sort != SortOption.relevance;

  InventoryFilters copyWith({
    BrandFilter? brand,
    ConditionFilter? condition,
    AvailabilityFilter? availability,
    SortOption? sort,
  }) {
    return InventoryFilters(
      brand: brand ?? this.brand,
      condition: condition ?? this.condition,
      availability: availability ?? this.availability,
      sort: sort ?? this.sort,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InventoryFilters &&
          other.brand == brand &&
          other.condition == condition &&
          other.availability == availability &&
          other.sort == sort);

  @override
  int get hashCode => Object.hash(brand, condition, availability, sort);
}
