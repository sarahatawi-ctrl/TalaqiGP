import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RequestsPage extends StatefulWidget {
  const RequestsPage({super.key});

  @override
  State<RequestsPage> createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> {
  static const Color primaryColor = Color(0xFF2E4365);
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: isDark ? Colors.transparent : Colors.white,
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text(
            'الطلبات',
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.arrow_forward_ios, color: isDark ? Colors.white : primaryColor, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(width: 10),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'طلبات التعليم',
                style: TextStyle(
                  color: isDark ? Colors.white : primaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 25),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('requests')
                      .where('receiverId', isEqualTo: currentUser?.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: primaryColor));
                    }
                    
                    var allDocs = snapshot.data?.docs ?? [];
                    var pendingDocs = allDocs.where((doc) => doc['status'] == 'pending').toList();

                    if (pendingDocs.isEmpty) {
                      return const Center(child: Text("لا توجد طلبات تعليم حالياً ✨"));
                    }

                    return ListView.builder(
                      itemCount: pendingDocs.length,
                      itemBuilder: (context, index) {
                        var doc = pendingDocs[index];
                        var data = doc.data() as Map<String, dynamic>;
                        String senderId = data['senderId'] ?? "";

                        return FutureBuilder<DocumentSnapshot>(
                          key: ValueKey(doc.id), 
                          future: FirebaseFirestore.instance.collection('users').doc(senderId).get(),
                          builder: (context, userSnapshot) {
                            String senderName = "مستخدم تلاقِ";
                            String senderImage = 'https://i.pravatar.cc/150';

                            if (userSnapshot.hasData && userSnapshot.data!.exists) {
                              var userData = userSnapshot.data!.data() as Map<String, dynamic>;
                              senderName = userData['name'] ?? senderName;
                              senderImage = userData['profilePic'] ?? senderImage;
                            }

                            return RequestCard(
                              key: ValueKey(doc.id), 
                              requestId: doc.id,
                              skillName: data['skillTitle'] ?? "مهارة",
                              senderName: senderName,
                              senderImage: senderImage,
                              isDark: isDark,
                              primaryColor: primaryColor,
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RequestCard extends StatefulWidget {
  final String requestId;
  final String skillName;
  final String senderName;
  final String senderImage;
  final bool isDark;
  final Color primaryColor;

  const RequestCard({
    super.key,
    required this.requestId,
    required this.skillName,
    required this.senderName,
    required this.senderImage,
    required this.isDark,
    required this.primaryColor,
  });

  @override
  State<RequestCard> createState() => _RequestCardState();
}

class _RequestCardState extends State<RequestCard> {
  String localStatus = "pending"; 

  Future<void> _updateStatus(String newStatus) async {
    setState(() => localStatus = newStatus); 

    try {
      await FirebaseFirestore.instance
          .collection('requests')
          .doc(widget.requestId)
          .update({'status': newStatus});
    } catch (e) {
      print("Error updating status: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: widget.isDark ? Colors.black26 : Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.skillName,
            style: TextStyle(color: widget.isDark ? Colors.grey[400] : Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundImage: NetworkImage(widget.senderImage),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  widget.senderName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: widget.isDark ? Colors.white : Colors.black,
                  ),
                ),
              ),
              if (localStatus == "pending") ...[
                IconButton(
                  icon: Icon(Icons.close, color: widget.isDark ? Colors.red[300] : Colors.red),
                  onPressed: () => _updateStatus("rejected"),
                ),
                IconButton(
                  icon: Icon(Icons.check, color: widget.isDark ? Colors.green[300] : Colors.green),
                  onPressed: () => _updateStatus("accepted"),
                ),
              ] else
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: localStatus == "accepted"
                        ? Colors.green.withOpacity(0.15)
                        : Colors.red.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    localStatus == "accepted" ? "مقبول" : "مرفوض",
                    style: TextStyle(
                      color: localStatus == "accepted" ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

