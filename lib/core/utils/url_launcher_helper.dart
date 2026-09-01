import 'package:url_launcher/url_launcher.dart';

class UrlLauncherHelper {
  static Future<bool> openWhatsApp({
    required String phoneNumber,
    required String message,
  }) async {
    // Sanitize phone number
    final cleanPhone = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    final formattedPhone = cleanPhone.startsWith('+') ? cleanPhone : '+91$cleanPhone';
    
    final uri = Uri.parse(
      'https://wa.me/${formattedPhone.replaceAll('+', '')}?text=${Uri.encodeComponent(message)}',
    );

    if (await canLaunchUrl(uri)) {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      return false;
    }
  }

  static Future<bool> makePhoneCall(String phoneNumber) async {
    final cleanPhone = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    final uri = Uri.parse('tel:$cleanPhone');

    if (await canLaunchUrl(uri)) {
      return await launchUrl(uri);
    } else {
      return false;
    }
  }
}
