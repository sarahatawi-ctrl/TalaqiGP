import 'package:flutter/material.dart';
import 'main.dart';
import 'requests_page.dart'; 

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('الدردشة', 
          style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RequestsPage()),
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text('الطلبات', style: TextStyle(color: Colors.grey, fontSize: 16)),
                  SizedBox(width: 5),
                  Icon(Icons.arrow_back_ios, size: 14, color: Colors.grey),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text('جلسات التعليم', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          _buildSessionCard('كروشيه', 'هند', 'assets/greenProfileIcon.png'), 
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text('جلسات التعلم', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          _buildSessionCard('تصميم واجهات', 'بواسطة محمد احمد', 'assets/user1.png'),
          _buildSessionCard('البرمجة', 'بواسطة شذى محمد', 'assets/user2.png'),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF1A237E),
        unselectedItemColor: Colors.grey,
        currentIndex: 2, 
        onTap: (index) {
          if (index == 4) { 
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'الإعدادات'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'الملف الشخصي'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'الدردشة'),
          BottomNavigationBarItem(icon: Icon(Icons.star_border), label: 'لوحة الصدارة'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسي'),
        ],
      ),
    );
  }

  Widget _buildSessionCard(String title, String subtitle, String imagePath) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blueGrey.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.grey[200],
            backgroundImage: AssetImage(imagePath),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.arrow_back_ios, size: 16, color: Colors.black),
        ],
      ),
    );
  }
}
