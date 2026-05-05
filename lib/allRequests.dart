import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'requests_page.dart';
import 'home.dart';
import 'Leaderboard.dart';
import 'Setting.dart';
import 'chat.dart';
import 'profile.dart';

class allRequests extends StatelessWidget {
  const allRequests({super.key});

  static const Color primaryColor = Color(0xFF2E4365);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentUser = FirebaseAuth.instance.currentUser;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          elevation: 0,
          title: Text(
            'المحادثة',
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'جلسات التعليم',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              _buildFirebaseSessions(currentUser?.uid, isTeaching: true),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  'جلسات التعلم',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              _buildFirebaseSessions(currentUser?.uid, isTeaching: false),
            ],
          ),
        ),
        floatingActionButton: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('requests')
              .where('receiverId', isEqualTo: currentUser?.uid)
              .where('status', isEqualTo: 'pending')
              .snapshots(),
          builder: (context, snapshot) {
            bool hasNewRequests = snapshot.hasData && snapshot.data!.docs.isNotEmpty;

            return Stack(
              clipBehavior: Clip.none,
              children: [
                FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RequestsPage()),
                    );
                  },
                  backgroundColor: primaryColor,
                  label: const Text(
                    'الطلبات',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                if (hasNewRequests)
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 14,
                        minHeight: 14,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: primaryColor,
          unselectedItemColor: Colors.grey,
          currentIndex: 2,
          backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          onTap: (index) {
            if (index == 0) Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
            if (index == 1) Navigator.push(context, MaterialPageRoute(builder: (context) => const Leaderboard()));
            if (index == 2) return;
            if (index == 3) Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
            if (index == 4) Navigator.push(context, MaterialPageRoute(builder: (context) => const Setting()));
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
            BottomNavigationBarItem(icon: Icon(Icons.star_outline), label: 'لوحة الصدارة'),
            BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'المحادثة'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'الملف الشخصي'),
            BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'الاعدادات'),
          ],
        ),
      ),
    );
  }

  Widget _buildFirebaseSessions(String? userId, {required bool isTeaching}) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('requests')
          .where(isTeaching ? 'receiverId' : 'senderId', isEqualTo: userId)
          .where('status', isEqualTo: 'accepted')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(20.0),
            child: Center(child: CircularProgressIndicator(color: primaryColor)),
          );
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text("لا توجد جلسات حالية ", style: TextStyle(color: Colors.grey, fontSize: 14)),
          );
        }

        return Column(
          children: snapshot.data!.docs.map((doc) {
            var data = doc.data() as Map<String, dynamic>;
            String targetUserId = isTeaching ? data['senderId'] : data['receiverId'];

            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection('users').doc(targetUserId).get(),
              builder: (context, userSnap) {
                String name = "مستخدم تلاقِ";
                String image = 'https://i.pravatar.cc/150';

                if (userSnap.hasData && userSnap.data!.exists) {
                  var userData = userSnap.data!.data() as Map<String, dynamic>;
                  name = userData['name'] ?? name;
                  image = userData['profilePic'] ?? image;
                }

                return _buildSessionCard(
                  context,
                  data['skillTitle'] ?? "مهارة تلاقِ",
                  isTeaching ? "للمتعلم: $name" : "بواسطة: $name",
                  image,
                  doc.id,
                );
              },
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildSessionCard(BuildContext context, String title, String subtitle, String imageUrl, String requestId) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    String cleanName = subtitle.replaceFirst('للمتعلم: ', '').replaceFirst('بواسطة: ', '');

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              userName: cleanName,
              userImage: imageUrl,
              skillTitle: title,
              requestId: requestId,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
              backgroundImage: NetworkImage(imageUrl),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: isDark ? Colors.grey[400] : Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: primaryColor),
          ],
        ),
      ),
    );
  }
}
