import 'package:flutter/material.dart';
import 'editProfile.dart';
import 'allRequests.dart';
import 'reportPage.dart';
import 'home.dart';
import 'Leaderboard.dart';
import 'Setting.dart';
import 'chat.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    const Color primaryNavy = Color(0xFF344966);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                // الهيدر مع أيقونات التحكم
                ClipPath(
                  clipper: HeaderClipper(),
                  child: Container(
                    height: 250,
                    color: primaryNavy,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // أيقونة الاستفهام (ربطتها بصفحة البلاغات)
                        IconButton(
                          icon: const Icon(Icons.report_gmailerrorred_outlined, color: Colors.white, size: 28),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const ReportPage()));
                          },
                        ),
                        // زر العودة
                        IconButton(
                          icon: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 25),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                // صورة الملف الشخصي
                Positioned(
                  bottom: -50,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, spreadRadius: 2),
                      ],
                    ),
                    child: const CircleAvatar(
                      radius: 65,
                      backgroundImage: NetworkImage('https://i.pravatar.cc/300?img=12'),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),
            const Text(
              'محمد أحمد',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryNavy),
            ),
            const SizedBox(height: 20),
            // أزرار التحكم (تعديل الملف والطلبات)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  // زر تعديل الملف
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfilePage()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryNavy,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      child: const Text('تعديل الملف', style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ),
                  const SizedBox(width: 15),
                  // زر الطلبات
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const allRequests()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryNavy,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      child: const Text('الطلبات', style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // النبذة والمهارات
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('نبذة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  buildStaticBox(
                    text: "مصمم مواقع مهتم بإنشاء واجهات مستخدم جذابة وسهلة الاستخدام مهتم بتحويل الأفكار المعقدة إلى تصاميم رقمية بسيطة ومبتكرة تخدم تجربة المستخدم.",
                  ),
                  const SizedBox(height: 20),
                  const Text('المهارات', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  buildStaticBox(text: "تصميم واجهات المستخدم (UI/UX)"),
                  const SizedBox(height: 10),
                  buildStaticBox(text: "تطوير الويب (HTML/CSS)"),
                  const SizedBox(height: 10),
                  buildStaticBox(text: "إدارة المشاريع البرمجية"),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
      // شريط التنقل السفلي المفعل
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF1A237E),
        unselectedItemColor: Colors.grey,
        currentIndex: 1, 
        onTap: (index) {
          if (index == 0) Navigator.push(context, MaterialPageRoute(builder: (context) => const Setting()));
          if (index == 2) Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatScreen()));
          if (index == 3) Navigator.push(context, MaterialPageRoute(builder: (context) => const Leaderboard()));
          if (index == 4) Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'الإعدادات'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'الملف الشخصي'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'المحادثة'),
          BottomNavigationBarItem(icon: Icon(Icons.star_outline), label: 'لوحة الصدارة'),
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'الرئيسية'),
        ],
      ),
    );
  }

  Widget buildStaticBox({required String text}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFEEEEEE), width: 1.5),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, color: Colors.black87, height: 1.4),
      ),
    );
  }
}

class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(size.width / 2, size.height + 50, size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
