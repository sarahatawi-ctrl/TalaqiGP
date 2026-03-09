import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:share_plus/share_plus.dart';
import 'home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
const MyApp({super.key});

@override
Widget build(BuildContext context) {
  return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AchievementBadges(),
    );
}
}

class AchievementBadges extends StatelessWidget {
  const AchievementBadges({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6F3),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isLargeScreen = constraints.maxWidth > 600;
            double horizontalPadding =
                isLargeScreen ? constraints.maxWidth * 0.25 : 24.0;
            double badgeSize = isLargeScreen ? 300 : 240;

            return Stack(
              children: [
                const ConfettiBackground(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          icon: const Icon(Icons.close,
                              color: Colors.black87, size: 28),
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const home()),
                              (route) => false,
                            );
                          },
                        ),
                      ),
                      const Spacer(flex: 1),
                      const Text(
                        'أحسنت!',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF212121),
                        ),
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'لقد حصلت على وسام',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF424242),
                        ),
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                      ),
                      const Spacer(flex: 2),
                      BadgeWidget(size: badgeSize),
                      const Spacer(flex: 3),
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: () {
                            Share.share(
                              '🎉 لقد حصلت على وسام جديد في التطبيق لإكمالي 5 ساعات من التطوع! #إنجاز',
                              subject: 'إنجاز جديد!',
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2D4369),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            elevation: 2,
                          ),
                          child: const Text(
                            'شارك',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class BadgeWidget extends StatelessWidget {
  final double size;
  const BadgeWidget({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size * 1.1,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: size * 0.05,
            child: CustomPaint(
              size: Size(size * 0.35, size * 0.35),
              painter: ProfessionalRibbonPainter(
                color: const Color(0xFFFF8C00),
              ),
            ),
          ),
          Positioned(
            top: size * 0.18,
            child: Container(
              width: size * 0.7,
              height: size * 0.7,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFFFB347),
                    Color(0xFFFF8C00),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: Colors.white.withAlpha(80),
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(40),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                  )
                ],
              ),
              child: Center(
                child: Container(
                  width: size * 0.58,
                  height: size * 0.58,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withAlpha(80),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '5',
                        style: TextStyle(
                          fontSize: size * 0.22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1,
                        ),
                      ),
                      Text(
                        'ساعات',
                        style: TextStyle(
                          fontSize: size * 0.07,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfessionalRibbonPainter extends CustomPainter {
  final Color color;
  ProfessionalRibbonPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final shadowPaint = Paint()..color = Colors.black.withOpacity(0.25);

    final path = Path();
    double w = size.width;
    double h = size.height;

    path.moveTo(w * 0.1, 0);
    path.lineTo(w * 0.5, h * 0.3);
    path.lineTo(w * 0.5, h);
    path.lineTo(0, h * 0.7);
    path.close();

    path.moveTo(w * 0.9, 0);
    path.lineTo(w * 0.5, h * 0.3);
    path.lineTo(w * 0.5, h);
    path.lineTo(w, h * 0.7);
    path.close();

    canvas.drawPath(path.shift(const Offset(0, 3)), shadowPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ConfettiBackground extends StatelessWidget {
  const ConfettiBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final random = math.Random();
    return Stack(
      children: List.generate(40, (index) {
        final color = [
          const Color(0xFFFFD700),
          const Color(0xFFFF4500),
          const Color(0xFF1E90FF),
          const Color(0xFF32CD32),
          const Color(0xFF9370DB),
        ][random.nextInt(5)];

        return Positioned(
          left: random.nextDouble() * MediaQuery.of(context).size.width,
          top: random.nextDouble() * MediaQuery.of(context).size.height,
          child: Transform.rotate(
            angle: random.nextDouble() * 2 * math.pi,
            child: Container(
              width: random.nextDouble() * 8 + 4,
              height: random.nextDouble() * 8 + 4,
              decoration: BoxDecoration(
                color: color.withAlpha(153),
                shape: random.nextBool()
                    ? BoxShape.circle
                    : BoxShape.rectangle,
              ),
            ),
          ),
        );
      }),
    );
  }
}
