import 'package:flutter/material.dart';
import 'RequestsPage.dart';
import 'HomePage.dart';
import 'Leaderboard.dart';
import 'Setting.dart';

class allRequests extends StatelessWidget {
  const allRequests({super.key});

  static const Color primaryColor = Color(0xFF2E4365);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F6F3),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            'المحادثة',
            style: TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'جلسات التعليم',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            _buildSessionCard('كروشيه', 'هند', 'https://i.pravatar.cc/150?u=green' ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'جلسات التعلم',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            _buildSessionCard('تصميم واجهات', 'بواسطة محمد احمد', 'https://i.pravatar.cc/150?u=user1' ),
            _buildSessionCard('البرمجة', 'بواسطة شذى محمد', 'https://i.pravatar.cc/150?u=user2' ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: primaryColor,
          unselectedItemColor: Colors.grey,
          currentIndex: 2,
          onTap: (index) {
            if (index == 0) Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
            if (index == 1) Navigator.push(context, MaterialPageRoute(builder: (context) => const Leaderboard()));
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

  Widget _buildSessionCard(String title, String subtitle, String imageUrl) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: Colors.grey[200],
            backgroundImage: NetworkImage(imageUrl),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16, color: primaryColor),
        ],
      ),
    );
  }
}
