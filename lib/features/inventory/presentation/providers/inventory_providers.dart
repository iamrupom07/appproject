import 'package:ab_abroz_inventory/features/home/domain/machine_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../features/home/domain/machine_model.dart';
import '../../data/mock_inventory.dart';
import '../../domain/inventory_filter_model.dart';
import '../../domain/inventory_machine_model.dart';

// ─── View Mode ────────────────────────────────────────────────────────────────

enum InventoryViewMode { grid, list }

final inventoryViewModeProvider =
    StateProvider<InventoryViewMode>((ref) => InventoryViewMode.grid);

// ─── Search Query ─────────────────────────────────────────────────────────────

final inventorySearchQueryProvider = StateProvider<String>((ref) => '');

// ─── Selected Category ────────────────────────────────────────────────────────

final inventoryCategoryProvider =
    StateProvider<MachineCategory>((ref) => MachineCategory.all);

// ─── Filters ─────────────────────────────────────────────────────────────────

class InventoryFiltersNotifier extends StateNotifier<InventoryFilters> {
  InventoryFiltersNotifier() : super(const InventoryFilters());

  void setBrand(BrandFilter brand) => state = state.copyWith(brand: brand);

  void setCondition(ConditionFilter condition) =>
      state = state.copyWith(condition: condition);

  void setAvailability(AvailabilityFilter availability) =>
      state = state.copyWith(availability: availability);

  void setSort(SortOption sort) => state = state.copyWith(sort: sort);

  void reset() => state = const InventoryFilters();
}

final inventoryFiltersProvider =
    StateNotifierProvider<InventoryFiltersNotifier, InventoryFilters>(
  (ref) => InventoryFiltersNotifier(),
);

// ─── Source of Truth ──────────────────────────────────────────────────────────

final allInventoryProvider = Provider<List<InventoryMachineModel>>(
  (ref) => kInventoryMachines,
);

// ─── Filtered + Sorted List (derived) ────────────────────────────────────────

/// Recomputes whenever category, search, or filters change.
final filteredInventoryProvider = Provider<List<InventoryMachineModel>>((ref) {
  final all = ref.watch(allInventoryProvider);
  final category = ref.watch(inventoryCategoryProvider);
  final query = ref.watch(inventorySearchQueryProvider).trim().toLowerCase();
  final filters = ref.watch(inventoryFiltersProvider);

  var list = all;

  // ── Category ──────────────────────────────────────────────────────────────
  if (category != MachineCategory.all) {
    list = list.where((m) => m.category == category).toList();
  }

  // ── Text search ───────────────────────────────────────────────────────────
  if (query.isNotEmpty) {
    list = list
        .where(
          (m) =>
              m.name.toLowerCase().contains(query) ||
              m.subtitle.toLowerCase().contains(query),
        )
        .toList();
  }

  // ── Availability filter ───────────────────────────────────────────────────
  if (filters.availability != AvailabilityFilter.all) {
    final target = switch (filters.availability) {
      AvailabilityFilter.inStock => StockStatus.inStock,
      AvailabilityFilter.lowStock => StockStatus.lowStock,
      AvailabilityFilter.outOfStock => StockStatus.outOfStock,
      AvailabilityFilter.all => null,
    };
    if (target != null) {
      list = list.where((m) => m.status == target).toList();
    }
  }

  // ── Brand filter (name-based, swap for brand field when model has one) ────
  if (filters.brand != BrandFilter.all) {
    list = list
        .where((m) =>
            m.name.toLowerCase().contains(filters.brand.label.toLowerCase()))
        .toList();
  }

  // ── Sort ──────────────────────────────────────────────────────────────────
  switch (filters.sort) {
    case SortOption.priceLowHigh:
      list = [...list]..sort((a, b) => a.price.compareTo(b.price));
    case SortOption.priceHighLow:
      list = [...list]..sort((a, b) => b.price.compareTo(a.price));
    case SortOption.nameAZ:
      list = [...list]
        ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    case SortOption.relevance:
      break;
  }

  return list;
});
