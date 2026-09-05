import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

class AnimatedFarmBackground extends StatefulWidget {
  final Widget child;
  final double height;

  const AnimatedFarmBackground({
    super.key,
    required this.child,
    this.height = 245,
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
              // 1. Rich Farm Hero Banner Illustration (Golden Sunset Sky, Farm House, Tractor, Indian Farmer Character)
              Positioned.fill(
                child: Image.asset(
                  'assets/images/farm_hero_banner_illustration.jpg',
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, err, stack) {
                    return Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFFFCF7EC),
                            Color(0xFFF7EACD),
                            Color(0xFFECE0C0),
                          ],
                        ),
                      ),
                      child: CustomPaint(
                        painter: _WarmFarmIllustrationPainter(
                          animationValue: _controller.value,
                        ),
                      ),
                    );
                  },
                ),
              ),

              // 2. Soft Gradient Overlay to Guarantee 100% Crisp Text & Pill Badge Contrast
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      stops: const [0.0, 0.5, 1.0],
                      colors: [
                        Colors.white.withValues(alpha: 0.85),
                        Colors.white.withValues(alpha: 0.50),
                        Colors.white.withValues(alpha: 0.05),
                      ],
                    ),
                  ),
                ),
              ),

              // 3. Foreground Overlay Content
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

class _WarmFarmIllustrationPainter extends CustomPainter {
  final double animationValue;

  _WarmFarmIllustrationPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    // Glowing Sun
    final sunCenter = Offset(width * 0.85, height * 0.22);
    final sunRadius = 40.0 + math.sin(animationValue * math.pi * 2) * 2;

    final sunPaint = Paint()
      ..color = const Color(0xFFF5B638)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(sunCenter, sunRadius, sunPaint);

    // Low Rolling Field Waves
    final hillPath = Path();
    hillPath.moveTo(0, height * 0.86);
    hillPath.quadraticBezierTo(width * 0.45, height * 0.80, width, height * 0.88);
    hillPath.lineTo(width, height);
    hillPath.lineTo(0, height);
    hillPath.close();

    final hillPaint = Paint()..color = const Color(0xFF7FA852);
    canvas.drawPath(hillPath, hillPaint);
  }

  @override
  bool shouldRepaint(covariant _WarmFarmIllustrationPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
