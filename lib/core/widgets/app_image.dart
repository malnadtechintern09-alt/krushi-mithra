import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

class AppImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final IconData placeholderIcon;

  const AppImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholderIcon = Icons.agriculture,
  });

  @override
  Widget build(BuildContext context) {
    final cleanUrl = url.trim();

    if (cleanUrl.isEmpty) {
      return _buildFallback();
    }

    // 1. Data URL (Base64) Image support
    if (cleanUrl.startsWith('data:image')) {
      try {
        final commaIndex = cleanUrl.indexOf(',');
        if (commaIndex != -1) {
          final base64Str = cleanUrl.substring(commaIndex + 1);
          final Uint8List bytes = base64Decode(base64Str);
          return Image.memory(
            bytes,
            width: width,
            height: height,
            fit: fit,
            errorBuilder: (_, __, ___) => _buildFallback(),
          );
        }
      } catch (e) {
        debugPrint('[AppImage] Base64 decode error: $e');
        return _buildFallback();
      }
    }

    // 2. Flutter Asset Image
    if (cleanUrl.startsWith('assets/')) {
      return Image.asset(
        cleanUrl,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, __, ___) => _buildFallback(),
      );
    }

    // 3. Local File Path Image
    if (cleanUrl.startsWith('/') || cleanUrl.contains(':\\') || cleanUrl.contains('/data/') || cleanUrl.startsWith('file://')) {
      final path = cleanUrl.replaceFirst('file://', '');
      final file = File(path);
      if (file.existsSync()) {
        return Image.file(
          file,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (_, __, ___) => _buildFallback(),
        );
      }
    }

    // 3. Network Image (HTTP / HTTPS)
    return Image.network(
      cleanUrl,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, __, ___) => _buildFallback(),
    );
  }

  Widget _buildFallback() {
    final isPerson = placeholderIcon == Icons.person ||
        placeholderIcon == Icons.person_rounded ||
        placeholderIcon == Icons.account_circle ||
        placeholderIcon == Icons.badge ||
        url.contains('photo-') ||
        url.contains('profile') ||
        url.contains('avatar') ||
        url.contains('usr_') ||
        url.contains('w_');

    final iconToUse = isPerson ? Icons.person_rounded : placeholderIcon;

    return Container(
      width: width,
      height: height,
      color: isPerson ? const Color(0xFFE8F5E9) : AppColors.chipBackground,
      child: Center(
        child: Icon(
          iconToUse,
          size: (height != null && height! < 60) ? (height! * 0.5) : 36,
          color: AppColors.primaryGreen,
        ),
      ),
    );
  }
}
