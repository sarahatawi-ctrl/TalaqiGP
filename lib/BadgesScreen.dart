import 'package:flutter/material.dart';
import 'dart:math' as math;

class BadgesScreen extends StatelessWidget {
  const BadgesScreen({Key? key}) : super(key: key);

  static const Color colorTopBadges = Color(0xFFE94B28); 
  static const Color colorBottomBadges = Color(0xFF4A4A4A); 
  static const Color colorPoliceBlue = Color(0xFF2E4365); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      body: Stack(
        children: [
          const ConfettiBackground(count: 60),
          
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 28),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Text(
                        'الأوسمة',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildSunburstBadge('5', 'ساعات', colorTopBadges),
                      _buildSunburstBadge('10', 'ساعات', colorTopBadges),
                      _buildSunburstBadge('15', 'ساعة', colorTopBadges),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width: 15),
                      _buildSunburstBadge('20', 'ساعة', colorBottomBadges),
                      const SizedBox(width: 35),
                      _buildSunburstBadge('25', 'ساعة', colorBottomBadges),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSunburstBadge(String number, String label, Color baseColor) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 100,
          height: 100,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: const Size(100, 100),
                painter: SunburstPainter(color: baseColor),
              ),
              Container(
                width: 75,
                height: 75,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: baseColor,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                    BoxShadow(
                      color: baseColor.withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      number,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.0,
                      ),
                    ),
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SunburstPainter extends CustomPainter {
  final Color color;
  SunburstPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color.withOpacity(0.7)
      ..style = PaintingStyle.fill;

    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double outerRadius = size.width / 2;
    final double innerRadius = outerRadius * 0.85;
    const int points = 12;

    final Path path = Path();
    for (int i = 0; i < points * 2; i++) {
      final double radius = i.isEven ? outerRadius : innerRadius;
      final double angle = (i * math.pi) / points - (math.pi / 2);
      final double x = centerX + radius * math.cos(angle);
      final double y = centerY + radius * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
    
    final Paint strokePaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ConfettiBackground extends StatelessWidget {
  final int count;
  const ConfettiBackground({super.key, this.count = 30});

  @override
  Widget build(BuildContext context) {
    final random = math.Random(42);
    return Stack(
      children: List.generate(count, (index) {
        final color = [
          const Color(0xFFFF4500),
          const Color(0xFFB0BEC5), 
          const Color(0xFF90CAF9), 
          Colors.orange,
        ][random.nextInt(4)];
        
        return Positioned(
          left: random.nextDouble() * MediaQuery.of(context).size.width,
          top: random.nextDouble() * MediaQuery.of(context).size.height,
          child: Transform.rotate(
            angle: random.nextDouble() * 2 * math.pi,
            child: Container(
              width: random.nextDouble() * 7 + 3,
              height: random.nextDouble() * 7 + 3,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: random.nextBool() ? BoxShape.circle : BoxShape.rectangle,
              ),
            ),
          ),
        );
      }),
    );
  }
}
