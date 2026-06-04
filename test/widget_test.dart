import 'package:abroz_parts_plus/features/home/domain/machine_model.dart';
import 'package:abroz_parts_plus/features/products/data/product_dto.dart';
import 'package:flutter_test/flutter_test.dart';

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
    expect(dto.categoryName, 'Hydraulic Pump Spares');
    expect(dto.features, ['Bench tested', 'Cleaned']);
    expect(machine.id, 'product-1');
    expect(machine.category, MachineCategory.hydraulicPump);
    expect(machine.imageUrl, 'https://example.com/pump.jpg');
    expect(inventory.partNumber, '708-2L-00650');
    expect(inventory.condition, 'Refurbished');
    expect(inventory.totalImages, 1);
  });
}
