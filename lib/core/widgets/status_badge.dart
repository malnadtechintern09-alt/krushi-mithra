import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;

    switch (status.toLowerCase()) {
      case 'confirmed':
      case 'completed':
      case 'verified':
      case 'available':
      case 'delivered':
        bg = const Color(0xFFE8F5E9);
        fg = AppColors.success;
        break;
      case 'pending':
      case 'processing':
      case 'in progress':
        bg = const Color(0xFFFFF3E0);
        fg = AppColors.warning;
        break;
      case 'cancelled':
      case 'unavailable':
      case 'failed':
        bg = const Color(0xFFFFEBEE);
        fg = AppColors.error;
        break;
      default:
        bg = AppColors.chipBackground;
        fg = AppColors.textSecondary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: fg,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
