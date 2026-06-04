import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../features/home/domain/machine_model.dart';
import '../../../../features/products/data/product_providers.dart';
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
    StateProvider<CategorySelection>((ref) => const CategorySelection.all());

// ─── Filters ─────────────────────────────────────────────────────────────────

class InventoryFiltersNotifier extends StateNotifier<InventoryFilters> {
  InventoryFiltersNotifier() : super(const InventoryFilters());

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

// ─── Source of Truth (real API) ───────────────────────────────────────────────

final allInventoryProvider = Provider<List<InventoryMachineModel>>((ref) {
  return ref
          .watch(allInventoryFromApiProvider)
          .whenOrNull(data: (list) => list) ??
      [];
});

// ─── Loading / error pass-throughs ───────────────────────────────────────────

final inventoryLoadingProvider = Provider<bool>(
  (ref) => ref.watch(allProductsProvider).isLoading,
);

final inventoryErrorProvider = Provider<String?>(
  (ref) => ref.watch(allProductsProvider).whenOrNull(
        error: (e, _) => e.toString(),
      ),
);

// ─── Filtered + Sorted List (derived) ────────────────────────────────────────

final filteredInventoryProvider = Provider<List<InventoryMachineModel>>((ref) {
  final all = ref.watch(allInventoryProvider);
  final category = ref.watch(inventoryCategoryProvider);
  final query = ref.watch(inventorySearchQueryProvider).trim().toLowerCase();
  final filters = ref.watch(inventoryFiltersProvider);

  var list = all;

  // ── Category ──────────────────────────────────────────────────────────────
  if (!category.isAll) {
    list = list
        .where((m) => m.machine.matchesCategorySelection(category))
        .toList();
  }

  // ── Text search ───────────────────────────────────────────────────────────
  if (query.isNotEmpty) {
    list = list
        .where(
          (m) =>
              m.name.toLowerCase().contains(query) ||
              m.subtitle.toLowerCase().contains(query) ||
              m.partNumber.toLowerCase().contains(query),
        )
        .toList();
  }

  // ── Availability ──────────────────────────────────────────────────────────
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

  // ── Brand filter ──────────────────────────────────────────────────────────
  // ── Condition filter ──────────────────────────────────────────────────────
  if (filters.condition != ConditionFilter.all) {
    list = list
        .where((m) =>
            m.condition.toLowerCase() == filters.condition.label.toLowerCase())
        .toList();
  }

  // ── Sort ──────────────────────────────────────────────────────────────────
  switch (filters.sort) {
    case SortOption.nameAZ:
      list = [...list]
        ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    case SortOption.nameZA:
      list = [...list]
        ..sort((a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()));
    case SortOption.newest:
      list = list.reversed.toList();
    case SortOption.relevance:
      break;
  }

  return list;
});
