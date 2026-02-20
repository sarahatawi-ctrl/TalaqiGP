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

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryNavy = Color(0xFF344966);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            //the top part with the navy blue curve and the user`s image
            Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                //   navy blue curve
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
                        IconButton(
                          icon: const Icon(Icons.list, color: Colors.white, size: 30),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios, color: Colors.red, size: 25),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ),
                //   user`s image
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
                      backgroundImage: NetworkImage('https://i.pravatar.cc/300?img=12'), //    test
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 60),

            //  user`s name and requset button
            const Text(
              'محمد أحمد',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryNavy),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryNavy,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: const Text('ارسال طلب', style: TextStyle(color: Colors.white, fontSize: 18)),
            ),

            const SizedBox(height: 30),

            //  skills
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('نبذة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  buildInfoBox(height: 100), // summary box 
                  
                  const SizedBox(height: 20),
                  const Text('المهارات', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  buildInfoBox(height: 50),
                  const SizedBox(height: 10),
                  buildInfoBox(height: 50),
                  const SizedBox(height: 10),
                  buildInfoBox(height: 50),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),

      // bar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF1A237E),
        unselectedItemColor: Colors.grey,
        currentIndex: 1, 
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'الاعدادات'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'الملف الشخصي'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'البحث'),
          BottomNavigationBarItem(icon: Icon(Icons.star_outline), label: 'لوحة الصدارة'),
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'الرئيسية'),
        ],
      ),
    );
  }

  // skils and summary
  Widget buildInfoBox({required double height}) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFD1B7B7)),
      ),
    );
  }
}

// drwa the curve
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
