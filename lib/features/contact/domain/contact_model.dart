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
    companyName: 'Abroz Machinery Inc.',
    addressLines: [
      '123 Industrial Blvd,',
      'Korangi, Karachi 74900,',
      'Pakistan'
    ],
    email: 'info@abrozmachinery.com',
    website: 'www.abrozmachinery.com',
    mapsQuery: 'Abroz+Machinery+Korangi+Karachi',
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
      platform: SocialPlatform.instagram,
      handle: '@abrozmachinery',
      url: 'https://instagram.com/abrozmachinery',
    ),
    SocialLink(
      platform: SocialPlatform.linkedin,
      handle: '/abrozmachinery',
      url: 'https://linkedin.com/company/abrozmachinery',
    ),
    SocialLink(
      platform: SocialPlatform.youtube,
      handle: '@abrozmachinery',
      url: 'https://youtube.com/@abrozmachinery',
    ),
    SocialLink(
      platform: SocialPlatform.tiktok,
      handle: '@abrozmachinery',
      url: 'https://tiktok.com/@abrozmachinery',
    ),
    SocialLink(
      platform: SocialPlatform.whatsapp,
      handle: '+92 300 1234567',
      url: 'https://wa.me/923001234567',
    ),
  ];

  static const String messengerUrl = 'https://m.me/abrozmachinery';
  static const String phoneNumber = 'tel:+923001234567';
}
