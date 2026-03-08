import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; 
import 'package:flutter/foundation.dart' show kIsWeb; 

void main() {
  runApp(const TalaaqApp());
}

class TalaaqApp extends StatelessWidget {
  const TalaaqApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar', 'SA'),
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: const EditProfilePage(),
      ),
    );
  }
}

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  
  final TextEditingController _nameController = TextEditingController(text: "محمد أحمد");
  final TextEditingController _emailController = TextEditingController(text: "mohamed.ahmed@gmail.com");
  final TextEditingController _bioController = TextEditingController(
    text: "مصمم مواقع مهتم بإنشاء واجهات مستخدم جذابة وسهلة الاستخدام مهتم بتحويل الأفكار المعقدة إلى تصاميم رقمية بسيطة ومبتكرة تخدم تجربة المستخدم."
  );

  List<String> skills = [
    "تصميم واجهات المستخدم (UI/UX)",
    "تطوير الويب (HTML/CSS)",
    "إدارة المشاريع البرمجية"
  ];
  
  final ImagePicker _picker = ImagePicker();
  dynamic _imageSelection; 

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        if (kIsWeb) {
          _imageSelection = image.path; 
        } else {
          _imageSelection = File(image.path); 
        }
      });
      debugPrint("Image selected: ${image.path}");
    }
  }

  void addSkill() {
    setState(() {
      skills.add(""); 
    });
  }

  void showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_outline, size: 80, color: Color(0xFF344966)),
            const SizedBox(height: 20),
            const Text("تم حفظ التعديلات بنجاح", style: TextStyle(fontWeight: FontWeight.bold)),
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("موافق"))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryNavy = Color(0xFF344966);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E4365),
        elevation: 0,
        title: const Text('تعديل الملف الشخصي', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, size: 22, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.grey[200],
                    
                    backgroundImage: _imageSelection == null
                        ? const NetworkImage('https://i.pravatar.cc/300?img=12')
                        : (kIsWeb 
                            ? NetworkImage(_imageSelection as String) 
                            : FileImage(_imageSelection as File)) as ImageProvider,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 5,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: Color(0xFF2E4365), shape: BoxShape.circle),
                        child: const Icon(Icons.camera_alt_outlined, color: Color.fromARGB(255, 183, 200, 228), size: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            
            buildInteractiveField("الاسم", _nameController),
            const SizedBox(height: 20),
            buildInteractiveField("البريد الالكتروني", _emailController),
            const SizedBox(height: 20),
            buildInteractiveField("نبذة", _bioController, isLongField: true),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('المهارات', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline, color: Colors.black87, size: 26),
                  onPressed: addSkill,
                ),
              ],
            ),
            const SizedBox(height: 10),

            ...skills.map((skill) => buildInteractiveField(null, TextEditingController(text: skill), isSkill: true, initialValue: skill)).toList(),

            const SizedBox(height: 40),
            
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                onPressed: showSuccessDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryNavy,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('حفظ', style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF1A237E),
        unselectedItemColor: Colors.grey,
        currentIndex: 1,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'الاعدادات'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'الملف الشخصي'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'المحادثة'),
          BottomNavigationBarItem(icon: Icon(Icons.star_outline), label: 'لوحة الصدارة'),
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'الرئيسية'),
        ],
      ),
    );
  }

  Widget buildInteractiveField(String? label, TextEditingController controller, {bool isLongField = false, bool isSkill = false, String initialValue = ""}) {
    bool _isEditing = initialValue.isEmpty && isSkill;
    
    return StatefulBuilder(
      builder: (context, setInternalState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (label != null) Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            if (label != null) const SizedBox(height: 8),
            TextField(
              controller: controller,
              readOnly: !_isEditing,
              maxLines: isLongField ? null : 1,
              minLines: isLongField ? 3 : 1,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              decoration: InputDecoration(
                hintText: (isSkill && initialValue.isEmpty) ? "أدخل مهارة جديدة" : null,
                hintStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.normal),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.edit_outlined, color: Colors.black87, size: 22),
                  onPressed: () {
                    setInternalState(() => _isEditing = !_isEditing);
                  },
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: _isEditing ? const Color(0xFF344966) : const Color(0xFFEEEEEE)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFF344966), width: 2),
                ),
              ),
            ),
            if (isSkill) const SizedBox(height: 10),
          ],
        );
      }
    );
  }
}
