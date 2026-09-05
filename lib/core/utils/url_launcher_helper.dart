import 'package:url_launcher/url_launcher.dart';

class UrlLauncherHelper {
  static Future<bool> openWhatsApp({
    required String phoneNumber,
    required String message,
  }) async {
    // Sanitize phone number
    final cleanPhone = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    final formattedPhone = cleanPhone.startsWith('+') ? cleanPhone : '+91$cleanPhone';
    final numberOnly = formattedPhone.replaceAll('+', '');

    final uri = Uri.parse(
      'https://wa.me/$numberOnly?text=${Uri.encodeComponent(message)}',
    );

    try {
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (launched) return true;
    } catch (_) {}

    try {
      final fallbackUri = Uri.parse(
        'https://api.whatsapp.com/send?phone=$numberOnly&text=${Uri.encodeComponent(message)}',
      );
      return await launchUrl(fallbackUri, mode: LaunchMode.externalApplication);
    } catch (_) {
      return false;
    }
  }

  static Future<bool> makePhoneCall(String phoneNumber) async {
    final cleanPhone = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
    final uri = Uri.parse('tel:$cleanPhone');

    try {
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri);
      }
      return await launchUrl(uri, mode: LaunchMode.externalNonBrowserApplication);
    } catch (_) {
      return false;
    }
  }
}
