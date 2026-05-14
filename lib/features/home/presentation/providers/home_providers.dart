import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/mock_machines.dart';
import '../../domain/machine_model.dart';

// ─── Selected Category ────────────────────────────────────────────────────────

final selectedCategoryProvider =
    StateProvider<MachineCategory>((ref) => MachineCategory.all);

// ─── Search Query ─────────────────────────────────────────────────────────────

final searchQueryProvider = StateProvider<String>((ref) => '');

// ─── Favorites ────────────────────────────────────────────────────────────────

class FavoritesNotifier extends StateNotifier<Set<String>> {
  FavoritesNotifier() : super(const {});

  void toggle(String machineId) {
    if (state.contains(machineId)) {
      state = {...state}..remove(machineId);
    } else {
      state = {...state, machineId};
    }
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
