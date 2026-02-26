import 'package:flutter/material.dart';
import 'BadgesScreen.dart'; 
class Leaderboard extends StatelessWidget {
  const Leaderboard({super.key});
  final List<Map<String, dynamic>> volunteers = const [
    {
      'name': 'مهند', 
      'hours': 60,
      'rank': 1,
      'image': 'https://via.placeholder.com/150/FFD700/000000?text=1',
      'medal': 'gold'
    },
    {
      'name': 'سديم',
      'hours': 56,
      'rank': 2,
      'image': 'https://via.placeholder.com/150/C0C0C0/000000?text=2',
      'medal': 'silver'
    },
    {
      'name': 'نورة', 
      'hours': 48,
      'rank': 3,
      'image': 'https://via.placeholder.com/150/CD7F32/000000?text=3',
      'medal': 'bronze'
    },
    {
      'name': 'مشعل',
      'hours': 36,
      'rank': 4,
      'image': 'https://via.placeholder.com/150/CCCCCC/000000?text=4',
      'medal': 'none'
    },
    {
      'name': 'محمد',
      'hours': 36,
      'rank': 5,
      'image': 'https://via.placeholder.com/150/CCCCCC/000000?text=5',
      'medal': 'none'
    },
    {
      'name': 'شذا',
      'hours': 30,
      'rank': 6,
      'image': 'https://via.placeholder.com/150/CCCCCC/000000?text=6',
      'medal': 'none'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF0F2F5), 
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(150.0), 
          child: AppBar(
            automaticallyImplyLeading: false, 
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF4A6FA5), Color(0xFF5B7FB8)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.elliptical(300, 50), 
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const BadgesScreen()));
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2), 
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.white.withOpacity(0.5), width: 1),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(Icons.military_tech, color: Colors.white, size: 20),
                                  SizedBox(width: 8),
                                  Text(
                                    'الأوسمة',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
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
                            Text(
                              'لوحة الصدارة',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'متطوعين الشهر:',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
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
      case 'gold':
        return const Color(0xFFFFD700);
      case 'silver':
        return const Color(0xFFC0C0C0);
      case 'bronze':
        return const Color(0xFFCD7F32);
      default:
        return const Color(0xFFCCCCCC); 
    }
  }

  IconData _getMedalIcon(String type) {
    switch (type) {
      case 'gold':
        return Icons.emoji_events; 
      case 'silver':
        return Icons.emoji_events; 
      case 'bronze':
        return Icons.emoji_events; 
      default:
        return Icons.star; 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _getMedalColor(medalType),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getMedalIcon(medalType),
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(imageUrl),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFF333333),
                    ),
                  ),
                  Text(
                    '$hours ساعة تطوعية',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF999999),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 24,
              height: 24,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: Text(
                '$rank',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
