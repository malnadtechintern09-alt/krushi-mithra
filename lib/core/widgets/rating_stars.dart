import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

class RatingStars extends StatelessWidget {
  final double rating;
  final int count;
  final double iconSize;
  final bool showText;

  const RatingStars({
    super.key,
    required this.rating,
    this.count = 0,
    this.iconSize = 16,
    this.showText = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.star_rounded,
          color: AppColors.accentGold,
          size: iconSize,
        ),
        const SizedBox(width: 4),
        Text(
          rating.toStringAsFixed(1),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: iconSize * 0.85,
            color: AppColors.textPrimary,
          ),
        ),
        if (showText && count > 0) ...[
          const SizedBox(width: 4),
          Text(
            '($count)',
            style: TextStyle(
              fontSize: iconSize * 0.75,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ],
    );
  }
}
