/// All plain-Dart value types for the Contact feature.
/// Swap the static [ContactData.instance] for a real API call whenever ready.

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

  /// e.g. "8:00 AM – 6:00 PM" or "Closed"
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

enum SocialPlatform { facebook, instagram, linkedin, youtube, tiktok, whatsapp }

/// ── Static seed data ────────────────────────────────────────────────────────
/// Replace with a repository / provider fetch when a backend exists.
class ContactData {
  ContactData._();

  static const OfficeInfo office = OfficeInfo(
    companyName: 'AB & KBROZ MACHINERY INC.',
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
    BusinessHour(label: 'Mon – Fri', hours: '8:00 AM – 6:00 PM', isOpen: true),
    BusinessHour(label: 'Saturday', hours: '8:00 AM – 2:00 PM', isOpen: true),
    BusinessHour(label: 'Sunday', hours: 'Closed', isOpen: false),
  ];

  static const List<SocialLink> socialLinks = [
    SocialLink(
      platform: SocialPlatform.facebook,
      handle: '@abrozmachinery',
      url: 'https://facebook.com/abrozmachinery',
    ),
    SocialLink(
      platform: SocialPlatform.facebook,
      handle: '@machinerysparepartsph',
      url: 'https://www.facebook.com/machinerysparepartsph',
    ),
    SocialLink(
      platform: SocialPlatform.whatsapp,
      handle: '+63 917 510 0030',
      url: 'https://wa.me/639175100030',
    ),
  ];

  static const String messengerUrl = 'https://m.me/abrozmachinery';
  static const String phoneNumber = 'tel:+639175100030';
}
