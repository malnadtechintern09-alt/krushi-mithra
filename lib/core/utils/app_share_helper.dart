import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../app/theme/app_colors.dart';

class AppShareHelper {
  static const String playStorePackageId = 'com.krushimithra.app';
  static const String appDownloadUrl = 'https://play.google.com/store/apps/details?id=$playStorePackageId';

  static const String defaultAppShareText = '''*🌾 KRUSHI MITHRA 🌾*
*Digital Farming Marketplace & Agricultural Services Platform*

Namaste Farmers & Service Providers!

Download Krushi Mithra App from Play Store to:
✅ Buy & Sell Arecanut, Pepper, Paddy & Farm Crops
✅ Hire Tractor Drivers, Harvesters & Farm Labours
✅ Rent Tractors, Tillers & Agricultural Machinery
✅ Buy Fertilizer, Seeds & Agro Store Products

📲 *Download from Google Play Store:*
$appDownloadUrl''';

  /// Launches Google Play Store directly
  static Future<bool> launchPlayStore() async {
    final playStoreUri = Uri.parse(appDownloadUrl);
    try {
      final launched = await launchUrl(playStoreUri, mode: LaunchMode.externalApplication);
      if (launched) return true;
    } catch (_) {}

    final marketUri = Uri.parse('market://details?id=$playStorePackageId');
    try {
      return await launchUrl(marketUri, mode: LaunchMode.externalApplication);
    } catch (_) {
      return false;
    }
  }

  /// Shares app invitation via WhatsApp
  static Future<bool> shareAppViaWhatsApp({String? customMessage}) async {
    final message = customMessage ?? defaultAppShareText;
    final uri = Uri.parse('https://wa.me/?text=${Uri.encodeComponent(message)}');
    try {
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (launched) return true;
    } catch (_) {}

    try {
      final fallbackUri = Uri.parse('https://api.whatsapp.com/send?text=${Uri.encodeComponent(message)}');
      return await launchUrl(fallbackUri, mode: LaunchMode.externalApplication);
    } catch (_) {
      return false;
    }
  }

  /// Copies the Google Play Store Download link to clipboard
  static Future<void> copyDownloadLink(BuildContext context) async {
    await Clipboard.setData(const ClipboardData(text: appDownloadUrl));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
              SizedBox(width: 10),
              Text('Google Play Store Download link copied to clipboard!'),
            ],
          ),
          backgroundColor: AppColors.primaryGreen,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  /// Displays an interactive App Sharing bottom sheet
  static void showShareAppBottomSheet(BuildContext context) {
    final textController = TextEditingController(text: defaultAppShareText);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: AppColors.chipBackground,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.share_rounded, color: AppColors.primaryGreen, size: 22),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Share Krushi Mithra App',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.warmDarkBrown,
                          ),
                        ),
                        Text(
                          'Share download link on WhatsApp',
                          style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const Text(
                'WhatsApp Share Message & Download Link:',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: textController,
                maxLines: 7,
                decoration: InputDecoration(
                  fillColor: const Color(0xFFF9FBF8),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.warmBorder),
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
                style: const TextStyle(fontSize: 12, height: 1.4),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFA5D6A7)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.link_rounded, color: AppColors.whatsappGreen, size: 20),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        appDownloadUrl,
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF2E7D32)),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () => copyDownloadLink(context),
                      icon: const Icon(Icons.copy_rounded, size: 14, color: AppColors.primaryGreen),
                      label: const Text('Copy', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryGreen)),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.copy_rounded, color: AppColors.primaryGreen, size: 18),
                      label: const Text(
                        'Copy Link',
                        style: TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: AppColors.primaryGreen),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        copyDownloadLink(context);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.chat_bubble_rounded, color: Colors.white, size: 18),
                      label: const Text(
                        'Share on WhatsApp',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.whatsappGreen,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () async {
                        Navigator.pop(ctx);
                        final success = await shareAppViaWhatsApp(customMessage: textController.text);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(success ? 'Opening WhatsApp with App Download Link...' : 'Launching WhatsApp...'),
                              backgroundColor: AppColors.whatsappGreen,
                            ),
                          );
                        }
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
}
