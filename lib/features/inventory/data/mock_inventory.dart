import '../domain/inventory_machine_model.dart';
import '../../home/data/mock_machines.dart';

/// Full inventory mock data with spec details — spare parts edition.
/// Swap with a Dio repository call when backend is ready.
final List<InventoryMachineModel> kInventoryMachines = [
  InventoryMachineModel(
    machine: kMockMachines.firstWhere((m) => m.id == '1'),
    partNumber: 'KOM-SA6D102-001',
    compatibility: 'PC200-8, PC210LC-8',
    condition: 'Used – Good',
    totalImages: 8,
  ),
  InventoryMachineModel(
    machine: kMockMachines.firstWhere((m) => m.id == '4'),
    partNumber: 'KOM-HPV132-004',
    compatibility: 'PC200-8, PC220-8',
    condition: 'Refurbished',
    totalImages: 7,
  ),
  InventoryMachineModel(
    machine: kMockMachines.firstWhere((m) => m.id == '7'),
    partNumber: 'KOM-TRK200-007',
    compatibility: 'PC200, PC200LC Series',
    condition: 'Used – Good',
    totalImages: 6,
  ),
  InventoryMachineModel(
    machine: kMockMachines.firstWhere((m) => m.id == '3'),
    partNumber: 'KOM-BC200-003',
    compatibility: 'PC200-8, PC210',
    condition: 'New – OEM',
    totalImages: 9,
  ),
  InventoryMachineModel(
    machine: kMockMachines.firstWhere((m) => m.id == '2'),
    partNumber: 'KOM-SWM130-002',
    compatibility: 'PC130, PC200',
    condition: 'Refurbished',
    totalImages: 5,
  ),
  InventoryMachineModel(
    machine: kMockMachines.firstWhere((m) => m.id == '5'),
    partNumber: 'KOM-RAD200-005',
    compatibility: 'PC200, PC220 Series',
    condition: 'Used – Good',
    totalImages: 4,
  ),
  InventoryMachineModel(
    machine: kMockMachines.firstWhere((m) => m.id == '6'),
    partNumber: 'KOM-MCV200-006',
    compatibility: 'PC200-8',
    condition: 'Refurbished',
    totalImages: 6,
  ),
  InventoryMachineModel(
    machine: kMockMachines.firstWhere((m) => m.id == '8'),
    partNumber: 'KOM-GET200-008',
    compatibility: 'PC200, PC210, PC220',
    condition: 'New – OEM',
    totalImages: 5,
  ),
  InventoryMachineModel(
    machine: kMockMachines.firstWhere((m) => m.id == '9'),
    partNumber: 'KOM-WH200-009',
    compatibility: 'PC200-8, PC210LC',
    condition: 'Used – Good',
    totalImages: 3,
  ),
  InventoryMachineModel(
    machine: kMockMachines.firstWhere((m) => m.id == '10'),
    partNumber: 'KOM-TTB200-010',
    compatibility: 'PC200, PC200LC Series',
    condition: 'Refurbished',
    totalImages: 4,
  ),
];
