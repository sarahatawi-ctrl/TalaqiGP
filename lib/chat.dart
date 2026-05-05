import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final String? userName;
  final String? userImage;
  final String? skillTitle;
  final String requestId;

  const ChatScreen({
    super.key,
    this.userName,
    this.userImage,
    this.skillTitle,
    required this.requestId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser;
  late DateTime _entryTime;

  @override
  void initState() {
    super.initState();
    _entryTime = DateTime.now(); 
  }

  @override
  void dispose() {
    _saveSessionTime(); 
    _controller.dispose();
    super.dispose();
  }

 
  Future<void> _saveSessionTime() async {
    DateTime exitTime = DateTime.now();
    int minutesSpent = exitTime.difference(_entryTime).inMinutes;

    if (minutesSpent < 1) return; 

    try {
      await FirebaseFirestore.instance
          .collection('requests')
          .doc(widget.requestId)
          .update({
        'totalMinutes': FieldValue.increment(minutesSpent),
      });
    } catch (e) {
      debugPrint('Error saving session time: $e');
    }
  }

  void _sendTextMessage() async {
    if (_controller.text.trim().isNotEmpty) {
      String text = _controller.text.trim();
      _controller.clear();

      await FirebaseFirestore.instance
          .collection('requests')
          .doc(widget.requestId)
          .collection('messages')
          .add({
        'senderId': currentUser?.uid,
        'text': text,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  
  Future<void> _finalizeAndCloseSession() async {
    try {
      
      DateTime exitTime = DateTime.now();
      int currentMinutes = exitTime.difference(_entryTime).inMinutes;

      
      var docRef = FirebaseFirestore.instance.collection('requests').doc(widget.requestId);
      var doc = await docRef.get();
      if (!doc.exists) return;

      int previousMinutes = doc.data()?['totalMinutes'] ?? 0;
      int grandTotalMinutes = previousMinutes + currentMinutes;
      
     
      double totalHoursToAdd = grandTotalMinutes / 60.0;
      
      String? teacherId = doc.data()?['receiverId'];

      
      if (teacherId != null && currentUser?.uid == teacherId) {
        await FirebaseFirestore.instance.collection('users').doc(teacherId).update({
          'teachingHours': FieldValue.increment(totalHoursToAdd),
        });
      }

      
      await docRef.update({
        'status': 'completed',
        'totalMinutes': 0, 
      });

      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop(); 
        Navigator.pop(context); 
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("تم إنهاء الجلسة، شكرًا لعطائك! ✨"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      debugPrint('Error finalizing session: $e');
    }
  }

  void _showEndDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("إنهاء الجلسة التعليمية؟", textAlign: TextAlign.center),
        content: const Text(
          "هل انتهيت من تعليم المهارة بالكامل؟ سيتم حساب إجمالي الساعات وإغلاق المحادثة نهائياً.",
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("ليس الآن", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: _finalizeAndCloseSession,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E4365),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text("تأكيد وإنهاء", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E4365),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: (widget.userImage != null && widget.userImage!.startsWith('assets'))
                  ? AssetImage(widget.userImage!) as ImageProvider
                  : NetworkImage(widget.userImage ?? 'https://i.pravatar.cc/150'),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.userName ?? 'المستخدم',
                    style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                Text(widget.skillTitle ?? 'المهارة',
                    style: const TextStyle(color: Colors.white70, fontSize: 11)),
              ],
            ),
          ],
        ),
        actions: [
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance.collection('requests').doc(widget.requestId).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.exists) {
                var requestData = snapshot.data!.data() as Map<String, dynamic>;
                
                if (currentUser?.uid == requestData['receiverId'] && requestData['status'] != 'completed') {
                  return TextButton(
                    onPressed: _showEndDialog,
                    child: const Text("إنهاء الجلسة",
                        style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 13)),
                  );
                }
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('requests')
                  .doc(widget.requestId)
                  .collection('messages')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFF2E4365)));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("ابدأ المحادثة الآن.. ✨", style: TextStyle(color: Colors.grey)));
                }

                var messages = snapshot.data!.docs;
                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var data = messages[index].data() as Map<String, dynamic>;
                    bool isSent = data['senderId'] == currentUser?.uid;

                    String formattedTime = "";
                    try {
                      Timestamp? timestamp = data['createdAt'] as Timestamp?;
                      if (timestamp != null) {
                        formattedTime = DateFormat('hh:mm a').format(timestamp.toDate());
                      } else {
                        formattedTime = DateFormat('hh:mm a').format(DateTime.now());
                      }
                    } catch (e) {
                      formattedTime = "";
                    }

                    return Align(
                      alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 2),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isSent
                                  ? const Color(0xFF2E3E5C)
                                  : (isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF2F2F2)),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: SelectableText(
                              data['text'] ?? '',
                              style: TextStyle(color: isSent ? Colors.white : (isDark ? Colors.white : Colors.black)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                            child: Text(
                              formattedTime,
                              style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          _buildInputArea(isDark),
        ],
      ),
    );
  }

  Widget _buildInputArea(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF121212) : Colors.white,
        border: Border(top: BorderSide(color: isDark ? Colors.white10 : Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                controller: _controller,
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
                decoration: InputDecoration(
                  hintText: 'اكتب رسالتك..',
                  hintStyle: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: _sendTextMessage,
            child: const CircleAvatar(
              backgroundColor: Color(0xFF2E3E5C),
              child: Icon(Icons.send, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}

