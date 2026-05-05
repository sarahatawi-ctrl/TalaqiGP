import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; 
import 'AchievementBadges.dart';
import 'home.dart';
import 'Setting.dart';
import 'UserProfile.dart';
import 'profile.dart';
import 'allRequests.dart';

class Leaderboard extends StatelessWidget {
  const Leaderboard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final String? currentUserId = FirebaseAuth.instance.currentUser?.uid; 

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const AchievementBadges()));
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.military_tech, color: Colors.white, size: 20),
                                  SizedBox(width: 8),
                                  Text('الأوسمة', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
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
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .orderBy('teachingHours', descending: true)
              .limit(40)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Color(0xFF2E4365)));
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("لا توجد بيانات حالياً ✨"));
            }

            var filteredDocs = snapshot.data!.docs.where((doc) {
              var data = doc.data() as Map<String, dynamic>;
              bool isBanned = data['isBanned'] ?? false;
              num hours = data['teachingHours'] ?? 0;
              return isBanned == false && hours > 0;
            }).take(20).toList();

            if (filteredDocs.isEmpty) {
              return const Center(child: Text("لا توجد بيانات حالياً ✨"));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: filteredDocs.length,
              itemBuilder: (context, index) {
                var data = filteredDocs[index].data() as Map<String, dynamic>;
                String userIdInList = filteredDocs[index].id; 
                int rank = index + 1;
                
                String medal = 'none';
                if (rank == 1) medal = 'gold';
                else if (rank == 2) medal = 'silver';
                else if (rank == 3) medal = 'bronze';

                return LeaderboardCard(
                  name: data['name'] ?? 'مستخدم تلاقِ',
                  hours: (data['teachingHours'] ?? 0).toDouble(),
                  rank: rank,
                  imageUrl: (data['profilePic'] != null && data['profilePic'] != "") 
                      ? data['profilePic'] 
                      : 'https://ui-avatars.com/api/?name=${data['name'] ?? "User"}&background=random',
                  medalType: medal,
                  userId: userIdInList,
                  isCurrentUser: userIdInList == currentUserId, 
                );
              },
            );
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: isDark ? Colors.white : const Color(0xFF1A237E),
          unselectedItemColor: Colors.grey,
          backgroundColor: Theme.of(context).cardColor,
          currentIndex: 1,
          onTap: (index) {
            if (index == 0) Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
            if (index == 1) return; 
            if (index == 2) Navigator.push(context, MaterialPageRoute(builder: (context) => const allRequests()));
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
}

class LeaderboardCard extends StatelessWidget {
  final String name;
  final double hours;
  final int rank;
  final String imageUrl;
  final String medalType;
  final String userId;
  final bool isCurrentUser; 

  const LeaderboardCard({
    super.key,
    required this.name,
    required this.hours,
    required this.rank,
    required this.imageUrl,
    required this.medalType,
    required this.userId,
    required this.isCurrentUser,
  });

  Color _getMedalColor(String type) {
    switch (type) {
      case 'gold': return const Color(0xFFFFD700);
      case 'silver': return const Color(0xFFC0C0C0);
      case 'bronze': return const Color(0xFFCD7F32);
      default: return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    bool isTopThree = rank <= 3;

    return GestureDetector(
      onTap: () {
        if (isCurrentUser) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfilePage()),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserProfile(
                ownerId: userId, 
                userName: name,
                userImage: imageUrl,
              ),
            ),
          );
        }
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 12.0),
        elevation: 2,
        color: isCurrentUser 
            ? (isDark ? Colors.blueGrey.withOpacity(0.3) : Colors.blue.withOpacity(0.05))
            : Theme.of(context).cardColor, 
        shadowColor: isDark ? Colors.black45 : Colors.grey.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
          side: isCurrentUser 
              ? const BorderSide(color: Color(0xFF2E4365), width: 1.5) 
              : BorderSide.none,
        ),
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
                    color: isTopThree 
                        ? (isDark ? Colors.white : const Color(0xFF2E4365)) 
                        : (isDark ? Colors.white38 : Colors.grey.shade600),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              CircleAvatar(
                radius: 28,
                backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
                backgroundImage: NetworkImage(imageUrl),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name, 
                      style: TextStyle(
                        fontWeight: FontWeight.bold, 
                        fontSize: 18, 
                        color: isDark ? Colors.white : const Color(0xFF333333)
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${hours.toStringAsFixed(1)} ساعة تعليمية',
                      style: TextStyle(
                        fontSize: 14, 
                        color: isDark ? Colors.white60 : const Color(0xFF888888)
                      ),
                    ),
                  ],
                ),
              ),
              if (isTopThree)
                Icon(
                  Icons.military_tech,
                  color: _getMedalColor(medalType),
                  size: 30,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
