import 'package:flutter/material.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Leaderboard',
      theme: ThemeData(
         primaryColor: const Color(0xFF2E4365),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const LeaderboardPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  //volunteers
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
          preferredSize: const Size.fromHeight(120.0), 
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                            onPressed: () {
                            
                            },
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF4D03F), 
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'لوحة الصدارة',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 48), 
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'متطوعين الشهر:',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
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
            //Medal Icon
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
            //Profile Picture
            CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(imageUrl),
            ),
            const SizedBox(width: 16),
            //Name and Hours
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
            //Rank Number
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
