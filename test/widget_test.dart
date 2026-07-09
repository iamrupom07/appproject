import 'package:abroz_parts_plus/features/home/domain/machine_model.dart';
import 'package:abroz_parts_plus/features/home/presentation/home_screen.dart';
import 'package:abroz_parts_plus/features/inventory/domain/inventory_machine_model.dart';
import 'package:abroz_parts_plus/features/inventory/presentation/inventory_screen.dart';
import 'package:abroz_parts_plus/features/inventory/presentation/providers/inventory_providers.dart';
import 'package:abroz_parts_plus/features/inventory/presentation/widgets/inventory_machine_card.dart';
import 'package:abroz_parts_plus/features/products/data/product_dto.dart';
import 'package:abroz_parts_plus/features/products/data/product_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('ProductDto maps production product payloads into app models', () {
    final dto = ProductDto.fromJson({
      '_id': 'product-1',
      'name': 'Komatsu Main Pump',
      'origin': 'Japan',
      'partNumber': '708-2L-00650',
      'brandName': 'Komatsu',
      'quantity': 3,
      'categoryId': {
        '_id': 'category-1',
        'name': 'Hydraulic Pump Spares',
      },
      'condition': 'refurbished',
      'compatibility': 'PC200-8',
      'description': 'Ready for installation.',
      'features': ['Bench tested', 'Cleaned'],
      'shippingInfo': 'Pickup or freight available.',
      'conditionNotes': 'Minor cosmetic wear.',
      'images': ['https://example.com/pump.jpg'],
      'status': 'active',
      'createdAt': '2026-06-01T00:00:00.000Z',
    });

    final machine = dto.toMachineModel();
    final inventory = dto.toInventoryModel();

    expect(dto.id, 'product-1');
    expect(dto.categoryId, 'category-1');
    expect(dto.categoryName, 'Hydraulic Pump Spares');
    expect(dto.features, ['Bench tested', 'Cleaned']);
    expect(machine.id, 'product-1');
    expect(machine.categoryId, 'category-1');
    expect(machine.categoryName, 'Hydraulic Pump Spares');
    expect(machine.category, MachineCategory.hydraulicPump);
    expect(machine.imageUrl, 'https://example.com/pump.jpg');
    expect(inventory.categoryId, 'category-1');
    expect(inventory.categoryName, 'Hydraulic Pump Spares');
    expect(inventory.partNumber, '708-2L-00650');
    expect(inventory.condition, 'Refurbished');
    expect(inventory.totalImages, 1);
  });

  test('Inventory filters unknown API category names by category id', () {
    final sfdf = _product(
      id: 'product-sfdf',
      name: 'Unknown Category Part',
      categoryId: 'category-sfdf',
      categoryName: 'sfdf',
    ).toInventoryModel();
    final hydraulic = _product(
      id: 'product-hydraulic',
      name: 'Hydraulic Pump',
      categoryId: 'category-hydraulic',
      categoryName: 'Hydraulic Pump Spares',
    ).toInventoryModel();

    final container = ProviderContainer(
      overrides: [
        allInventoryFromApiProvider.overrideWithValue(
          AsyncValue.data([sfdf, hydraulic]),
        ),
      ],
    );
    addTearDown(container.dispose);

    container.read(inventoryCategoryProvider.notifier).state =
        CategorySelection.fromApi(id: 'category-sfdf', label: 'sfdf');

    expect(
      container.read(filteredInventoryProvider).map((m) => m.id),
      ['product-sfdf'],
    );

    container.read(inventoryCategoryProvider.notifier).state =
        const CategorySelection.all();

    expect(container.read(filteredInventoryProvider), hasLength(2));
  });

  testWidgets('Inventory grid card fits long product text', (tester) async {
    SharedPreferences.setMockInitialValues({});

    const machine = InventoryMachineModel(
      machine: MachineModel(
        id: 'long-product',
        name: 'Extremely Long Machinery Spare Part Name That Should Truncate',
        subtitle:
            'Very long model compatibility summary that should stay contained',
        category: MachineCategory.all,
        status: StockStatus.inStock,
        imageUrl: 'https://example.com/part.jpg',
        categoryId: 'category-long',
        categoryName: 'sfdf',
      ),
      partNumber: 'PART-NUMBER-1234567890-EXTRA-LONG',
      compatibility: 'PC200-8, PC210LC-8, PC220-8, PC300-8, PC350-8',
      condition: 'Refurbished',
      totalImages: 3,
    );

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 160,
                height: 292,
                child: InventoryMachineCard(machine: machine),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
  });

  testWidgets('Home screen includes pull-to-refresh', (tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          allProductsProvider.overrideWith((ref) async => <ProductDto>[]),
          categoriesProvider.overrideWith((ref) async => <CategoryDto>[]),
        ],
        child: const MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(RefreshIndicator), findsOneWidget);
  });

  testWidgets('Inventory screen includes pull-to-refresh', (tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          allProductsProvider.overrideWith((ref) async => <ProductDto>[]),
          categoriesProvider.overrideWith((ref) async => <CategoryDto>[]),
        ],
        child: const MaterialApp(
          home: InventoryScreen(),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(RefreshIndicator), findsOneWidget);
  });
}

ProductDto _product({
  required String id,
  required String name,
  required String categoryId,
  required String categoryName,
}) {
  return ProductDto.fromJson({
    '_id': id,
    'name': name,
    'partNumber': 'PN-$id',
    'quantity': 1,
    'categoryId': {
      '_id': categoryId,
      'name': categoryName,
    },
    'condition': 'used',
    'compatibility': 'PC200-8',
    'description': 'Ready for installation.',
    'images': ['https://example.com/$id.jpg'],
    'status': 'active',
  });
}
