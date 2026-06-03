/// All plain-Dart value types for the Contact feature.

class OfficeInfo {
  const OfficeInfo({
    required this.companyName,
    required this.addressLines,
    required this.email,
    required this.website,
    required this.mapsQuery,
    required this.imageUrl,
  });

  final String companyName;
  final List<String> addressLines;
  final String email;
  final String website;

  /// URL-encoded query forwarded to Google Maps.
  final String mapsQuery;

  /// Local asset path or network URL for the office photo.
  final String imageUrl;
}

class BusinessHour {
  const BusinessHour({
    required this.label,
    required this.hours,
    required this.isOpen,
  });

  final String label;

  /// e.g. "8:00 AM – 8:00 PM"
  final String hours;

  final bool isOpen;
}

class SocialLink {
  const SocialLink({
    required this.platform,
    required this.handle,
    required this.url,
  });

  final SocialPlatform platform;
  final String handle;
  final String url;
}

enum SocialPlatform {
  facebook,
  messenger,
  instagram,
  linkedin,
  youtube,
  tiktok,
  whatsapp
}

/// ── Static seed data ────────────────────────────────────────────────────────
class ContactData {
  ContactData._();

  static const OfficeInfo office = OfficeInfo(
    companyName: 'AB & ABROZ MACHINERY INC.',
    addressLines: [
      'Jose Abad Santos Avenue,',
      'San Fernando, Pampanga,',
      'Philippines 2000',
    ],
    email: 'info@abrozmachinery.com',
    website: 'www.abrozmachinery.com',
    mapsQuery: 'Jose+Abad+Santos+Avenue+San+Fernando+Pampanga+Philippines',
    imageUrl:
        'https://images.unsplash.com/photo-1581092334651-ddf26d9a09d0?w=600&q=80',
  );

  static const List<BusinessHour> businessHours = [
    BusinessHour(label: 'Mon – Fri', hours: '8:00 AM – 8:00 PM', isOpen: true),
    BusinessHour(label: 'Saturday', hours: '8:00 AM – 8:00 PM', isOpen: true),
    BusinessHour(label: 'Sunday', hours: '8:00 AM – 8:00 PM', isOpen: true),
  ];

  // ── Messenger — Spare Parts page (primary for the app) ───────────────────
  static const String messengerDeepLink =
      'fb-messenger://user-thread/machinerysparepartsph';
  static const String messengerWebUrl = 'https://m.me/machinerysparepartsph';
  static const String messengerFallbackUrl =
      'https://www.facebook.com/machinerysparepartsph';

  /// Legacy alias kept for widgets that still reference [messengerUrl].
  static const String messengerUrl = messengerWebUrl;

  static const String phoneNumber = 'tel:+639175100030';

  static const List<SocialLink> socialLinks = [
    // Main machinery page
    SocialLink(
      platform: SocialPlatform.facebook,
      handle: '@abrozmachinery',
      url: 'https://facebook.com/abrozmachinery',
    ),
    // Spare parts page — Messenger opens this one
    SocialLink(
      platform: SocialPlatform.messenger,
      handle: '@machinerysparepartsph',
      url: messengerWebUrl,
    ),
    SocialLink(
      platform: SocialPlatform.facebook,
      handle: '@machinerysparepartsph',
      url: 'https://www.facebook.com/machinerysparepartsph',
    ),
    // WhatsApp — same number
    SocialLink(
      platform: SocialPlatform.whatsapp,
      handle: '+63 917 510 0030',
      url: 'https://wa.me/639175100030',
    ),
  ];
}
