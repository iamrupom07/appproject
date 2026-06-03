import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/home/domain/machine_model.dart';
import '../../../features/inventory/domain/inventory_machine_model.dart';
import 'product_dto.dart';
import 'product_repository.dart';

// ─── Raw API providers ────────────────────────────────────────────────────────

/// Fetches ALL active products. Invalidate to re-fetch.
final allProductsProvider = FutureProvider<List<ProductDto>>((ref) async {
  final repo = ref.watch(productRepositoryProvider);
  final result = await repo.getProducts(const ProductQuery());
  return result.products;
});

/// Fetches all categories.
final categoriesProvider = FutureProvider<List<CategoryDto>>((ref) async {
  final repo = ref.watch(productRepositoryProvider);
  return repo.getCategories();
});

/// Fetches a single product detail by id.
final productDetailProvider =
    FutureProvider.autoDispose.family<ProductDto, String>((ref, id) async {
  final repo = ref.watch(productRepositoryProvider);
  return repo.getSingleProduct(id);
});

// ─── Derived: MachineModel list (Home screen) ─────────────────────────────────

/// Converts all products → MachineModel list.
final allMachinesFromApiProvider = Provider<AsyncValue<List<MachineModel>>>(
  (ref) => ref.watch(allProductsProvider).whenData(
        (products) => products.map((p) => p.toMachineModel()).toList(),
      ),
);

// ─── Derived: InventoryMachineModel list ─────────────────────────────────────

final allInventoryFromApiProvider =
    Provider<AsyncValue<List<InventoryMachineModel>>>(
  (ref) => ref.watch(allProductsProvider).whenData(
        (products) => products.map((p) => p.toInventoryModel()).toList(),
      ),
);
