import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'UserProfile.dart'; 
import 'login_forget_pass.dart';

class TalaqiAdmin extends StatelessWidget {
  const TalaqiAdmin({super.key});

  static const Color primary = Color(0xFF344966);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: primary,
            centerTitle: true,
            automaticallyImplyLeading: false, 
            leading: IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (route) => false,
                  );
                }
              },
            ),
            title: const Text(
              "متابعة البلاغات",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            bottom: const TabBar(
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              tabs: [
                Tab(text: "بلاغات جديدة", icon: Icon(Icons.new_releases)),
                Tab(text: "تمت معالجتها", icon: Icon(Icons.history)),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              _buildReportList('pending'), 
              _buildReportList('processed'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReportList(String tabType) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('reports')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: primary));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("لا توجد بلاغات "));
        }

        var docs = snapshot.data!.docs.where((doc) {
          var data = doc.data() as Map<String, dynamic>;
          var status = data['status'] ?? 'pending';
          if (tabType == 'pending') {
            return status == 'pending';
          } else {
            return status == 'reviewed' || status == 'action_taken';
          }
        }).toList();

        if (docs.isEmpty) {
          return Center(child: Text(tabType == 'pending' ? "لا توجد بلاغات جديدة" : "السجل فارغ"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            var reportData = docs[index].data() as Map<String, dynamic>;
            return _reportCard(context, reportData, docs[index].id);
          },
        );
      },
    );
  }

  Widget _reportCard(BuildContext context, Map report, String docId) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc(report['reportedUserId']).get(),
      builder: (context, userSnapshot) {
        String name = "مستخدم تلاقِ";
        String image = ""; 

        if (userSnapshot.hasData && userSnapshot.data!.exists) {
          var userData = userSnapshot.data!.data() as Map<String, dynamic>;
          name = userData['name'] ?? "مستخدم بدون اسم";
          image = userData['profilePic'] ?? userData['userImage'] ?? ""; 
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(color: Colors.grey.shade200, blurRadius: 5, offset: const Offset(0, 3)),
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: primary.withOpacity(0.1),
                backgroundImage: image.isNotEmpty ? NetworkImage(image) : null,
                child: image.isEmpty ? const Icon(Icons.person, color: primary) : null,
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (_) => UserProfile(
                              ownerId: report['reportedUserId'],
                              userName: name,
                              userImage: image,
                            )
                          )
                        );
                      },
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "السبب: ${report['reason']}",
                      style: const TextStyle(color: Colors.redAccent, fontSize: 13),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_outlined, color: primary, size: 18),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ReportDetailsPage(
                        reportData: report,
                        userName: name,
                        userImage: image,
                        docId: docId,
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        );
      },
    );
  }
}

class ReportDetailsPage extends StatelessWidget {
  final Map reportData;
  final String userName;
  final String userImage;
  final String docId;

  const ReportDetailsPage({
    super.key,
    required this.reportData,
    required this.userName,
    required this.userImage,
    required this.docId,
  });

  static const Color primary = Color(0xFF344966);

  Future<void> _handleAction(BuildContext context, String actionType) async {
    final String targetUserId = reportData['reportedUserId'];
    final String? adminId = FirebaseAuth.instance.currentUser?.uid;

    if (targetUserId == adminId) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("لا يمكنك حظر نفسك!")));
      return;
    }

    WriteBatch batch = FirebaseFirestore.instance.batch();
    final reportsRef = FirebaseFirestore.instance.collection('reports').doc(docId);
    final userRef = FirebaseFirestore.instance.collection('users').doc(targetUserId);

    try {
      if (actionType == "ignore") {
        batch.update(reportsRef, {'status': 'reviewed'});
        await batch.commit();
        if (context.mounted) showPopup(context, "تم تجاهل البلاغ ");
      } 
      else if (actionType == "warn") {
        batch.update(userRef, {
          'hasWarning': true,
          'warningMessage': "تنبيه من الإدارة: تم رصد مخالفة بخصوص (${reportData['reason']}). يرجى الالتزام بالقوانين.",
        });
        batch.update(reportsRef, {'status': 'reviewed'});
        await batch.commit();
        if (context.mounted) showPopup(context, "تم إرسال تنبيه للمستخدم ");
      } 
      else if (actionType == "ban") {
        batch.update(userRef, {'isBanned': true});
        
        
        var userSkills = await FirebaseFirestore.instance.collection('skills').where('ownerId', isEqualTo: targetUserId).get();
        for (var doc in userSkills.docs) { batch.delete(doc.reference); }

        var userRequests = await FirebaseFirestore.instance.collection('requests').where('providerId', isEqualTo: targetUserId).get();
        for (var doc in userRequests.docs) { batch.delete(doc.reference); }
        
        var userRequestsAsRequester = await FirebaseFirestore.instance.collection('requests').where('requesterId', isEqualTo: targetUserId).get();
        for (var doc in userRequestsAsRequester.docs) { batch.delete(doc.reference); }

        batch.update(reportsRef, {'status': 'action_taken'});
        await batch.commit();
        
        if (context.mounted) showPopup(context, "تم حظر المستخدم ");
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("حدث خطأ: $e")));
      }
    }
  }

  void showPopup(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_outline, size: 70, color: primary),
            const SizedBox(height: 15),
            Text(message, style: const TextStyle(fontSize: 18), textAlign: TextAlign.center),
            const SizedBox(height: 25),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop(); 
                Navigator.of(context).pop(); 
              },
              child: const Text("موافق", style: TextStyle(color: primary, fontWeight: FontWeight.bold, fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: primary,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text("تفاصيل البلاغ", style: TextStyle(color: Colors.white)),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: primary.withOpacity(0.1),
                  backgroundImage: userImage.isNotEmpty ? NetworkImage(userImage) : null,
                  child: userImage.isEmpty ? const Icon(Icons.person, size: 60, color: primary) : null,
                ),
              ),
              const SizedBox(height: 20),
              Text(userName, textAlign: TextAlign.center, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              _infoBox("سبب البلاغ", reportData["reason"] ?? "لا يوجد"),
              _infoBox("تفاصيل إضافية", reportData["details"] ?? "لا توجد تفاصيل"),
              const SizedBox(height: 20),
              reportData['status'] == 'pending'
              ? Row(
                  children: [
                    Expanded(child: _actionBtn(context, "تجاهل", Colors.grey, "ignore")),
                    const SizedBox(width: 10),
                    Expanded(child: _actionBtn(context, "تنبيه", primary, "warn")),
                    const SizedBox(width: 10),
                    Expanded(child: _actionBtn(context, "حظر", Colors.red, "ban")),
                  ],
                )
              : Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(15)),
                  child: const Text(" تمت معالجة هذا البلاغ✅", textAlign: TextAlign.center, style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoBox(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primary)),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(15)),
          child: Text(value, style: const TextStyle(fontSize: 16)),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _actionBtn(BuildContext context, String label, Color color, String action) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: color, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
      onPressed: () => _handleAction(context, action),
      child: Text(label),
    );
  }
}
