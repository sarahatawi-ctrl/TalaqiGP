import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home.dart';

class CreateSkillScreen extends StatefulWidget {
  const CreateSkillScreen({super.key});

  @override
  State<CreateSkillScreen> createState() => _CreateSkillScreenState();
}

class _CreateSkillScreenState extends State<CreateSkillScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isUploading = false;

  Future<void> _submitSkill() async {
    final title = _titleController.text.trim();
    final desc = _descriptionController.text.trim();

    if (title.isEmpty || desc.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("قم بإدخال تفاصيل المهارة")),
      );
      return;
    }

    setState(() => _isUploading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      var userDoc = await FirebaseFirestore.instance.collection('users').doc(user?.uid).get();
      var userData = userDoc.data() as Map<String, dynamic>;

      await FirebaseFirestore.instance.collection('skills').add({
        'title': title,
        'description': desc,
        'ownerId': user?.uid,
        'ownerName': userData['name'] ?? "مستخدم تلاقِ",
        'ownerImage': userData['profilePic'] ?? 'https://i.pravatar.cc/300?img=12',
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        setState(() => _isUploading = false);
        _showSuccessDialog();
      }
    } catch (e) {
      setState(() => _isUploading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("حدث خطأ: $e")));
    }
  }

  void _showSuccessDialog() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const Color primaryNavy = Color(0xFF2E3E5C);

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
            const Icon(
              Icons.check_circle_outline,
              size: 80,
              color: primaryNavy,
            ),
            const SizedBox(height: 25),
            Text(
              "تم إرسال مهاراتك ",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : primaryNavy,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "شكرًا لك على مساهمتك في مجتمع تلاقِ.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
            const SizedBox(height: 25),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                  (route) => false,
                );
              },
              child: const Text(
                "موافق",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryNavy,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const Color primaryNavy = Color(0xFF2E3E5C);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios, color: isDark ? Colors.white : primaryNavy),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      "إضافة مهارة",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : primaryNavy,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  "أخبرنا عن المهارة التي تود مشاركتها",
                  style: TextStyle(color: isDark ? Colors.white70 : Colors.black54, fontSize: 14),
                ),
                const SizedBox(height: 30),
                _buildLabel("اسم المهارة", isDark),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _titleController,
                  hint: 'مثال: شرح لغة جافا ',
                  isDark: isDark,
                ),
                const SizedBox(height: 20),
                _buildLabel("الوصف", isDark),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _descriptionController,
                  hint: ' صف ما يمكنك تقديمه',
                  isDark: isDark,
                  maxLines: 5,
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isUploading ? null : _submitSkill,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryNavy,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: _isUploading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "إرسال المهارة",
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text, bool isDark) {
    return Text(text, style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black));
  }

  Widget _buildTextField({required TextEditingController controller, required String hint, required bool isDark, int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(color: isDark ? Colors.white : Colors.black),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey),
        filled: true,
        fillColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: isDark ? const BorderSide(color: Colors.white10) : BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF2E3E5C), width: 2),
        ),
      ),
    );
  }
}
