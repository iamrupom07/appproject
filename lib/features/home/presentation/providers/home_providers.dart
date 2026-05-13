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
/// No logic in the UI layer.
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

// ─── Featured Machines (for banner / top strip) ───────────────────────────────

final featuredMachinesProvider = Provider<List<MachineModel>>((ref) {
  return ref
      .watch(allMachinesProvider)
      .where((m) => m.isFeatured)
      .take(3)
      .toList();
});
