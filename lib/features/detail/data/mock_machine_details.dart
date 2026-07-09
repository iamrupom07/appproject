import '../domain/machine_detail_model.dart';

/// Static detail records keyed by [MachineModel.id].
/// Replace with a Dio repository call when the API is ready.
const Map<String, MachineDetailModel> kMockMachineDetails = {
  // ── 1 · Komatsu PC200 Engine Assembly ─────────────────────────────────────
  '1': MachineDetailModel(
    id: '1',
    totalImages: 8,
    has3DView: false,
    galleryUrls: [
      'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800&q=80',
      'https://images.unsplash.com/photo-1504307651254-35680f356dfd?w=800&q=80',
      'https://images.unsplash.com/photo-1581094794329-c8112a89af12?w=800&q=80',
    ],
    specs: [
      MachineSpec(label: 'Part Number', value: 'KOM-SA6D102-001', iconAsset: 'weight'),
      MachineSpec(label: 'Condition', value: 'Used – Good', iconAsset: 'shield'),
      MachineSpec(label: 'Compatible', value: 'PC200-8, PC210LC', iconAsset: 'bucket'),
      MachineSpec(label: 'Category', value: 'Engine Parts', iconAsset: 'power'),
    ],
    techDetails: [
      TechDetail(label: 'Part Number', value: 'KOM-SA6D102-001', iconAsset: 'engine'),
      TechDetail(label: 'Compatibility', value: 'PC200-8, PC210LC-8', iconAsset: 'weight'),
      TechDetail(label: 'Condition', value: 'Used – Good', iconAsset: 'shield'),
      TechDetail(label: 'Category', value: 'Engine Parts', iconAsset: 'bucket'),
      TechDetail(label: 'Origin', value: 'Japan', iconAsset: 'calendar'),
      TechDetail(label: 'Price', value: 'Upon Request', iconAsset: 'clock'),
    ],
    description:
        'Complete engine assembly for Komatsu PC200-8 / PC210LC-8 excavators. '
        'Sourced from decommissioned units in good working condition. '
        'Ideal for operators needing a cost-effective engine replacement.',
    features: '• SA6D102 engine series\n'
        '• Tested before shipping\n'
        '• Compatible with PC200-8 and PC210LC-8\n'
        '• Inspection report available on request\n'
        '• Komatsu OEM quality',
    shippingInfo: 'Available for delivery within the Philippines. '
        'Contact us to arrange pickup or delivery. '
        'Export available upon request.',
  ),

  // ── 2 · Swing Motor Assembly ───────────────────────────────────────────────
  '2': MachineDetailModel(
    id: '2',
    totalImages: 5,
    has3DView: false,
    galleryUrls: [
      'https://images.unsplash.com/photo-1504307651254-35680f356dfd?w=800&q=80',
      'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800&q=80',
    ],
    specs: [
      MachineSpec(label: 'Part Number', value: 'KOM-SWM130-002', iconAsset: 'weight'),
      MachineSpec(label: 'Condition', value: 'Refurbished', iconAsset: 'shield'),
      MachineSpec(label: 'Compatible', value: 'PC130-7, PC200-8', iconAsset: 'bucket'),
      MachineSpec(label: 'Category', value: 'Swing Motor', iconAsset: 'power'),
    ],
    techDetails: [
      TechDetail(label: 'Part Number', value: 'KOM-SWM130-002', iconAsset: 'engine'),
      TechDetail(label: 'Compatibility', value: 'PC130-7, PC200-8', iconAsset: 'weight'),
      TechDetail(label: 'Condition', value: 'Refurbished', iconAsset: 'shield'),
      TechDetail(label: 'Category', value: 'Swing Motor', iconAsset: 'bucket'),
      TechDetail(label: 'Origin', value: 'Japan', iconAsset: 'calendar'),
      TechDetail(label: 'Price', value: 'Upon Request', iconAsset: 'clock'),
    ],
    description:
        'Refurbished swing motor assembly for Komatsu PC130 and PC200 series excavators. '
        'Fully disassembled, cleaned, and rebuilt with new seals and bearings. '
        'Ready for immediate installation.',
    features: '• Full swing motor assembly\n'
        '• Rebuilt with OEM-spec seals\n'
        '• Compatible with PC130-7 and PC200-8\n'
        '• Tested at rated pressure before dispatch\n'
        '• Available with 90-day warranty',
    shippingInfo:
        'Available for nationwide delivery. Heavy freight handled by our logistics partner. '
        'Contact us for a delivery quote.',
  ),

  // ── 3 · Boom Cylinder Seal Kit ─────────────────────────────────────────────
  '3': MachineDetailModel(
    id: '3',
    totalImages: 4,
    has3DView: false,
    galleryUrls: [
      'https://images.unsplash.com/photo-1581094794329-c8112a89af12?w=800&q=80',
      'https://images.unsplash.com/photo-1586864387789-628af9feed72?w=800&q=80',
    ],
    specs: [
      MachineSpec(label: 'Part Number', value: 'KOM-SEAL200-003', iconAsset: 'weight'),
      MachineSpec(label: 'Condition', value: 'New – OEM', iconAsset: 'shield'),
      MachineSpec(label: 'Compatible', value: 'PC200-8, PC210-8', iconAsset: 'bucket'),
      MachineSpec(label: 'Category', value: 'Arm/Boom & Bucket', iconAsset: 'power'),
    ],
    techDetails: [
      TechDetail(label: 'Part Number', value: 'KOM-SEAL200-003', iconAsset: 'engine'),
      TechDetail(label: 'Compatibility', value: 'PC200-8, PC210-8 Series', iconAsset: 'weight'),
      TechDetail(label: 'Condition', value: 'New – OEM', iconAsset: 'shield'),
      TechDetail(label: 'Category', value: 'Arm/Boom & Bucket', iconAsset: 'bucket'),
      TechDetail(label: 'Origin', value: 'Japan', iconAsset: 'calendar'),
      TechDetail(label: 'Price', value: 'Upon Request', iconAsset: 'clock'),
    ],
    description:
        'Genuine OEM boom cylinder seal kit for PC200-8 and PC210-8 excavators. '
        'Includes all seals, O-rings, and backup rings required for a full cylinder rebuild. '
        'Essential for preventing hydraulic leaks and maintaining boom performance.',
    features: '• Full seal kit (dust, piston, rod seals + O-rings)\n'
        '• Genuine Komatsu OEM part\n'
        '• Compatible with PC200-8 and PC210-8\n'
        '• Individually packaged and labeled\n'
        '• Ready to ship — in stock',
    shippingInfo:
        'Lightweight — ships via standard courier nationwide. '
        'Same-day dispatch on orders placed before 2 PM.',
  ),

  // ── 4 · Hydraulic Main Pump ────────────────────────────────────────────────
  '4': MachineDetailModel(
    id: '4',
    totalImages: 7,
    has3DView: false,
    galleryUrls: [
      'https://images.unsplash.com/photo-1590516516091-4aeeba72b8ea?w=800&q=80',
      'https://images.unsplash.com/photo-1504307651254-35680f356dfd?w=800&q=80',
    ],
    specs: [
      MachineSpec(label: 'Part Number', value: 'KOM-HPV132-004', iconAsset: 'weight'),
      MachineSpec(label: 'Condition', value: 'Refurbished', iconAsset: 'shield'),
      MachineSpec(label: 'Compatible', value: 'PC200-8, PC220-8', iconAsset: 'bucket'),
      MachineSpec(label: 'Category', value: 'Hydraulics', iconAsset: 'power'),
    ],
    techDetails: [
      TechDetail(label: 'Part Number', value: 'KOM-HPV132-004', iconAsset: 'engine'),
      TechDetail(label: 'Compatibility', value: 'PC200-8, PC220-8', iconAsset: 'weight'),
      TechDetail(label: 'Condition', value: 'Refurbished', iconAsset: 'shield'),
      TechDetail(label: 'Category', value: 'Hydraulic Pump Spares', iconAsset: 'bucket'),
      TechDetail(label: 'Origin', value: 'Japan', iconAsset: 'calendar'),
      TechDetail(label: 'Price', value: 'Upon Request', iconAsset: 'clock'),
    ],
    description:
        'Refurbished hydraulic main pump for Komatsu PC200-8 and PC220-8 excavators. '
        'Pressure-tested and fully reconditioned for reliable operation.',
    features: '• HPV132 pump series\n'
        '• Pressure-tested before dispatch\n'
        '• Compatible with PC200-8 and PC220-8\n'
        '• Refurbished to OEM specifications\n'
        '• Warranty available on request',
    shippingInfo: 'Available for delivery within the Philippines. '
        'Contact us for pricing and delivery schedule.',
  ),

  // ── 5 · Radiator Assembly ──────────────────────────────────────────────────
  '5': MachineDetailModel(
    id: '5',
    totalImages: 5,
    has3DView: false,
    galleryUrls: [
      'https://images.unsplash.com/photo-1563520239648-a1e8d97a1177?w=800&q=80',
      'https://images.unsplash.com/photo-1541888946425-d81bb19240f5?w=800&q=80',
    ],
    specs: [
      MachineSpec(label: 'Part Number', value: 'KOM-RAD200-005', iconAsset: 'weight'),
      MachineSpec(label: 'Condition', value: 'Used – Good', iconAsset: 'shield'),
      MachineSpec(label: 'Compatible', value: 'PC200-8, PC220-8', iconAsset: 'bucket'),
      MachineSpec(label: 'Category', value: 'Radiator', iconAsset: 'power'),
    ],
    techDetails: [
      TechDetail(label: 'Part Number', value: 'KOM-RAD200-005', iconAsset: 'engine'),
      TechDetail(label: 'Compatibility', value: 'PC200-8, PC220-8 Series', iconAsset: 'weight'),
      TechDetail(label: 'Condition', value: 'Used – Good', iconAsset: 'shield'),
      TechDetail(label: 'Category', value: 'Radiator', iconAsset: 'bucket'),
      TechDetail(label: 'Origin', value: 'Japan', iconAsset: 'calendar'),
      TechDetail(label: 'Price', value: 'Upon Request', iconAsset: 'clock'),
    ],
    description:
        'Complete radiator assembly for Komatsu PC200 and PC220 series excavators. '
        'Flushed, pressure-tested, and free from leaks. '
        'Suitable for machines requiring immediate cooling system replacement.',
    features: '• Full radiator assembly with header tank\n'
        '• Flushed and pressure-tested\n'
        '• Compatible with PC200-8 and PC220-8\n'
        '• No leaks detected — certified by our team\n'
        '• Core in excellent condition',
    shippingInfo:
        'Requires specialist freight due to size. '
        'We coordinate delivery with your site logistics. Contact us to arrange.',
  ),

  // ── 6 · Control Valve Assembly ────────────────────────────────────────────
  '6': MachineDetailModel(
    id: '6',
    totalImages: 4,
    has3DView: false,
    galleryUrls: [
      'https://images.unsplash.com/photo-1541888946425-d81bb19240f5?w=800&q=80',
      'https://images.unsplash.com/photo-1590516516091-4aeeba72b8ea?w=800&q=80',
    ],
    specs: [
      MachineSpec(label: 'Part Number', value: 'KOM-CV200-006', iconAsset: 'weight'),
      MachineSpec(label: 'Condition', value: 'Refurbished', iconAsset: 'shield'),
      MachineSpec(label: 'Compatible', value: 'PC200-8', iconAsset: 'bucket'),
      MachineSpec(label: 'Category', value: 'Control Valve / Main Pump', iconAsset: 'power'),
    ],
    techDetails: [
      TechDetail(label: 'Part Number', value: 'KOM-CV200-006', iconAsset: 'engine'),
      TechDetail(label: 'Compatibility', value: 'PC200-8', iconAsset: 'weight'),
      TechDetail(label: 'Condition', value: 'Refurbished', iconAsset: 'shield'),
      TechDetail(label: 'Category', value: 'Control Valve / Main Pump', iconAsset: 'bucket'),
      TechDetail(label: 'Origin', value: 'Japan', iconAsset: 'calendar'),
      TechDetail(label: 'Price', value: 'Upon Request', iconAsset: 'clock'),
    ],
    description:
        'Main control valve assembly for Komatsu PC200-8 excavators. '
        'Completely disassembled, cleaned, and rebuilt with new seals. '
        'Controls all primary hydraulic functions — boom, arm, bucket, swing, and travel.',
    features: '• Full main control valve assembly\n'
        '• All spool seals replaced\n'
        '• Bench-tested for correct operation\n'
        '• Compatible with PC200-8\n'
        '• Available to order — currently out of stock',
    shippingInfo:
        'Out-of-stock items ship within 7–14 business days of order confirmation. '
        'Contact us to reserve your unit.',
  ),

  // ── 7 · Track Chain Assembly ──────────────────────────────────────────────
  '7': MachineDetailModel(
    id: '7',
    totalImages: 6,
    has3DView: false,
    galleryUrls: [
      'https://images.unsplash.com/photo-1580674285054-bed31e145f59?w=800&q=80',
      'https://images.unsplash.com/photo-1563520239648-a1e8d97a1177?w=800&q=80',
    ],
    specs: [
      MachineSpec(label: 'Part Number', value: 'KOM-TRK200-007', iconAsset: 'weight'),
      MachineSpec(label: 'Condition', value: 'Used – Good', iconAsset: 'shield'),
      MachineSpec(label: 'Compatible', value: 'PC200, PC200LC', iconAsset: 'bucket'),
      MachineSpec(label: 'Category', value: 'Undercarriage', iconAsset: 'power'),
    ],
    techDetails: [
      TechDetail(label: 'Part Number', value: 'KOM-TRK200-007', iconAsset: 'engine'),
      TechDetail(label: 'Compatibility', value: 'PC200, PC200LC Series', iconAsset: 'weight'),
      TechDetail(label: 'Condition', value: 'Used – Good', iconAsset: 'shield'),
      TechDetail(label: 'Category', value: 'Undercarriage', iconAsset: 'bucket'),
      TechDetail(label: 'Origin', value: 'Japan', iconAsset: 'calendar'),
      TechDetail(label: 'Price', value: 'Upon Request', iconAsset: 'clock'),
    ],
    description:
        'Track chain assembly for Komatsu PC200 and PC200LC series excavators. '
        'Sourced from low-hour decommissioned units. Suitable for immediate installation.',
    features: '• Full track chain set\n'
        '• Compatible with PC200 and PC200LC\n'
        '• Inspected for wear and damage\n'
        '• Priced competitively\n'
        '• Fast local delivery available',
    shippingInfo: 'Available for delivery across the Philippines. '
        'Contact us to confirm availability and schedule.',
  ),

  // ── 8 · Bucket Tooth & Adapter Set ───────────────────────────────────────
  '8': MachineDetailModel(
    id: '8',
    totalImages: 4,
    has3DView: false,
    galleryUrls: [
      'https://images.unsplash.com/photo-1586864387789-628af9feed72?w=800&q=80',
      'https://images.unsplash.com/photo-1580674285054-bed31e145f59?w=800&q=80',
    ],
    specs: [
      MachineSpec(label: 'Part Number', value: 'KOM-GET200-008', iconAsset: 'weight'),
      MachineSpec(label: 'Condition', value: 'New – OEM', iconAsset: 'shield'),
      MachineSpec(label: 'Compatible', value: 'PC200 Standard Bucket', iconAsset: 'bucket'),
      MachineSpec(label: 'Category', value: 'Ground Engaging Tools', iconAsset: 'power'),
    ],
    techDetails: [
      TechDetail(label: 'Part Number', value: 'KOM-GET200-008', iconAsset: 'engine'),
      TechDetail(label: 'Compatibility', value: 'PC200 Standard 0.8m³ Bucket', iconAsset: 'weight'),
      TechDetail(label: 'Condition', value: 'New – OEM', iconAsset: 'shield'),
      TechDetail(label: 'Category', value: 'Ground Engaging Tools', iconAsset: 'bucket'),
      TechDetail(label: 'Origin', value: 'Japan', iconAsset: 'calendar'),
      TechDetail(label: 'Price', value: 'Upon Request', iconAsset: 'clock'),
    ],
    description:
        'Full set of bucket teeth and adapters for the Komatsu PC200 standard bucket. '
        'Genuine OEM components for maximum digging efficiency and service life. '
        'Includes retainer pins and clips.',
    features: '• 5× bucket teeth (standard rock type)\n'
        '• 5× adapter bases\n'
        '• Retainer pins and C-clips included\n'
        '• Genuine Komatsu OEM\n'
        '• In stock — same-day dispatch available',
    shippingInfo:
        'Ships via standard courier. Typically delivered within 2–3 business days.',
  ),

  // ── 9 · Cabin Wiring Harness ──────────────────────────────────────────────
  '9': MachineDetailModel(
    id: '9',
    totalImages: 4,
    has3DView: false,
    galleryUrls: [
      'https://images.unsplash.com/photo-1504307651254-35680f356dfd?w=800&q=80',
      'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800&q=80',
    ],
    specs: [
      MachineSpec(label: 'Part Number', value: 'KOM-WH200-009', iconAsset: 'weight'),
      MachineSpec(label: 'Condition', value: 'Used – Good', iconAsset: 'shield'),
      MachineSpec(label: 'Compatible', value: 'PC200-8, PC210-8', iconAsset: 'bucket'),
      MachineSpec(label: 'Category', value: 'Cabin & Electrical', iconAsset: 'power'),
    ],
    techDetails: [
      TechDetail(label: 'Part Number', value: 'KOM-WH200-009', iconAsset: 'engine'),
      TechDetail(label: 'Compatibility', value: 'PC200-8, PC210-8 Series', iconAsset: 'weight'),
      TechDetail(label: 'Condition', value: 'Used – Good', iconAsset: 'shield'),
      TechDetail(label: 'Category', value: 'Cabin & Electrical Spares', iconAsset: 'bucket'),
      TechDetail(label: 'Origin', value: 'Japan', iconAsset: 'calendar'),
      TechDetail(label: 'Price', value: 'Upon Request', iconAsset: 'clock'),
    ],
    description:
        'Main cabin wiring harness for Komatsu PC200-8 and PC210-8 excavators. '
        'Complete loom removed from a low-hour decommissioned unit. '
        'All connectors intact and functional — tested prior to listing.',
    features: '• Full cabin wiring loom\n'
        '• All connectors undamaged\n'
        '• Compatible with PC200-8 and PC210-8\n'
        '• Continuity-tested\n'
        '• Ideal replacement for short-circuit or damaged harnesses',
    shippingInfo:
        'Ships rolled and protected in a rigid tube. Nationwide delivery available.',
  ),

  // ── 10 · Turn Table Bearing ───────────────────────────────────────────────
  '10': MachineDetailModel(
    id: '10',
    totalImages: 5,
    has3DView: false,
    galleryUrls: [
      'https://images.unsplash.com/photo-1513828583688-c52646db42da?w=800&q=80',
      'https://images.unsplash.com/photo-1580674285054-bed31e145f59?w=800&q=80',
    ],
    specs: [
      MachineSpec(label: 'Part Number', value: 'KOM-TTB200-010', iconAsset: 'weight'),
      MachineSpec(label: 'Condition', value: 'Used – Good', iconAsset: 'shield'),
      MachineSpec(label: 'Compatible', value: 'PC200-8, PC200LC-8', iconAsset: 'bucket'),
      MachineSpec(label: 'Category', value: 'Turn Table', iconAsset: 'power'),
    ],
    techDetails: [
      TechDetail(label: 'Part Number', value: 'KOM-TTB200-010', iconAsset: 'engine'),
      TechDetail(label: 'Compatibility', value: 'PC200-8, PC200LC-8', iconAsset: 'weight'),
      TechDetail(label: 'Condition', value: 'Used – Good', iconAsset: 'shield'),
      TechDetail(label: 'Category', value: 'Turn Table / Swing Circle', iconAsset: 'bucket'),
      TechDetail(label: 'Origin', value: 'Japan', iconAsset: 'calendar'),
      TechDetail(label: 'Price', value: 'Upon Request', iconAsset: 'clock'),
    ],
    description:
        'Turn table bearing (swing circle) for Komatsu PC200-8 and PC200LC-8 excavators. '
        'Removed from a low-hour machine. Teeth and races in excellent condition. '
        'A cost-effective alternative to new OEM pricing.',
    features: '• Full swing circle bearing assembly\n'
        '• Inner and outer race intact\n'
        '• Teeth checked for wear — within spec\n'
        '• Compatible with PC200-8 and PC200LC-8\n'
        '• Installation guide available on request',
    shippingInfo:
        'Heavy item — freight delivery only. We coordinate with your preferred carrier. '
        'Contact us for a freight quote.',
  ),
};

/// Returns a generic fallback [MachineDetailModel] for any id not found in
/// [kMockMachineDetails]. This prevents a null-dereference when an unknown
/// id is navigated to during development.
MachineDetailModel fallbackDetail(String id) => MachineDetailModel(
      id: id,
      totalImages: 1,
      has3DView: false,
      galleryUrls: [
        'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800&q=80',
      ],
      specs: [
        const MachineSpec(label: 'Part Number', value: 'N/A', iconAsset: 'weight'),
        const MachineSpec(label: 'Condition', value: 'Unknown', iconAsset: 'shield'),
        const MachineSpec(label: 'Compatible', value: 'N/A', iconAsset: 'bucket'),
        const MachineSpec(label: 'Category', value: 'General', iconAsset: 'power'),
      ],
      techDetails: [
        const TechDetail(label: 'Part Number', value: 'N/A', iconAsset: 'engine'),
        const TechDetail(label: 'Compatibility', value: 'N/A', iconAsset: 'weight'),
        const TechDetail(label: 'Condition', value: 'Unknown', iconAsset: 'shield'),
        const TechDetail(label: 'Category', value: 'General', iconAsset: 'bucket'),
        const TechDetail(label: 'Origin', value: 'N/A', iconAsset: 'calendar'),
        const TechDetail(label: 'Price', value: 'Upon Request', iconAsset: 'clock'),
      ],
      description: 'No details available for this item.',
      features: '• Details coming soon',
      shippingInfo: 'Contact us for shipping information.',
    );
