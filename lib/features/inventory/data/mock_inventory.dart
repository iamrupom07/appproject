import '../domain/inventory_machine_model.dart';
import '../../home/data/mock_machines.dart';
import '../../home/domain/machine_model.dart';

/// Full inventory mock data with spec details.
/// Swap with a Dio repository call when backend is ready.
final List<InventoryMachineModel> kInventoryMachines = [
  InventoryMachineModel(
    machine: kMockMachines.firstWhere((m) => m.id == '1'),
    operatingWeightKg: 22200,
    capacityM3: 1.0,
    capacityLabel: 'Bucket Capacity',
    totalImages: 8,
  ),
  InventoryMachineModel(
    machine: kMockMachines.firstWhere((m) => m.id == '4'),
    operatingWeightKg: 18300,
    capacityM3: 3.1,
    capacityLabel: 'Bucket Capacity',
    totalImages: 7,
  ),
  InventoryMachineModel(
    machine: kMockMachines.firstWhere((m) => m.id == '7'),
    operatingWeightKg: 20640,
    capacityM3: 4.3,
    capacityLabel: 'Blade Capacity',
    totalImages: 6,
  ),
  InventoryMachineModel(
    machine: kMockMachines.firstWhere((m) => m.id == '3'),
    operatingWeightKg: 22400,
    capacityM3: 1.2,
    capacityLabel: 'Bucket Capacity',
    totalImages: 9,
  ),
  InventoryMachineModel(
    machine: kMockMachines.firstWhere((m) => m.id == '2'),
    operatingWeightKg: 21500,
    capacityM3: 0.9,
    capacityLabel: 'Bucket Capacity',
    totalImages: 5,
  ),
  InventoryMachineModel(
    machine: kMockMachines.firstWhere((m) => m.id == '5'),
    operatingWeightKg: 14800,
    capacityM3: 2.1,
    capacityLabel: 'Bucket Capacity',
    totalImages: 4,
  ),
  InventoryMachineModel(
    machine: kMockMachines.firstWhere((m) => m.id == '6'),
    operatingWeightKg: 23100,
    capacityM3: 3.8,
    capacityLabel: 'Blade Capacity',
    totalImages: 6,
  ),
  InventoryMachineModel(
    machine: kMockMachines.firstWhere((m) => m.id == '8'),
    operatingWeightKg: 41000,
    capacityM3: 27.5,
    capacityLabel: 'Body Capacity',
    totalImages: 7,
  ),
  InventoryMachineModel(
    machine: kMockMachines.firstWhere((m) => m.id == '9'),
    operatingWeightKg: 48200,
    capacityM3: 2.2,
    capacityLabel: 'Bucket Capacity',
    totalImages: 8,
  ),
  InventoryMachineModel(
    machine: kMockMachines.firstWhere((m) => m.id == '10'),
    operatingWeightKg: 56000,
    capacityM3: 60.0,
    capacityLabel: 'Lift Capacity',
    totalImages: 10,
  ),
  // Extra entries to reach a meaningful count
  InventoryMachineModel(
    machine: const MachineModel(
      id: '11',
      name: 'Hitachi ZX350LC-6',
      subtitle: 'Large Excavator',
      category: MachineCategory.excavators,
      price: 278000,
      status: StockStatus.inStock,
      imageUrl:
          'https://images.unsplash.com/photo-1504307651254-35680f356dfd?w=800&q=80',
    ),
    operatingWeightKg: 35200,
    capacityM3: 1.8,
    capacityLabel: 'Bucket Capacity',
    totalImages: 6,
  ),
  InventoryMachineModel(
    machine: const MachineModel(
      id: '12',
      name: 'CAT 966M',
      subtitle: 'Medium Wheel Loader',
      category: MachineCategory.wheelLoaders,
      price: 310000,
      status: StockStatus.lowStock,
      imageUrl:
          'https://images.unsplash.com/photo-1590516516091-4aeeba72b8ea?w=800&q=80',
    ),
    operatingWeightKg: 24700,
    capacityM3: 4.0,
    capacityLabel: 'Bucket Capacity',
    totalImages: 5,
  ),
];
