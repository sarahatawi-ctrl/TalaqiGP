import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'package:firebase_auth/firebase_auth.dart';    
import 'UserProfile.dart'; 
import 'profile.dart'; 

class SkillDetailsPage extends StatefulWidget {
  final String skillTitle;
  final String skillDescription;
  final String ownerName;
  final String ownerImage;
  final String ownerId;

  const SkillDetailsPage({
    super.key,
    required this.skillTitle,
    required this.skillDescription,
    required this.ownerName,
    required this.ownerImage,
    required this.ownerId,
  });

  @override
  State<SkillDetailsPage> createState() => _SkillDetailsPageState();
}

class _SkillDetailsPageState extends State<SkillDetailsPage> {
  bool _isSending = false; 

  Future<void> _sendRequest() async {
    setState(() => _isSending = true);
    final currentUser = FirebaseAuth.instance.currentUser;

    try {
      await FirebaseFirestore.instance.collection('requests').add({
        'senderId': currentUser?.uid,
        'receiverId': widget.ownerId,
        'skillTitle': widget.skillTitle,
        'status': 'pending', 
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        setState(() => _isSending = false);
        _showSuccessDialog();
      }
    } catch (e) {
      setState(() => _isSending = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("حدث خطأ أثناء إرسال الطلب: $e")),
      );
    }
  }

 
  Future<void> _deleteSkill() async {
    try {
     
      var skillSnapshot = await FirebaseFirestore.instance
          .collection('skills')
          .where('ownerId', isEqualTo: widget.ownerId)
          .where('title', isEqualTo: widget.skillTitle)
          .get();

      for (var doc in skillSnapshot.docs) {
        await doc.reference.delete();
      }

     
      var requestSnapshot = await FirebaseFirestore.instance
          .collection('requests')
          .where('skillTitle', isEqualTo: widget.skillTitle)
          .where('receiverId', isEqualTo: widget.ownerId)
          .where('status', isEqualTo: 'pending') 
          .get();

      for (var doc in requestSnapshot.docs) {
        await doc.reference.delete();
      }

      if (mounted) {
       
        Navigator.of(context, rootNavigator: true).pop(); 
        Navigator.pop(context); 
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("تم حذف المهارة ✨")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("خطأ في الحذف: $e")),
      );
    }
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("تأكيد الحذف"),
        content: const Text("هل أنت متأكد من حذف هذه المهارة؟."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("إلغاء")),
          TextButton(
            onPressed: _deleteSkill,
            child: const Text("حذف", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const Color primaryNavy = Color(0xFF2E4365);

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
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
            const SizedBox(height: 25),
            TextButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop(); 
                Navigator.pop(context); 
              },
              child: const Text(
                "موافق",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryNavy),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryNavy = Color(0xFF2E4365);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentUser = FirebaseAuth.instance.currentUser;
    bool isMySkill = widget.ownerId == currentUser?.uid;

    return Directionality(
      textDirection: TextDirection.rtl, 
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: isDark ? Colors.white : Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            if (isMySkill)
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                onPressed: _showDeleteDialog,
              ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  if (isMySkill) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserProfile(
                          userName: widget.ownerName,
                          userImage: widget.ownerImage,
                          skillTitle: widget.skillTitle,
                          ownerId: widget.ownerId,
                        ),
                      ),
                    );
                  }
                },
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
                      backgroundImage: widget.ownerImage.startsWith('assets') 
                          ? AssetImage(widget.ownerImage) as ImageProvider
                          : NetworkImage(widget.ownerImage),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.ownerName,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.skillTitle, 
                            style: const TextStyle(
                              fontSize: 16,
                              color: primaryNavy,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade100),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "تفاصيل المهارة:",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.skillDescription,
                      style: TextStyle(
                        fontSize: 17,
                        color: isDark ? Colors.white70 : Colors.black87,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 60),
              SizedBox(
                width: 200, 
                height: 54,
                child: isMySkill 
                  ? const Center(
                      child: Text(
                        "✨هذه مهارتك ",
                        style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    )
                  : StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('requests')
                          .where('senderId', isEqualTo: currentUser?.uid)
                          .where('receiverId', isEqualTo: widget.ownerId)
                          .where('skillTitle', isEqualTo: widget.skillTitle)
                          .where('status', isEqualTo: 'pending')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                          return Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                "قيد الانتظار... ✨",
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          );
                        }
                        return ElevatedButton(
                          onPressed: _isSending ? null : _sendRequest,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryNavy,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            elevation: 3,
                          ),
                          child: _isSending
                              ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                              : const Text(
                                  'إرسال طلب ',
                                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                        );
                      },
                    ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
