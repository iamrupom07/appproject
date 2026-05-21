import 'package:url_launcher/url_launcher.dart';
import '../../features/contact/domain/contact_model.dart';

/// Opens Facebook Messenger for the Abroz page.
/// Tries the deep-link first; falls back to the browser URL.
Future<void> openMessenger() async {
  final deepLink = Uri.parse(ContactData.messengerDeepLink);
  if (await canLaunchUrl(deepLink)) {
    await launchUrl(deepLink, mode: LaunchMode.externalApplication);
    return;
  }
  final fallback = Uri.parse(ContactData.messengerFallbackUrl);
  if (await canLaunchUrl(fallback)) {
    await launchUrl(fallback, mode: LaunchMode.externalApplication);
  }
}

/// Dials the Abroz business phone number.
Future<void> callAbroz() async {
  final uri = Uri.parse(ContactData.phoneNumber);
  if (await canLaunchUrl(uri)) await launchUrl(uri);
}
