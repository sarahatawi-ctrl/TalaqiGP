import 'package:flutter/material.dart';
import 'BadgesScreen.dart';
import 'home.dart';
import 'Setting.dart';

class Leaderboard extends StatelessWidget {
  const Leaderboard({super.key});
  final List<Map<String, dynamic>> volunteers = const [
    {'name': 'نورة', 'hours': 60, 'rank': 1, 'image': 'https://i.pravatar.cc/150?u=a042581f4e29026704d', 'medal': 'gold'},
    {'name': 'مهند', 'hours': 56, 'rank': 2, 'image': 'https://i.pravatar.cc/150?u=a042581f4e29026704e', 'medal': 'silver'},
    {'name': 'رنا', 'hours': 48, 'rank': 3, 'image': 'https://i.pravatar.cc/150?u=a042581f4e29026704f', 'medal': 'bronze'},
    {'name': 'مشعل', 'hours': 36, 'rank': 4, 'image': 'https://i.pravatar.cc/150?u=a042581f4e29026704a', 'medal': 'none'},
    {'name': 'شذا', 'hours': 36, 'rank': 5, 'image': 'https://i.pravatar.cc/150?u=a042581f4e29026704b', 'medal': 'none'},
    {'name': 'محمد', 'hours': 30, 'rank': 6, 'image': 'https://i.pravatar.cc/150?u=a042581f4e29026704c', 'medal': 'none'},
  ];

  @override
  Widget build(BuildContext context  ) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F6F3),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(150.0),
          child: AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF2E4365), Color(0xFF2E4365)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const BadgesScreen()));
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: const [
                                  Icon(Icons.military_tech, color: Colors.white, size: 20),
                                  SizedBox(width: 8),
                                  Text('الأوسمة', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text('لوحة الصدارة', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),
                            SizedBox(height: 4),
                            Text('متطوعين الشهر', style: TextStyle(color: Colors.white70, fontSize: 18)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: volunteers.length,
          itemBuilder: (context, index) {
            final volunteer = volunteers[index];
            return LeaderboardCard(
              name: volunteer['name']!,
              hours: volunteer['hours']!,
              rank: volunteer['rank']!,
              imageUrl: volunteer['image']!,
              medalType: volunteer['medal']!,
            );
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF1A237E),
          unselectedItemColor: Colors.grey,
          currentIndex: 1,
          onTap: (index) {
            if (index == 0) Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
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
}

class LeaderboardCard extends StatelessWidget {
  final String name;
  final int hours;
  final int rank;
  final String imageUrl;
  final String medalType;

  const LeaderboardCard({
    super.key,
    required this.name,
    required this.hours,
    required this.rank,
    required this.imageUrl,
    required this.medalType,
  });

  Color _getMedalColor(String type) {
    switch (type) {
      case 'gold': return const Color(0xFFFFD700);
      case 'silver': return const Color(0xFFC0C0C0);
      case 'bronze': return const Color(0xFFCD7F32);
      default: return Colors.transparent;
    }
  }

  IconData _getMedalIcon(String type) {
    return type != 'none' ? Icons.military_tech : Icons.star_border;
  }

  @override
  Widget build(BuildContext context) {
    bool isTopThree = rank <= 3;
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      elevation: 2,
      shadowColor: Colors.grey.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              width: 40,
              alignment: Alignment.center,
              child: Text(
                '$rank',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isTopThree ? const Color(0xFF2E4365) : Colors.grey.shade600,
                ),
              ),
            ),
            const SizedBox(width: 12),
            CircleAvatar(
              radius: 28,
              backgroundImage: NetworkImage(imageUrl),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF333333)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$hours ساعة تطوعية',
                    style: const TextStyle(fontSize: 14, color: Color(0xFF888888)),
                  ),
                ],
              ),
            ),
            if (isTopThree)
              Icon(
                _getMedalIcon(medalType),
                color: _getMedalColor(medalType),
                size: 30,
              ),
          ],
        ),
      ),
    );
  }
}
