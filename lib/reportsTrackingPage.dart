import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class ReportsTrackingPage extends StatelessWidget {
  const ReportsTrackingPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryNavy = Color(0xFF2E4365);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentUser = FirebaseAuth.instance.currentUser;

    
    if (currentUser == null) {
      return const Scaffold(body: Center(child: Text("يرجى تسجيل الدخول أولاً")));
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: isDark ? Colors.transparent : Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: isDark ? Colors.white : primaryNavy),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'متابعة البلاغات',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
       
        stream: FirebaseFirestore.instance
            .collection('reports')
            .where('reporterId', isEqualTo: currentUser.uid)
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
         
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text("حدث خطأ: ${snapshot.error}", textAlign: TextAlign.center),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: primaryNavy));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.description_outlined, size: 70, color: Colors.grey[400]),
                  const SizedBox(height: 15),
                  const Text("لا توجد بلاغات سابقة لديك ", style: TextStyle(color: Colors.grey, fontSize: 16)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var report = snapshot.data!.docs[index].data() as Map<String, dynamic>;

              String formattedDate = "جاري التحميل...";
              if (report['createdAt'] != null) {
                DateTime date = (report['createdAt'] as Timestamp).toDate();
                formattedDate = DateFormat('y/M/d').format(date);
              }

              String statusText = "";
              Color statusColor = Colors.orange;
              IconData icon = Icons.hourglass_empty;

              switch (report['status']) {
                case 'pending':
                  statusText = "قيد المراجعة";
                  statusColor = Colors.orange;
                  icon = Icons.hourglass_empty;
                  break;
                case 'reviewed':
                  statusText = "تمت المراجعة";
                  statusColor = Colors.blue;
                  icon = Icons.visibility_outlined;
                  break;
                case 'action_taken':
                  statusText = "تم اتخاذ إجراء";
                  statusColor = Colors.green;
                  icon = Icons.check_circle_outline;
                  break;
                default:
                  statusText = "إغلاق الطلب";
                  statusColor = Colors.grey;
                  icon = Icons.cancel_outlined;
              }

              return _buildReportCard(
                context,
                'بلاغ: ${report['reason'] ?? "بدون سبب"}',
                formattedDate,
                statusText,
                statusColor,
                icon,
                isDark,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildReportCard(BuildContext context, String title, String date, String status, Color statusColor, IconData icon, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: statusColor.withOpacity(0.15), shape: BoxShape.circle),
            child: Icon(icon, color: statusColor, size: 24),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: isDark ? Colors.white : Colors.black)),
                const SizedBox(height: 4),
                Text(date, style: TextStyle(color: isDark ? Colors.white60 : Colors.grey.shade600, fontSize: 12)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(color: statusColor.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
            child: Text(status, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 11)),
          ),
        ],
      ),
    );
  }
}
