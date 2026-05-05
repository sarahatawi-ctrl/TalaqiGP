import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReportPage extends StatefulWidget {
  final String reportedUserId; 

  const ReportPage({super.key, required this.reportedUserId});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  String? selectedReason;
  final TextEditingController _detailsController = TextEditingController();
  bool _isUploading = false; 

  final List<String> reportReasons = [
    "محتوى غير لائق",
    "سلوك مسيء أو تنمر",
    "معلومات مضللة",
    "حساب زائف",
    "آخر"
  ];

 
  Future<void> _submitReport() async {
    if (selectedReason == null) return;

    setState(() => _isUploading = true);

    final currentUser = FirebaseAuth.instance.currentUser;

    try {
      await FirebaseFirestore.instance.collection('reports').add({
        'reporterId': currentUser?.uid, 
        'reportedUserId': widget.reportedUserId, 
        'reason': selectedReason,
        'details': _detailsController.text.trim(),
        'status': 'pending', 
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        setState(() => _isUploading = false);
        _showSuccessDialog();
      }
    } catch (e) {
      setState(() => _isUploading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("حدث خطأ أثناء إرسال البلاغ: $e")),
      );
    }
  }

  void _showSuccessDialog() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_outline, size: 80, color: Color(0xFF2E4365)),
            const SizedBox(height: 20),
            Text(
              "تم إرسال بلاغك بنجاح",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "شكرًا لك على مساعدتنا في الحفاظ على مجتمع تلاقِ.",
              textAlign: TextAlign.center,
              style: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.pop(context); 
                Navigator.pop(context); 
              },
              child: const Text("موافق",
                  style: TextStyle(color: Color(0xFF2E4365), fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryNavy = Color(0xFF2E4365);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl, 
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text("تقديم بلاغ",
              style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold)),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: Icon(Icons.arrow_forward_ios,
                  color: isDark ? Colors.white : primaryNavy, size: 22),
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(width: 10),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "ما هو سبب البلاغ؟",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : primaryNavy),
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: isDark ? Colors.white10 : Colors.grey.shade300),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedReason,
                    dropdownColor: Theme.of(context).cardColor,
                    style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                        fontSize: 16),
                    hint: Text("اختر سبباً",
                        style: TextStyle(
                            color: isDark ? Colors.white70 : Colors.black54)),
                    isExpanded: true,
                    items: reportReasons.map((String reason) {
                      return DropdownMenuItem<String>(
                        value: reason,
                        child: Text(reason),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedReason = value;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Text(
                "تفاصيل إضافية",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : primaryNavy),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _detailsController,
                maxLines: 5,
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
                decoration: InputDecoration(
                  hintText: "اشرح لنا مزيداً عما حدث...",
                  hintStyle:
                      TextStyle(color: isDark ? Colors.white38 : Colors.black38),
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                        color: isDark ? Colors.white10 : Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: primaryNavy, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: (selectedReason != null && !_isUploading)
                      ? _submitReport
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryNavy,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    disabledBackgroundColor:
                        isDark ? Colors.white10 : Colors.grey.shade300,
                  ),
                  child: _isUploading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "إرسال البلاغ",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
