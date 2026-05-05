import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'ReportPage.dart';
import 'home.dart';
import 'Leaderboard.dart';
import 'Setting.dart';
import 'profile.dart';
import 'allRequests.dart';

class UserProfile extends StatefulWidget {
  final String? userName;
  final String? userImage;
  final String? skillTitle;
  final String? ownerId; 

  const UserProfile({
    super.key,
    this.userName,
    this.userImage,
    this.skillTitle,
    this.ownerId,
  });

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  bool _isSending = false;

 
  Future<void> _sendRequest() async {
    setState(() => _isSending = true);
    final currentUser = FirebaseAuth.instance.currentUser;

    try {
      await FirebaseFirestore.instance.collection('requests').add({
        'senderId': currentUser?.uid,
        'receiverId': widget.ownerId,
        'skillTitle': widget.skillTitle ?? "تواصل ",
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        setState(() => _isSending = false);
        showSuccessDialog();
      }
    } catch (e) {
      setState(() => _isSending = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("خطأ: $e")));
    }
  }

  void showReportBottomSheet() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(25.0)),
          ),
         
          child: ReportPage(reportedUserId: widget.ownerId ?? ""), 
        );
      },
    );
  }

  void showSuccessDialog() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const Color primaryNavy = Color(0xFF344966);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            const Icon(Icons.check_circle_outline, size: 80, color: primaryNavy),
            const SizedBox(height: 25),
            Text(
              "تم إرسال الطلب ",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : primaryNavy,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "✨نتمنى لك رحلة تعلم ممتعة ومفيدة ",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: isDark ? Colors.white70 : Colors.black54),
            ),
            const SizedBox(height: 25),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("موافق", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryNavy)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryNavy = Color(0xFF344966);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('users').doc(widget.ownerId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: primaryNavy));
          }

          var userData = snapshot.data?.data() as Map<String, dynamic>? ?? {};
          String bio = userData['bio'] ?? "لا توجد نبذة تعريفية مضافة.";
          List<String> userSkills = List<String>.from(userData['skills'] ?? []);

          return SingleChildScrollView(
            child: Column(
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
                            IconButton(
                              icon: const Icon(Icons.report_gmailerrorred_outlined, color: Colors.white, size: 28),
                              onPressed: showReportBottomSheet,
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
                          backgroundImage: NetworkImage(widget.userImage ?? 'https://i.pravatar.cc/300?img=47'),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 60),
                Text(
                  widget.userName ?? 'مستخدم تلاقِ',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: isDark ? Colors.white : primaryNavy),
                ),
                const SizedBox(height: 15),
                
                
                SizedBox(
                  width: 220,
                  height: 50,
                  child: widget.ownerId == currentUser?.uid
                      ? const Center(child: Text("ملفك الشخصي ✨", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)))
                      : StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('requests')
                              .where('senderId', isEqualTo: currentUser?.uid)
                              .where('receiverId', isEqualTo: widget.ownerId)
                              .where('status', isEqualTo: 'pending')
                              .snapshots(),
                          builder: (context, reqSnapshot) {
                            if (reqSnapshot.hasData && reqSnapshot.data!.docs.isNotEmpty) {
                              return Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                  decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                                  child: const Text("قيد الانتظار... ✨", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                                ),
                              );
                            }

                            return ElevatedButton(
                              onPressed: _isSending ? null : _sendRequest,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryNavy,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              ),
                              child: _isSending
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : const Text('طلب تواصل ', style: TextStyle(color: Colors.white, fontSize: 18)),
                            );
                          },
                        ),
                ),

                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end, 
                    children: [
                      Text('نبذة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
                      const SizedBox(height: 10),
                      buildStaticBox(context: context, isDark: isDark, text: bio),
                      const SizedBox(height: 20),
                      Text('المهارات', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
                      const SizedBox(height: 10),
                      if (userSkills.isEmpty)
                        const Text("لا توجد مهارات مضافة.", textAlign: TextAlign.right) 
                      else
                        ...userSkills.map((skill) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: buildStaticBox(context: context, isDark: isDark, text: skill),
                            )),
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
        currentIndex: 4,
        onTap: (index) {
          if (index == 4) Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
          if (index == 3) Navigator.push(context, MaterialPageRoute(builder: (context) => const Leaderboard()));
          if (index == 2) Navigator.push(context, MaterialPageRoute(builder: (context) => const allRequests()));
          if (index == 1) Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
          if (index == 0) Navigator.push(context, MaterialPageRoute(builder: (context) => const Setting()));
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'الاعدادات'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'الملف الشخصي'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'المحادثة'),
          BottomNavigationBarItem(icon: Icon(Icons.star_outline), label: 'لوحة الصدارة'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
        ],
      ),
    );
  }

  Widget buildStaticBox({required BuildContext context, required bool isDark, required String text}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: isDark ? Colors.white10 : const Color(0xFFEEEEEE), width: 1.5),
      ),
      child: Text(
        text,
        textAlign: TextAlign.right, 
        style: TextStyle(fontSize: 16, color: isDark ? Colors.white70 : Colors.black87, height: 1.4),
      ),
    );
  }
}

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
