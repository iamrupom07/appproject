import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../features/products/data/product_providers.dart';
import '../../domain/machine_model.dart';

// ─── Selected Category ────────────────────────────────────────────────────────

final selectedCategoryProvider =
    StateProvider<MachineCategory>((ref) => MachineCategory.all);

// ─── Search Query ─────────────────────────────────────────────────────────────

final searchQueryProvider = StateProvider<String>((ref) => '');

// ─── Favorites (guest, persisted to SharedPreferences) ───────────────────────

const _kFavoritesKey = 'guest_favorites';

class FavoritesNotifier extends StateNotifier<Set<String>> {
  FavoritesNotifier() : super(const {}) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_kFavoritesKey) ?? [];
    state = saved.toSet();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_kFavoritesKey, state.toList());
  }

  void toggle(String machineId) {
    if (state.contains(machineId)) {
      state = {...state}..remove(machineId);
    } else {
      state = {...state, machineId};
    }
    _persist();
  }

  bool isFavorite(String machineId) => state.contains(machineId);
}

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, Set<String>>(
  (ref) => FavoritesNotifier(),
);

// ─── All Machines (source of truth — real API) ────────────────────────────────

/// Returns the full product list as [MachineModel]s.
/// Returns an empty list while loading or on error — downstream widgets use
/// [machinesLoadingProvider] / [machinesErrorProvider] for skeleton/error UI.
final allMachinesProvider = Provider<List<MachineModel>>((ref) {
  return ref
          .watch(allMachinesFromApiProvider)
          .whenOrNull(data: (list) => list) ??
      [];
});

// ─── Loading / error state (for skeleton UI) ─────────────────────────────────

final machinesLoadingProvider = Provider<bool>((ref) {
  return ref.watch(allProductsProvider).isLoading;
});

final machinesErrorProvider = Provider<String?>((ref) {
  return ref.watch(allProductsProvider).whenOrNull(
        error: (e, _) => e.toString(),
      );
});

// ─── Filtered Machines (derived) ──────────────────────────────────────────────

final filteredMachinesProvider = Provider<List<MachineModel>>((ref) {
  final all = ref.watch(allMachinesProvider);
  final category = ref.watch(selectedCategoryProvider);
  final query = ref.watch(searchQueryProvider).trim().toLowerCase();

  var list = all;

  if (category != MachineCategory.all) {
    list = list.where((m) => m.category == category).toList();
  }

  if (query.isNotEmpty) {
    list = list
        .where(
          (m) =>
              m.name.toLowerCase().contains(query) ||
              m.subtitle.toLowerCase().contains(query),
        )
        .toList();
  }

  return list;
});

// ─── Featured Machines ────────────────────────────────────────────────────────

/// First 4 in-stock products become the featured banner.
final featuredMachinesProvider = Provider<List<MachineModel>>((ref) {
  return ref
      .watch(allMachinesProvider)
      .where((m) => m.status == StockStatus.inStock)
      .take(4)
      .toList();
});

// ─── Trending Machines ────────────────────────────────────────────────────────

final trendingMachinesProvider = Provider<List<MachineModel>>((ref) {
  final all = ref.watch(allMachinesProvider);
  final sorted = [...all]
    ..sort((a, b) => a.status.index.compareTo(b.status.index));
  return sorted.take(6).toList();
});

// ─── Recently Added ───────────────────────────────────────────────────────────

final recentlyAddedProvider = Provider<List<MachineModel>>((ref) {
  return ref
      .watch(allMachinesProvider)
      .where((m) => m.isRecentlyAdded)
      .take(6)
      .toList();
});

// ─── Favorites Screen Providers ───────────────────────────────────────────────

enum FavoritesSort {
  recent('Recently Added'),
  priceAsc('Price: Low to High'),
  priceDesc('Price: High to Low'),
  category('Category');

  const FavoritesSort(this.label);
  final String label;
}

final favoritesSortProvider =
    StateProvider<FavoritesSort>((ref) => FavoritesSort.recent);

final favoritedMachinesProvider = Provider<List<MachineModel>>((ref) {
  final ids = ref.watch(favoritesProvider);
  final all = ref.watch(allMachinesProvider);
  final sort = ref.watch(favoritesSortProvider);

  var list = all.where((m) => ids.contains(m.id)).toList();

  switch (sort) {
    case FavoritesSort.recent:
      break;
    case FavoritesSort.priceAsc:
    case FavoritesSort.priceDesc:
      break;
    case FavoritesSort.category:
      list.sort((a, b) => a.category.label.compareTo(b.category.label));
  }

  return list;
});
