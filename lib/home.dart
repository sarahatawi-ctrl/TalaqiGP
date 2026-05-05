import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'package:firebase_auth/firebase_auth.dart';    
import 'Leaderboard.dart';
import 'Setting.dart';
import 'CreateSkillPage.dart';
import 'SkillDetailsPage.dart'; 
import 'profile.dart';
import 'allRequests.dart';
import 'login_forget_pass.dart'; 

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = ""; 

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() { _searchQuery = _searchController.text.toLowerCase(); });
    });
    _listenToAdminActions();
  }

  void _listenToAdminActions() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      
      
      if (currentUser.email == "admin-talaqi@gmail.com") return;

      FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .snapshots()
          .listen((snapshot) {
        
        if (!mounted) return;

        if (snapshot.exists) {
          var userData = snapshot.data() as Map<String, dynamic>;
          
          bool isBanned = userData['isBanned'] ?? false;
          bool hasWarning = userData['hasWarning'] ?? false;

          if (isBanned) {
            _handleBan();
          } else if (hasWarning) {
            _showWarningDialog(userData['warningMessage'] ?? "تنبيه رسمي من تـلاق", currentUser.uid);
          }
        }
      });
    }
  }

  void _handleBan() {
    FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("تم حظر حسابك لمخالفة القوانين"),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showWarningDialog(String message, String userId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("⚠️ تنبيه من تـلاق", textAlign: TextAlign.center, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        content: Text(message, textAlign: TextAlign.center),
        actions: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2E4365)),
              onPressed: () async {
                await FirebaseFirestore.instance.collection('users').doc(userId).update({
                  'hasWarning': false,
                });
                Navigator.pop(context);
              },
              child: const Text("فهمت سألتزم بالقوانين", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentUser = FirebaseAuth.instance.currentUser;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance.collection('users').doc(currentUser?.uid).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!.exists) {
                    var userData = snapshot.data!.data() as Map<String, dynamic>;
                    if (userData['isProfileComplete'] == false) {
                      return _buildCompleteProfileBanner(context, userData['name'] ?? "");
                    }
                  }
                  return const SizedBox.shrink();
                },
              ),

              const SizedBox(height: 10),
            
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: isDark ? Colors.black26 : Colors.black.withOpacity(0.05),
                        blurRadius: 10
                      )
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 18, color: isDark ? Colors.white : Colors.black),
                    decoration: InputDecoration(
                      hintText: 'بحث في المهارات أو الأشخاص...',
                      hintStyle: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey),
                      prefixIcon: Icon(Icons.search, color: isDark ? Colors.grey[400] : Colors.grey),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('skills').orderBy('createdAt', descending: true).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text("لا توجد مهارات مضافة بعد"));
                    }

                    var docs = snapshot.data!.docs.where((doc) {
                      var data = doc.data() as Map<String, dynamic>;
                      String title = (data['title'] ?? "").toString().toLowerCase();
                      String ownerName = (data['ownerName'] ?? "").toString().toLowerCase();
                      
                      bool isBanned = data.containsKey('isBanned') ? data['isBanned'] : false;

                      if (title.isEmpty) return false;
                      return (title.contains(_searchQuery) || ownerName.contains(_searchQuery)) && isBanned == false;
                    }).toList();

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        var data = docs[index].data() as Map<String, dynamic>;
                        return _buildCard(
                          context, 
                          data['title'] ?? "", 
                          data['ownerName'] ?? "مستخدم تلاقِ", 
                          data['ownerImage'] ?? "assets/avatar1.png", 
                          data['ownerId'] ?? "",
                          data['description'] ?? "لا يوجد وصف متوفر" 
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateSkillScreen()));
          },
          backgroundColor: const Color(0xFF2E4365),
          child: const Icon(Icons.add, color: Colors.white, size: 30),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: isDark ? Colors.white : const Color(0xFF1A237E),
          unselectedItemColor: Colors.grey,
          backgroundColor: Theme.of(context).cardColor,
          currentIndex: 0,
          onTap: (index) {
            if (index == 0) return; 
            if (index == 1) Navigator.push(context, MaterialPageRoute(builder: (context) => const Leaderboard()));
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

  Widget _buildCompleteProfileBanner(BuildContext context, String name) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE082).withOpacity(0.3),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFFFE082)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Colors.orange),
          const SizedBox(width: 10),
          Expanded(child: Text("يا هلا يا $name! اكمل ملفك لتظهر مهاراتك ✨", style: const TextStyle(fontSize: 13))),
          TextButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilePage())),
            child: const Text("تعديل"),
          )
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, String name, String imageUrl, String userId, String description) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SkillDetailsPage( 
              ownerName: name,
              ownerImage: imageUrl,
              skillTitle: title,
              skillDescription: description,
              ownerId: userId,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor, 
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black26 : Colors.black.withOpacity(0.05),
              blurRadius: 10
            )
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 35, 
              backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200], 
              backgroundImage: imageUrl.startsWith('assets') 
                  ? AssetImage(imageUrl) as ImageProvider
                  : NetworkImage(imageUrl),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: isDark ? Colors.white : Colors.black)),
                  const SizedBox(height: 4),
                  Text(name, style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey, fontSize: 16)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
