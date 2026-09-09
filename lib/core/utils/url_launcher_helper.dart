import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlLauncherHelper {
  static const String playStorePackageId = 'com.krushimithra.krushi_mithra';

  /// Generates a direct Play Store link targeting the Krushi Mithra App
  static String buildPlayStoreAppLink({
    required String itemType,
    required String itemId,
  }) {
    return 'https://play.google.com/store/apps/details?id=$playStorePackageId&referrer=itemType%3D$itemType%26itemId%3D$itemId';
  }

  /// Builds a structured WhatsApp message with "Tips for a safe deal", Play Store app link, and inquiry body
  static String buildStructuredWhatsAppMessage({
    required String category, // e.g. "Produce Listing", "Farm Worker Profile", "Machinery Rental"
    required String recipientName,
    required String itemTitle,
    required String itemId,
    required String itemType, // "marketplace", "workers", "machines"
    String? customMessage,
  }) {
    final cleanCategory = category.replaceAll(RegExp(r'\s+'), ' ').trim();
    final cleanTitle = itemTitle.replaceAll(RegExp(r'\s+'), ' ').trim();
    final cleanName = recipientName.replaceAll(RegExp(r'\s+'), ' ').trim();

    final body = customMessage ?? "I'm interested in your $cleanTitle posted on Krushi Mithra.";
    final playStoreLink = buildPlayStoreAppLink(itemType: itemType, itemId: itemId);

    return '''*Tips for a safe deal*

1. Never give money or product in advance.
2. Do not scan any QR code or send even ₹1 to anyone.
3. Never share your OTP or UPI PIN.
4. Be safe, take necessary precautions while meeting with buyers and sellers.
5. Krushi Mithra team is not responsible for any fraudulent activities.

Your $cleanCategory: $playStoreLink

Hi $cleanName,

$body

Is it available?''';
  }

  /// Displays an interactive WhatsApp preview & editor bottom sheet matching the Admin Panel design
  static Future<void> showWhatsAppConfirmationBottomSheet({
    required BuildContext context,
    required String phoneNumber,
    required String recipientName,
    required String category,
    required String itemTitle,
    required String itemId,
    required String itemType,
    String? customMessage,
  }) async {
    final defaultMessage = buildStructuredWhatsAppMessage(
      category: category,
      recipientName: recipientName,
      itemTitle: itemTitle,
      itemId: itemId,
      itemType: itemType,
      customMessage: customMessage,
    );

    final phoneController = TextEditingController(text: phoneNumber);
    final messageController = TextEditingController(text: defaultMessage);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.chat_bubble, color: Color(0xFF25D366), size: 24),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Send WhatsApp Message to $recipientName',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Recipient Phone Number:',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF374151)),
              ),
              const SizedBox(height: 4),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  isDense: true,
                ),
                style: const TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 12),
              const Text(
                'Pattern-Matched Structured Message (Editable):',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF374151)),
              ),
              const SizedBox(height: 4),
              TextField(
                controller: messageController,
                maxLines: 7,
                decoration: InputDecoration(
                  fillColor: const Color(0xFFF9FBF8),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFFC8E6C9)),
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.shield_outlined, color: Color(0xFF25D366), size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'This WhatsApp message is formatted according to the safety deal guidelines and link pattern. You can edit the text before sending.',
                        style: TextStyle(fontSize: 11, color: Color(0xFF2E7D32)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.chat_bubble, color: Colors.white, size: 18),
                      label: const Text('Launch WhatsApp Chat', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF25D366),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        Navigator.pop(ctx);
                        openWhatsApp(
                          phoneNumber: phoneController.text,
                          message: messageController.text,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

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
