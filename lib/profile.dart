import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'package:firebase_auth/firebase_auth.dart';    
import 'editProfile.dart';
import 'allRequests.dart';
import 'home.dart';
import 'Leaderboard.dart';
import 'Setting.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final Color primaryNavy = const Color(0xFF344966);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentUser = FirebaseAuth.instance.currentUser;

    return Directionality(
      textDirection: TextDirection.rtl, 
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance.collection('users').doc(currentUser?.uid).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Color(0xFF344966)));
            }
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Center(child: Text("لم يتم العثور على بيانات المستخدم"));
            }

            var userData = snapshot.data!.data() as Map<String, dynamic>;
            String name = userData['name'] ?? "لا يوجد اسم";
            String bio = userData['bio'] ?? "لا توجد نبذة تعريفية بعد.";
            String profilePic = userData['profilePic'] ?? 'assets/avatar1.png';
            List<String> skills = List<String>.from(userData['skills'] ?? []);

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center, 
                children: [
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                            border: Border.all(color: isDark ? const Color(0xFF1E1E1E) : Colors.white, width: 4),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, spreadRadius: 2),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 65,
                            backgroundColor: Colors.grey[200],
                            backgroundImage: profilePic.startsWith('assets') 
                                ? AssetImage(profilePic) as ImageProvider
                                : NetworkImage(profilePic),
                           
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 60),
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 24, 
                      fontWeight: FontWeight.bold, 
                      color: isDark ? Colors.white : primaryNavy, 
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfilePage()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryNavy,
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                        child: const Text('تعديل الملف', style: TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end, 
                      children: [
                        const Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'نبذة', 
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 10),
                        buildStaticBox(context: context, isDark: isDark, text: bio),
                        const SizedBox(height: 20),
                        const Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'المهارات', 
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (skills.isEmpty)
                          buildStaticBox(context: context, isDark: isDark, text: "لا توجد مهارات مضافة.")
                        else
                          ...skills.map((skill) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: buildStaticBox(context: context, isDark: isDark, text: skill),
                          )).toList(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Theme.of(context).cardColor, 
          selectedItemColor: isDark ? Colors.white : const Color(0xFF1A237E),
          unselectedItemColor: Colors.grey,
          currentIndex: 3, 
          onTap: (index) {
            if (index == 0) Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
            if (index == 1) Navigator.push(context, MaterialPageRoute(builder: (context) => const Leaderboard()));
            if (index == 2) Navigator.push(context, MaterialPageRoute(builder: (context) => const allRequests()));
            if (index == 3) return; 
            if (index == 4) Navigator.push(context, MaterialPageRoute(builder: (context) => const Setting()));
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'الرئيسية'),
            BottomNavigationBarItem(icon: Icon(Icons.star_outline), label: 'لوحة الصدارة'),
            BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'المحادثة'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'الملف الشخصي'),
            BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'الإعدادات'),
          ],
        ),
      ),
    );
  }

  Widget buildStaticBox({required BuildContext context, required bool isDark, required String text}) {
    return Container(
      width: MediaQuery.of(context).size.width, 
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor, 
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isDark ? Colors.white10 : const Color(0xFFEEEEEE), 
          width: 1.5,
        ),
      ),
      child: Align(
        alignment: Alignment.centerRight, 
        child: Text(
          text,
          textAlign: TextAlign.right, 
          textDirection: TextDirection.rtl, 
          style: TextStyle(
            fontSize: 16, 
            color: isDark ? Colors.white70 : Colors.black87, 
            height: 1.4,
          ),
        ),
      ),
    );
  }
}

class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
        size.width / 2, size.height + 50, size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
