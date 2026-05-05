import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'AchievementBadges.dart'; 

class BadgesScreen extends StatelessWidget {
  const BadgesScreen({Key? key}) : super(key: key);

  static const Color primaryColor = Color(0xFF4A6FA5);
  static const Color accentColor = Color(0xFFD9534F);
  static const Color lockedColor = Color(0xFFB0BCC5);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            const ConfettiBackground(),
            Column(
              children: [
                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: isDark ? Colors.white : Colors.black87,
                          size: 24,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text(
                        'الأوسمة',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 48), 
                    ],
                  ),
                ),
                
                
                Expanded(
                  child: StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(currentUser?.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator(color: primaryColor));
                      }

                      double userHours = 0.0;
                      if (snapshot.hasData && snapshot.data!.exists) {
                        var data = snapshot.data!.data() as Map<String, dynamic>;
                        
                        userHours = (data['teachingHours'] ?? 0.0).toDouble();
                      }

                      return GridView.count(
                        crossAxisCount: 3,
                        padding: const EdgeInsets.all(16),
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.65, 
                        children: [
                          _buildProfessionalBadge(context, '5', 'ساعات', userHours >= 5),
                          _buildProfessionalBadge(context, '10', 'ساعات', userHours >= 10),
                          _buildProfessionalBadge(context, '25', 'ساعة', userHours >= 25),
                          _buildProfessionalBadge(context, '50', 'ساعة', userHours >= 50),
                          _buildProfessionalBadge(context, '100', 'ساعة', userHours >= 100),
                          _buildProfessionalBadge(context, '200', 'ساعة', userHours >= 200),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfessionalBadge(BuildContext context, String hours, String label, bool isUnlocked) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        if (isUnlocked) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AchievementBadges()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('استمر في التعلم لفتح وسام الـ $hours $label!', textAlign: TextAlign.right),
              backgroundColor: primaryColor,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 130,
            height: 160,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Positioned(
                  top: 0,
                  child: CustomPaint(
                    size: const Size(60, 60),
                    painter: ProfessionalRibbonPainter(
                      color: isUnlocked
                          ? accentColor
                          : (isDark ? Colors.grey[700]! : lockedColor),
                    ),
                  ),
                ),
                Positioned(
                  top: 20,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: isUnlocked
                            ? [const Color(0xFF5A82B4), const Color(0xFF4A6FA5)]
                            : (isDark 
                                ? [const Color(0xFF2C2C2C), const Color(0xFF1E1E1E)] 
                                : [const Color(0xFFC8D0D8), const Color(0xFFB0BCC5)]),
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(
                        color: isUnlocked
                            ? const Color(0xFF7E9DCA)
                            : (isDark ? Colors.white10 : const Color(0xFFD4DDE3)),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDark ? 0.4 : 0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Container(
                        width: 88,
                        height: 88,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 2,
                          ),
                        ),
                        child: isUnlocked
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                   Text(
                                     hours,
                                     style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      height: 1.1,
                                    ),
                                  ),
                                  Text(
                                    label,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white.withOpacity(0.9),
                                    ),
                                  ),
                                ],
                              )
                            : Icon(
                                Icons.lock_outline,
                                color: isDark ? Colors.white38 : Colors.white.withOpacity(0.8),
                                size: 40,
                              ),
                      ),
                    ),
                  ),
                ),
              ],
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
    final shadowPaint = Paint()..color = Colors.black.withOpacity(0.2);

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

    canvas.drawPath(path.shift(const Offset(0, 2)), shadowPaint);
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                color: color.withAlpha(isDark ? 80 : 153),
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

