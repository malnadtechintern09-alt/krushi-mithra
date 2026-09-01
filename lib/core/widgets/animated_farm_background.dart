import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

class AnimatedFarmBackground extends StatefulWidget {
  final Widget child;
  final double height;

  const AnimatedFarmBackground({
    super.key,
    required this.child,
    this.height = 240,
  });

  @override
  State<AnimatedFarmBackground> createState() => _AnimatedFarmBackgroundState();
}

class _AnimatedFarmBackgroundState extends State<AnimatedFarmBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SizedBox(
          height: widget.height,
          width: double.infinity,
          child: Stack(
            children: [
              // 1. Sky & Sun Gradient Background
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF0B3818), // Deep Forest Green
                      Color(0xFF1E5631), // Lush Emerald Green
                      Color(0xFF388E3C), // Farm Field Green
                    ],
                  ),
                ),
              ),

              // 2. Custom Painted Animated Hills, Clouds & Particles
              Positioned.fill(
                child: CustomPaint(
                  painter: _FarmLandscapePainter(
                    animationValue: _controller.value,
                  ),
                ),
              ),

              // 3. Child Overlay (Welcome Header, User Profile, Search Bar, etc.)
              Positioned.fill(
                child: widget.child,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FarmLandscapePainter extends CustomPainter {
  final double animationValue;

  _FarmLandscapePainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    // 1. Draw Glowing Sun
    final sunPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.accentGold.withValues(alpha: 0.7),
          AppColors.accentGold.withValues(alpha: 0.2),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(
        center: Offset(width * 0.85, height * 0.3),
        radius: 70 + math.sin(animationValue * math.pi * 2) * 5,
      ));

    canvas.drawCircle(
      Offset(width * 0.85, height * 0.3),
      70 + math.sin(animationValue * math.pi * 2) * 5,
      sunPaint,
    );

    // 2. Draw Drifting Clouds
    final cloudPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;

    _drawCloud(canvas, cloudPaint, (width * 0.2 + animationValue * width) % (width + 120) - 60, height * 0.2, 35);
    _drawCloud(canvas, cloudPaint, (width * 0.7 + animationValue * width * 0.8) % (width + 120) - 60, height * 0.32, 25);
    _drawCloud(canvas, cloudPaint, (width * 0.45 + animationValue * width * 0.5) % (width + 120) - 60, height * 0.15, 20);

    // 3. Draw Background Rolling Hills (Distant Mountains)
    final distantHillsPath = Path();
    distantHillsPath.moveTo(0, height * 0.65);

    for (double x = 0; x <= width; x += 10) {
      final y = height * 0.65 +
          math.sin((x / width * 3 * math.pi) + (animationValue * math.pi * 2)) * 8;
      distantHillsPath.lineTo(x, y);
    }

    distantHillsPath.lineTo(width, height);
    distantHillsPath.lineTo(0, height);
    distantHillsPath.close();

    final distantHillsPaint = Paint()
      ..color = const Color(0xFF2E7D32).withValues(alpha: 0.4)
      ..style = PaintingStyle.fill;

    canvas.drawPath(distantHillsPath, distantHillsPaint);

    // 4. Draw Foreground Animated Farm Field Waves
    final farmFieldPath = Path();
    farmFieldPath.moveTo(0, height * 0.75);

    for (double x = 0; x <= width; x += 5) {
      final y = height * 0.75 +
          math.sin((x / width * 4 * math.pi) - (animationValue * math.pi * 2)) * 6;
      farmFieldPath.lineTo(x, y);
    }

    farmFieldPath.lineTo(width, height);
    farmFieldPath.lineTo(0, height);
    farmFieldPath.close();

    final farmFieldPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF4CAF50).withValues(alpha: 0.6),
          const Color(0xFF1E5631).withValues(alpha: 0.9),
        ],
      ).createShader(Rect.fromLTWH(0, height * 0.7, width, height * 0.3));

    canvas.drawPath(farmFieldPath, farmFieldPaint);

    // 5. Draw Floating Agricultural Pollen / Golden Crop Particles
    final random = math.Random(42);
    final particlePaint = Paint()..color = AppColors.accentGold.withValues(alpha: 0.6);

    for (int i = 0; i < 15; i++) {
      final startX = (random.nextDouble() * width);
      final speed = 0.5 + random.nextDouble() * 0.5;
      final y = (height - ((animationValue * speed * height + random.nextDouble() * height) % height));
      final x = startX + math.sin(animationValue * math.pi * 2 + i) * 12;
      canvas.drawCircle(Offset(x, y), 2.0 + (i % 2), particlePaint);
    }
  }

  void _drawCloud(Canvas canvas, Paint paint, double x, double y, double radius) {
    canvas.drawCircle(Offset(x, y), radius, paint);
    canvas.drawCircle(Offset(x + radius * 0.7, y - radius * 0.2), radius * 0.8, paint);
    canvas.drawCircle(Offset(x - radius * 0.7, y + radius * 0.1), radius * 0.7, paint);
    canvas.drawCircle(Offset(x + radius * 1.3, y + radius * 0.2), radius * 0.6, paint);
  }

  @override
  bool shouldRepaint(covariant _FarmLandscapePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
