import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share_plus/share_plus.dart';

class AchievementBadges extends StatelessWidget {
  const AchievementBadges({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('أوسمتي', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2E4365))),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF2E4365)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser?.uid)
              .snapshots(),
          builder: (context, snapshot) {
            double userHours = 0;
            if (snapshot.hasData && snapshot.data!.exists) {
              userHours = (snapshot.data!['teachingHours'] ?? 0).toDouble();
            }

            return Stack(
              children: [
                const ConfettiBackground(),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildBadgeItem(context, goal: 5, title: "متطوع ناشئ", current: userHours),
                            const SizedBox(width: 20),
                            _buildBadgeItem(context, goal: 10, title: "متطوع متميز", current: userHours),
                            const SizedBox(width: 20),
                            _buildBadgeItem(context, goal: 25, title: "سفير العطاء", current: userHours),
                          ],
                        ),
                      ),
                      const SizedBox(height: 60),
                      Text(
                        'ساعاتك التعليمية الحالية: ${userHours.toStringAsFixed(1)} ساعة',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54),
                      ),
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

  Widget _buildBadgeItem(BuildContext context, {required int goal, required String title, required double current}) {
    bool isUnlocked = current >= goal;

    return GestureDetector(
      onTap: () {
        if (isUnlocked) {
          _showCelebration(context, title, goal);
        } else {
          _showLockedInfo(context, goal, current);
        }
      },
      child: Column(
        children: [
          // رسم الوسام
          CustomBadgePainter(hours: goal, isUnlocked: isUnlocked),
          const SizedBox(height: 10),
          Text(
            "ساعة $goal",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isUnlocked ? Colors.orange.shade800 : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  void _showLockedInfo(BuildContext context, int goal, double current) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("باقي لك ${(goal - current).toStringAsFixed(1)} ساعة لفتح هذا الوسام! 🔒", textAlign: TextAlign.right),
        backgroundColor: Colors.grey.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showCelebration(BuildContext context, String title, int goal) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("أحسنت✨ ", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            CustomBadgePainter(hours: goal, isUnlocked: true, size: 150),
            const SizedBox(height: 20),
            Text("حصلت على وسام $title", textAlign: TextAlign.center),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Share.share('حققت وسام $goal ساعة في تطبيق تلاقِ! 🌟'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, shape: StadiumBorder()),
              child: const Text("شارك", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}


class CustomBadgePainter extends StatelessWidget {
  final int hours;
  final bool isUnlocked;
  final double size;

  const CustomBadgePainter({super.key, required this.hours, required this.isUnlocked, this.size = 100});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CustomPaint(
          size: Size(size, size),
          painter: BadgeShapePainter(
            color: isUnlocked ? Colors.orange : Colors.grey.shade300,
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$hours',
              style: TextStyle(
                color: isUnlocked ? Colors.white : Colors.grey.shade500,
                fontSize: size * 0.35,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'ساعات',
              style: TextStyle(
                color: isUnlocked ? Colors.white : Colors.grey.shade500,
                fontSize: size * 0.12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        if (!isUnlocked)
          Icon(Icons.lock_outline, color: Colors.grey.shade600, size: size * 0.3),
      ],
    );
  }
}


class BadgeShapePainter extends CustomPainter {
  final Color color;
  BadgeShapePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    int points = 16; 
    double innerRadius = size.width / 2.3;
    double outerRadius = size.width / 2;
    double centerX = size.width / 2;
    double centerY = size.height / 2;

    for (int i = 0; i < points * 2; i++) {
      double radius = i.isEven ? outerRadius : innerRadius;
      double angle = i * math.pi / points;
      double x = centerX + radius * math.cos(angle);
      double y = centerY + radius * math.sin(angle);
      if (i == 0) path.moveTo(x, y);
      else path.lineTo(x, y);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class ConfettiBackground extends StatelessWidget {
  const ConfettiBackground({super.key});
  @override
  Widget build(BuildContext context) {
    final random = math.Random();
    return Stack(
      children: List.generate(20, (index) {
        return Positioned(
          left: random.nextDouble() * MediaQuery.of(context).size.width,
          top: random.nextDouble() * MediaQuery.of(context).size.height,
          child: Container(
            width: 5, height: 5,
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
          ),
        );
      }),
    );
  }
}
