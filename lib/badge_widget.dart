import 'package:flutter/material.dart';
import 'dart:math' as math;

class BadgeWidget extends StatelessWidget {
  final String number;
  final String label;
  final bool isOrange;
  final double size;

  const BadgeWidget({
    super.key,
    required this.number,
    required this.label,
    required this.isOrange,
    this.size = 100.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          
          CustomPaint(
            size: Size(size, size),
            painter: BadgePainter(isOrange: isOrange),
          ),
         
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                number,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: size * 0.35,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.3),
                      offset: const Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: size * 0.12,
                  fontWeight: FontWeight.w500,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.3),
                      offset: const Offset(0, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BadgePainter extends CustomPainter {
  final bool isOrange;

  BadgePainter({required this.isOrange});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    
    final List<Color> gradientColors = isOrange
        ? [
            const Color(0xFFFFB366), 
            const Color(0xFFFF9944), 
            const Color(0xFFFF8533), 
          ]
        : [
            const Color(0xFFB0B0B0), 
            const Color(0xFF8E8E8E), 
            const Color(0xFF707070), 
          ];

   
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.25)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    _drawStarBurst(canvas, center, radius * 0.95, 16, shadowPaint, offset: const Offset(0, 4));

    
    final gradientPaint = Paint()
      ..shader = RadialGradient(
        colors: gradientColors,
        stops: const [0.3, 0.7, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    _drawStarBurst(canvas, center, radius * 0.9, 16, gradientPaint);

   
    final innerCirclePaint = Paint()
      ..shader = RadialGradient(
        colors: [
          gradientColors[1].withOpacity(0.8),
          gradientColors[2],
        ],
        stops: const [0.0, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius * 0.65));

    canvas.drawCircle(center, radius * 0.65, innerCirclePaint);

  
    final highlightPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white.withOpacity(0.3),
          Colors.white.withOpacity(0.0),
        ],
        stops: const [0.0, 1.0],
      ).createShader(Rect.fromCircle(
        center: Offset(center.dx - radius * 0.2, center.dy - radius * 0.2),
        radius: radius * 0.4,
      ));

    canvas.drawCircle(
      Offset(center.dx - radius * 0.15, center.dy - radius * 0.15),
      radius * 0.3,
      highlightPaint,
    );
  }

  void _drawStarBurst(Canvas canvas, Offset center, double radius, int points,
      Paint paint, {Offset offset = Offset.zero}) {
    final path = Path();
    final outerRadius = radius;
    final innerRadius = radius * 0.85;
    final angle = (math.pi * 2) / (points * 2);

    for (int i = 0; i < points * 2; i++) {
      final currentRadius = i.isEven ? outerRadius : innerRadius;
      final x = center.dx + offset.dx + currentRadius * math.cos(i * angle - math.pi / 2);
      final y = center.dy + offset.dy + currentRadius * math.sin(i * angle - math.pi / 2);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
