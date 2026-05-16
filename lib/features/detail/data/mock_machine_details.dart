import '../domain/machine_detail_model.dart';

/// Static detail records keyed by [MachineModel.id].
/// Replace with a Dio repository call when the API is ready.
const Map<String, MachineDetailModel> kMockMachineDetails = {
  // ── Komatsu PC200 Engine Assembly ─────────────────────────────────────────
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
      MachineSpec(
          label: 'Part Number', value: 'KOM-SA6D102-001', iconAsset: 'weight'),
      MachineSpec(
          label: 'Condition', value: 'Used – Good', iconAsset: 'shield'),
      MachineSpec(
          label: 'Compatible', value: 'PC200-8, PC210LC', iconAsset: 'bucket'),
      MachineSpec(label: 'Category', value: 'Engine Parts', iconAsset: 'power'),
    ],
    techDetails: [
      TechDetail(
          label: 'Part Number', value: 'KOM-SA6D102-001', iconAsset: 'engine'),
      TechDetail(
          label: 'Compatibility',
          value: 'PC200-8, PC210LC-8',
          iconAsset: 'weight'),
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
    conditionNotes:
        'Used in good condition. Inspected by our technicians prior to listing. '
        'Full history available upon inquiry.',
  ),

  // ── Hydraulic Main Pump ───────────────────────────────────────────────────
  '4': MachineDetailModel(
    id: '4',
    totalImages: 7,
    has3DView: false,
    galleryUrls: [
      'https://images.unsplash.com/photo-1590516516091-4aeeba72b8ea?w=800&q=80',
      'https://images.unsplash.com/photo-1504307651254-35680f356dfd?w=800&q=80',
    ],
    specs: [
      MachineSpec(
          label: 'Part Number', value: 'KOM-HPV132-004', iconAsset: 'weight'),
      MachineSpec(
          label: 'Condition', value: 'Refurbished', iconAsset: 'shield'),
      MachineSpec(
          label: 'Compatible', value: 'PC200-8, PC220-8', iconAsset: 'bucket'),
      MachineSpec(label: 'Category', value: 'Hydraulics', iconAsset: 'power'),
    ],
    techDetails: [
      TechDetail(
          label: 'Part Number', value: 'KOM-HPV132-004', iconAsset: 'engine'),
      TechDetail(
          label: 'Compatibility',
          value: 'PC200-8, PC220-8',
          iconAsset: 'weight'),
      TechDetail(label: 'Condition', value: 'Refurbished', iconAsset: 'shield'),
      TechDetail(
          label: 'Category',
          value: 'Hydraulic Pump Spares',
          iconAsset: 'bucket'),
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
    conditionNotes:
        'Refurbished unit. Fully pressure-tested. Ready to install.',
  ),

  // ── Track Chain Assembly ──────────────────────────────────────────────────
  '7': MachineDetailModel(
    id: '7',
    totalImages: 6,
    has3DView: false,
    galleryUrls: [
      'https://images.unsplash.com/photo-1580674285054-bed31e145f59?w=800&q=80',
      'https://images.unsplash.com/photo-1563520239648-a1e8d97a1177?w=800&q=80',
    ],
    specs: [
      MachineSpec(
          label: 'Part Number', value: 'KOM-TRK200-007', iconAsset: 'weight'),
      MachineSpec(
          label: 'Condition', value: 'Used – Good', iconAsset: 'shield'),
      MachineSpec(
          label: 'Compatible', value: 'PC200, PC200LC', iconAsset: 'bucket'),
      MachineSpec(
          label: 'Category', value: 'Undercarriage', iconAsset: 'power'),
    ],
    techDetails: [
      TechDetail(
          label: 'Part Number', value: 'KOM-TRK200-007', iconAsset: 'engine'),
      TechDetail(
          label: 'Compatibility',
          value: 'PC200, PC200LC Series',
          iconAsset: 'weight'),
      TechDetail(label: 'Condition', value: 'Used – Good', iconAsset: 'shield'),
      TechDetail(
          label: 'Category', value: 'Undercarriage', iconAsset: 'bucket'),
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
    conditionNotes:
        'Used in good condition. Wear within acceptable limits. Inspection report available.',
  ),
};
