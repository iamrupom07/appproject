import '../domain/machine_model.dart';

/// Static mock data — swap this out with a real Dio repository call later.
const List<MachineModel> kMockMachines = [
  // ── Featured ─────────────────────────────────────────────────────────────────
  MachineModel(
    id: '1',
    name: 'Komatsu PC 210 LC-11',
    subtitle: 'Hydraulic Excavator',
    category: MachineCategory.excavators,
    price: 149000,
    status: StockStatus.inStock,
    imageUrl:
        'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800&q=80',
    isFeatured: true,
  ),
  MachineModel(
    id: '4',
    name: 'CAT 950 GC',
    subtitle: 'Wheel Loader',
    category: MachineCategory.wheelLoaders,
    price: 125000,
    status: StockStatus.inStock,
    imageUrl:
        'https://images.unsplash.com/photo-1590516516091-4aeeba72b8ea?w=800&q=80',
    isFeatured: true,
  ),
  MachineModel(
    id: '7',
    name: 'Komatsu D65PX-18',
    subtitle: 'Bulldozer',
    category: MachineCategory.bulldozers,
    price: 205000,
    status: StockStatus.lowStock,
    imageUrl:
        'https://images.unsplash.com/photo-1580674285054-bed31e145f59?w=800&q=80',
    isFeatured: true,
  ),

  // ── Trending (non-featured, in-stock / low-stock) ────────────────────────────
  MachineModel(
    id: '2',
    name: 'CAT 320 GC',
    subtitle: 'Next Gen Excavator',
    category: MachineCategory.excavators,
    price: 135000,
    status: StockStatus.inStock,
    imageUrl:
        'https://images.unsplash.com/photo-1504307651254-35680f356dfd?w=400&q=80',
  ),
  MachineModel(
    id: '3',
    name: 'Volvo EC220E',
    subtitle: 'Crawler Excavator',
    category: MachineCategory.excavators,
    price: 138500,
    status: StockStatus.lowStock,
    imageUrl:
        'https://images.unsplash.com/photo-1581094794329-c8112a89af12?w=400&q=80',
  ),
  MachineModel(
    id: '5',
    name: 'Komatsu WA320-8',
    subtitle: 'Compact Wheel Loader',
    category: MachineCategory.wheelLoaders,
    price: 178000,
    status: StockStatus.inStock,
    imageUrl:
        'https://images.unsplash.com/photo-1563520239648-a1e8d97a1177?w=400&q=80',
  ),
  MachineModel(
    id: '6',
    name: 'CAT D6T',
    subtitle: 'Track-Type Tractor',
    category: MachineCategory.bulldozers,
    price: 312000,
    status: StockStatus.inStock,
    imageUrl:
        'https://images.unsplash.com/photo-1541888946425-d81bb19240f5?w=400&q=80',
  ),

  // ── Recently Added ────────────────────────────────────────────────────────────
  MachineModel(
    id: '8',
    name: 'Volvo A45G',
    subtitle: 'Articulated Hauler',
    category: MachineCategory.dumpTrucks,
    price: 425000,
    status: StockStatus.inStock,
    imageUrl:
        'https://images.unsplash.com/photo-1586864387789-628af9feed72?w=400&q=80',
    isNew: true,
    isRecentlyAdded: true,
  ),
  MachineModel(
    id: '9',
    name: 'Volvo EC480E',
    subtitle: 'Large Crawler Excavator',
    category: MachineCategory.excavators,
    price: 390000,
    status: StockStatus.inStock,
    imageUrl:
        'https://images.unsplash.com/photo-1504307651254-35680f356dfd?w=400&q=80',
    isNew: true,
    isRecentlyAdded: true,
  ),
  MachineModel(
    id: '10',
    name: 'Liebherr LTM 1060',
    subtitle: 'Mobile Crane',
    category: MachineCategory.cranes,
    price: 680000,
    status: StockStatus.inStock,
    imageUrl:
        'https://images.unsplash.com/photo-1513828583688-c52646db42da?w=400&q=80',
    isNew: true,
    isRecentlyAdded: true,
  ),
];
