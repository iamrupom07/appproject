import 'package:url_launcher/url_launcher.dart';
import '../../features/contact/domain/contact_model.dart';

/// Opens Facebook Messenger for the Abroz page.
/// Tries the app deep-link first, then m.me, then the Facebook page.
Future<void> openMessenger({String? message}) async {
  final links = <Uri>[
    _messengerDeepLink(message),
    Uri.parse(ContactData.messengerWebUrl),
    Uri.parse(ContactData.messengerFallbackUrl),
  ];

  for (final link in links) {
    if (await _tryLaunch(link)) {
      return;
    }
  }
}

/// Dials the Abroz business phone number.
Future<void> callAbroz() async {
  final uri = Uri.parse(ContactData.phoneNumber);
  await _tryLaunch(uri);
}

Uri _messengerDeepLink(String? message) {
  final base = ContactData.messengerDeepLink;
  if (message == null || message.trim().isEmpty) {
    return Uri.parse(base);
  }

  return Uri.parse('$base?text=${Uri.encodeComponent(message.trim())}');
}

Future<bool> _tryLaunch(Uri uri) async {
  try {
    return await launchUrl(uri, mode: LaunchMode.externalApplication);
  } catch (_) {
    return false;
  }
}
