import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/mock_machines.dart';
import '../../domain/machine_model.dart';

// ─── Selected Category ────────────────────────────────────────────────────────

final selectedCategoryProvider =
StateProvider<MachineCategory>((ref) => MachineCategory.all);

// ─── Search Query ─────────────────────────────────────────────────────────────

final searchQueryProvider = StateProvider<String>((ref) => '');

// ─── Favorites ────────────────────────────────────────────────────────────────

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

// ─── All Machines (source of truth) ──────────────────────────────────────────

final allMachinesProvider = Provider<List<MachineModel>>(
      (ref) => kMockMachines,
);

// ─── Filtered Machines (derived) ─────────────────────────────────────────────

/// Derived provider — recomputes automatically when category or search changes.
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

// ─── Featured Machines (hero carousel) ────────────────────────────────────────

final featuredMachinesProvider = Provider<List<MachineModel>>((ref) {
  return ref
      .watch(allMachinesProvider)
      .where((m) => m.isFeatured)
      .take(4)
      .toList();
});

// ─── Trending Machines ────────────────────────────────────────────────────────

/// Non-featured machines ordered to show in-stock first, then low-stock.
final trendingMachinesProvider = Provider<List<MachineModel>>((ref) {
  final all = ref.watch(allMachinesProvider);
  final nonFeatured = all.where((m) => !m.isFeatured).toList()
    ..sort((a, b) => a.status.index.compareTo(b.status.index));
  return nonFeatured.take(3).toList();
});

// ─── Recently Added Machines ──────────────────────────────────────────────────

final recentlyAddedProvider = Provider<List<MachineModel>>((ref) {
  return ref
      .watch(allMachinesProvider)
      .where((m) => m.isRecentlyAdded)
      .take(3)
      .toList();
});

// ─── Favorites Screen Providers ───────────────────────────────────────────────

/// Sort options available on the Favorites screen.
enum FavoritesSort {
  recent('Recently Added'),
  priceAsc('Price: Low to High'),
  priceDesc('Price: High to Low'),
  category('Category');

  const FavoritesSort(this.label);
  final String label;
}

/// Persists the currently selected sort order for the Favorites screen.
final favoritesSortProvider =
StateProvider<FavoritesSort>((ref) => FavoritesSort.recent);

/// Derives the full [MachineModel] list from the saved ID set, then applies
/// the selected sort. Recomputes automatically whenever favorites or sort changes.
final favoritedMachinesProvider = Provider<List<MachineModel>>((ref) {
  final ids = ref.watch(favoritesProvider);
  final all = ref.watch(allMachinesProvider);
  final sort = ref.watch(favoritesSortProvider);

  // Preserve insertion order by filtering all machines
  var list = all.where((m) => ids.contains(m.id)).toList();

  switch (sort) {
    case FavoritesSort.recent:
    // Keep natural insertion order (no-op; ids is a Set so order tracks adds)
      break;
    case FavoritesSort.priceAsc:
    // price sort removed — pricing is upon request
    case FavoritesSort.priceDesc:
    // price sort removed — pricing is upon request
    case FavoritesSort.category:
      list.sort((a, b) => a.category.label.compareTo(b.category.label));
  }

  return list;
});