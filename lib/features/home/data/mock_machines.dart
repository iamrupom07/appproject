import '../domain/machine_model.dart';

/// Static mock data — spare parts for Komatsu heavy equipment.
/// Swap this out with a real Dio repository call later.
const List<MachineModel> kMockMachines = [
  // ── Featured ─────────────────────────────────────────────────────────────────
  MachineModel(
    id: '1',
    name: 'Komatsu PC200 Engine Assembly',
    subtitle: 'Complete Engine Unit – SA6D102',
    category: MachineCategory.engineParts,
    status: StockStatus.inStock,
    imageUrl:
        'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800&q=80',
    isFeatured: true,
  ),
  MachineModel(
    id: '4',
    name: 'Hydraulic Main Pump',
    subtitle: 'Komatsu PC200-8 / PC220-8',
    category: MachineCategory.hydraulics,
    status: StockStatus.inStock,
    imageUrl:
        'https://images.unsplash.com/photo-1590516516091-4aeeba72b8ea?w=800&q=80',
    isFeatured: true,
    discountPercent: 10,
  ),
  MachineModel(
    id: '7',
    name: 'Track Chain Assembly',
    subtitle: 'Undercarriage – PC200 Series',
    category: MachineCategory.undercarriage,
    status: StockStatus.lowStock,
    imageUrl:
        'https://images.unsplash.com/photo-1580674285054-bed31e145f59?w=800&q=80',
    isFeatured: true,
  ),

  // ── Trending ────────────────────────────────────────────────────────────────
  MachineModel(
    id: '2',
    name: 'Swing Motor Assembly',
    subtitle: 'Komatsu PC130 / PC200',
    category: MachineCategory.swingMotor,
    status: StockStatus.inStock,
    imageUrl:
        'https://images.unsplash.com/photo-1504307651254-35680f356dfd?w=400&q=80',
  ),
  MachineModel(
    id: '3',
    name: 'Boom Cylinder Seal Kit',
    subtitle: 'Arm/Boom – PC200-8 Series',
    category: MachineCategory.armBoomBucket,
    status: StockStatus.inStock,
    imageUrl:
        'https://images.unsplash.com/photo-1581094794329-c8112a89af12?w=400&q=80',
    discountPercent: 15,
  ),
  MachineModel(
    id: '5',
    name: 'Radiator Assembly',
    subtitle: 'Komatsu PC200 / PC220 Series',
    category: MachineCategory.radiator,
    status: StockStatus.lowStock,
    imageUrl:
        'https://images.unsplash.com/photo-1563520239648-a1e8d97a1177?w=400&q=80',
  ),
  MachineModel(
    id: '6',
    name: 'Control Valve Assembly',
    subtitle: 'Main Control Valve – PC200-8',
    category: MachineCategory.controlValve,
    status: StockStatus.outOfStock,
    imageUrl:
        'https://images.unsplash.com/photo-1541888946425-d81bb19240f5?w=400&q=80',
  ),

  // ── Recently Added ────────────────────────────────────────────────────────────
  MachineModel(
    id: '8',
    name: 'Bucket Tooth & Adapter Set',
    subtitle: 'Ground Engaging Tools – PC200',
    category: MachineCategory.groundEngaging,
    status: StockStatus.inStock,
    imageUrl:
        'https://images.unsplash.com/photo-1586864387789-628af9feed72?w=400&q=80',
    isNew: true,
    isRecentlyAdded: true,
  ),
  MachineModel(
    id: '9',
    name: 'Cabin Wiring Harness',
    subtitle: 'Electrical – PC200-8 / PC210',
    category: MachineCategory.cabinElectrical,
    status: StockStatus.inStock,
    imageUrl:
        'https://images.unsplash.com/photo-1504307651254-35680f356dfd?w=400&q=80',
    isNew: true,
    isRecentlyAdded: true,
    discountPercent: 5,
  ),
  MachineModel(
    id: '10',
    name: 'Turn Table Bearing',
    subtitle: 'Swing Circle – PC200 Series',
    category: MachineCategory.turnTable,
    status: StockStatus.inStock,
    imageUrl:
        'https://images.unsplash.com/photo-1513828583688-c52646db42da?w=400&q=80',
    isNew: true,
    isRecentlyAdded: true,
  ),
];
