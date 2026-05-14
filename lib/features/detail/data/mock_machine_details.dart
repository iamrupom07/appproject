import '../domain/machine_detail_model.dart';

/// Static detail records keyed by [MachineModel.id].
/// Replace with a Dio repository call when the API is ready.
const Map<String, MachineDetailModel> kMockMachineDetails = {
  // ── Komatsu PC 210 LC-11 ───────────────────────────────────────────────────
  '1': MachineDetailModel(
    id: '1',
    totalImages: 8,
    has3DView: true,
    galleryUrls: [
      'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800&q=80',
      'https://images.unsplash.com/photo-1504307651254-35680f356dfd?w=800&q=80',
      'https://images.unsplash.com/photo-1581094794329-c8112a89af12?w=800&q=80',
      'https://images.unsplash.com/photo-1590516516091-4aeeba72b8ea?w=800&q=80',
      'https://images.unsplash.com/photo-1563520239648-a1e8d97a1177?w=800&q=80',
    ],
    specs: [
      MachineSpec(
          label: 'Operating Weight', value: '22,200 kg', iconAsset: 'weight'),
      MachineSpec(label: 'Engine Power', value: '162 HP', iconAsset: 'power'),
      MachineSpec(
          label: 'Bucket Capacity', value: '1.0 m³', iconAsset: 'bucket'),
      MachineSpec(label: 'Dig Depth', value: '6.2 m', iconAsset: 'depth'),
    ],
    techDetails: [
      TechDetail(
          label: 'Engine Model',
          value: 'Komatsu SAA6D107E-3',
          iconAsset: 'engine'),
      TechDetail(
          label: 'Working Hours', value: '1,250 hrs', iconAsset: 'clock'),
      TechDetail(
          label: 'Operating Weight', value: '22,200 kg', iconAsset: 'weight'),
      TechDetail(label: 'Year Model', value: '2022', iconAsset: 'calendar'),
      TechDetail(
          label: 'Bucket Capacity', value: '1.0 m³', iconAsset: 'bucket'),
      TechDetail(label: 'Condition', value: 'Excellent', iconAsset: 'shield'),
    ],
    description:
        'The Komatsu PC210LC-11 delivers exceptional performance, fuel efficiency, '
        'and operator comfort. Built for durability and productivity on any job site. '
        'Ideal for construction, excavation, and heavy-duty applications.',
    features: '• KOMTRAX remote monitoring system\n'
        '• Eco-mode for up to 10% fuel savings\n'
        '• Large cab with air suspension seat\n'
        '• Auto-idle shutdown system\n'
        '• LED working lights (front & rear)',
    shippingInfo:
        'Available for worldwide shipping via flat-bed or roll-on/roll-off container. '
        'Delivery typically within 2–4 weeks depending on destination. '
        'Export documentation and customs clearance support available.',
    conditionNotes:
        'Excellent condition. Recently serviced with new filters and fluid change. '
        'No visible cracks or structural damage. '
        'Full inspection report available on request.',
  ),

  // ── CAT 950 GC ────────────────────────────────────────────────────────────
  '4': MachineDetailModel(
    id: '4',
    totalImages: 6,
    has3DView: false,
    galleryUrls: [
      'https://images.unsplash.com/photo-1590516516091-4aeeba72b8ea?w=800&q=80',
      'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800&q=80',
      'https://images.unsplash.com/photo-1504307651254-35680f356dfd?w=800&q=80',
      'https://images.unsplash.com/photo-1580674285054-bed31e145f59?w=800&q=80',
    ],
    specs: [
      MachineSpec(
          label: 'Operating Weight', value: '17,300 kg', iconAsset: 'weight'),
      MachineSpec(label: 'Engine Power', value: '185 HP', iconAsset: 'power'),
      MachineSpec(
          label: 'Bucket Capacity', value: '2.7 m³', iconAsset: 'bucket'),
      MachineSpec(label: 'Lift Height', value: '4.8 m', iconAsset: 'depth'),
    ],
    techDetails: [
      TechDetail(
          label: 'Engine Model', value: 'Cat C7.1 ACERT', iconAsset: 'engine'),
      TechDetail(label: 'Working Hours', value: '980 hrs', iconAsset: 'clock'),
      TechDetail(
          label: 'Operating Weight', value: '17,300 kg', iconAsset: 'weight'),
      TechDetail(label: 'Year Model', value: '2023', iconAsset: 'calendar'),
      TechDetail(
          label: 'Bucket Capacity', value: '2.7 m³', iconAsset: 'bucket'),
      TechDetail(label: 'Condition', value: 'Excellent', iconAsset: 'shield'),
    ],
    description:
        'The Cat 950 GC Wheel Loader is designed for high-production loading applications. '
        'Optimized for efficiency with a simplified powertrain and reliable performance '
        'across diverse job site conditions.',
    features: '• Cat Product Link™ remote monitoring\n'
        '• Ride control for smooth travel\n'
        '• Automatic bucket positioning\n'
        '• Rimpull control system\n'
        '• ROPS/FOPS certified cab',
    shippingInfo:
        'Ready for immediate dispatch. Shipping available to all major ports. '
        'Standard delivery: 3–5 weeks. Express available on request.',
    conditionNotes: 'Excellent condition with low hours. '
        'All tyres at 90% tread. No hydraulic leaks. Fully operational.',
  ),

  // ── Komatsu D65PX-18 ──────────────────────────────────────────────────────
  '7': MachineDetailModel(
    id: '7',
    totalImages: 5,
    has3DView: false,
    galleryUrls: [
      'https://images.unsplash.com/photo-1580674285054-bed31e145f59?w=800&q=80',
      'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800&q=80',
      'https://images.unsplash.com/photo-1590516516091-4aeeba72b8ea?w=800&q=80',
    ],
    specs: [
      MachineSpec(
          label: 'Operating Weight', value: '19,670 kg', iconAsset: 'weight'),
      MachineSpec(label: 'Engine Power', value: '168 HP', iconAsset: 'power'),
      MachineSpec(label: 'Blade Width', value: '3.2 m', iconAsset: 'bucket'),
      MachineSpec(label: 'Track Width', value: '915 mm', iconAsset: 'depth'),
    ],
    techDetails: [
      TechDetail(
          label: 'Engine Model',
          value: 'Komatsu SAA6D107E-2',
          iconAsset: 'engine'),
      TechDetail(
          label: 'Working Hours', value: '3,400 hrs', iconAsset: 'clock'),
      TechDetail(
          label: 'Operating Weight', value: '19,670 kg', iconAsset: 'weight'),
      TechDetail(label: 'Year Model', value: '2021', iconAsset: 'calendar'),
      TechDetail(label: 'Blade Width', value: '3.2 m', iconAsset: 'bucket'),
      TechDetail(label: 'Condition', value: 'Good', iconAsset: 'shield'),
    ],
    description:
        'The Komatsu D65PX-18 wide-gauge bulldozer excels on soft and uneven terrain. '
        'Palm-Command Control System (PCCS) provides precise, low-fatigue operation. '
        'Suitable for land clearing, grading, and reclamation projects.',
    features: '• PCCS joystick steering\n'
        '• Auto-shift transmission\n'
        '• Variable track shoe width\n'
        '• KOMTRAX GPS tracking\n'
        '• Rear-view camera',
    shippingInfo: 'Low-stock — contact us to confirm availability. '
        'Shipping with certified heavy equipment carriers worldwide.',
    conditionNotes: 'Good condition with moderate hours. '
        'Undercarriage at 65%. Blade edge recently replaced. '
        'Full service history available.',
  ),
};

/// Fallback detail for any machine ID not explicitly listed above.
MachineDetailModel fallbackDetail(String id) => MachineDetailModel(
      id: id,
      totalImages: 4,
      has3DView: false,
      galleryUrls: const [
        'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800&q=80',
        'https://images.unsplash.com/photo-1504307651254-35680f356dfd?w=800&q=80',
        'https://images.unsplash.com/photo-1590516516091-4aeeba72b8ea?w=800&q=80',
      ],
      specs: const [
        MachineSpec(
            label: 'Operating Weight', value: 'N/A', iconAsset: 'weight'),
        MachineSpec(label: 'Engine Power', value: 'N/A', iconAsset: 'power'),
        MachineSpec(
            label: 'Bucket Capacity', value: 'N/A', iconAsset: 'bucket'),
        MachineSpec(label: 'Dig Depth', value: 'N/A', iconAsset: 'depth'),
      ],
      techDetails: const [
        TechDetail(label: 'Engine Model', value: 'N/A', iconAsset: 'engine'),
        TechDetail(label: 'Working Hours', value: 'N/A', iconAsset: 'clock'),
        TechDetail(
            label: 'Operating Weight', value: 'N/A', iconAsset: 'weight'),
        TechDetail(label: 'Year Model', value: 'N/A', iconAsset: 'calendar'),
        TechDetail(label: 'Bucket Capacity', value: 'N/A', iconAsset: 'bucket'),
        TechDetail(label: 'Condition', value: 'N/A', iconAsset: 'shield'),
      ],
      description: 'Contact us for full specifications and availability.',
      features: 'Contact us for feature list.',
      shippingInfo: 'Contact us for shipping options.',
      conditionNotes: 'Inspection available on request.',
    );
