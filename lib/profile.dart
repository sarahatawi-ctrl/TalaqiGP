import 'package:flutter/material.dart';

void main() {
  runApp(const TalaaqApp());
}

class TalaaqApp extends StatelessWidget {
  const TalaaqApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar', 'SA'),
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: const ProfilePage(),
      ),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  
  //   display the success dialog with a checkmark
  void showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            padding: const EdgeInsets.all(30),
            height: 280,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Success checkmark icon
                const Icon(
                  Icons.check_circle_outline_rounded,
                  size: 90,
                  color: Color(0xFF344966),
                ),
                const SizedBox(height: 20),
                const Text(
                  'تم الإرسال بنجاح',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),
                // Dismiss button
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('موافق', style: TextStyle(fontSize: 18, color: Color(0xFF344966))),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryNavy = Color(0xFF344966);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // top section with custom curve and user avatar
            Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                ClipPath(
                  clipper: HeaderClipper(),
                  child: Container(
                    height: 250,
                    color: primaryNavy,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // header back button
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 25),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                ),
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
                      backgroundImage: NetworkImage('https://i.pravatar.cc/300?img=12'),//test
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 60),

            // Profile name
            const Text(
              'محمد أحمد',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryNavy),
            ),
            const SizedBox(height: 15),
            
            //  button to send request
            ElevatedButton(
              onPressed: showSuccessDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryNavy,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: const Text('ارسال طلب', style: TextStyle(color: Colors.white, fontSize: 18)),
            ),

            const SizedBox(height: 30),

            // static information boxes
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('نبذة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  buildStaticBox(
                    text: "مصمم مواقع مهتم بإنشاء واجهات مستخدم جذابة وسهلة الاستخدام مهتم بتحويل الأفكار المعقدة إلى تصاميم رقمية بسيطة ومبتكرة تخدم تجربة المستخدم.",
                    isLongText: true,
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
      // navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF1A237E),
        unselectedItemColor: Colors.grey,
        currentIndex: 1, 
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'الاعدادات'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'الملف الشخصي'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'الدردشة'),
          BottomNavigationBarItem(icon: Icon(Icons.star_outline), label: 'لوحة الصدارة'),
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'الرئيسية'),
        ],
      ),
    );
  }

  
  Widget buildStaticBox({required String text, bool isLongText = false}) {
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
