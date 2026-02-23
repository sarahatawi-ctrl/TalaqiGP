import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
  //  profile data
  final TextEditingController _nameController = TextEditingController(text: "سديم ناصر");
  final TextEditingController _emailController = TextEditingController(text: "sade-em@gmail.com");
  final TextEditingController _bioController = TextEditingController(text: "");

  // skills list
  List<String> skills = ["تطوير الألعاب", "تصميم الواجهات"];
  final ImagePicker _picker = ImagePicker();

  //  image from gallery
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      print("Image selected: ${image.path}");
    }
  }

  // add a new empty skill to the list
  void addSkill() {
    setState(() {
      skills.add("");
    });
  }

  // success message dialog
  void showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            padding: const EdgeInsets.all(30),
            height: 280,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle_outline_rounded, size: 90, color: Color(0xFF344966)),
                const SizedBox(height: 20),
                const Text('تم الحفظ بنجاح', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('موافق', style: TextStyle(fontSize: 18, color: Color(0xFF344966))),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryNavy = Color(0xFF344966);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, color: Colors.black, size: 22),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              // avatar section
              Center(
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: primaryNavy.withOpacity(0.1), width: 2),
                      ),
                      child: const CircleAvatar(
                        radius: 70,
                        backgroundImage: NetworkImage('https://i.pravatar.cc/300?img=5'),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 5,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(color: Color(0xFF6D6D9E), shape: BoxShape.circle),
                          child: const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              
              buildEditField("الأسم", _nameController),
              const SizedBox(height: 20),
              buildEditField("البريد الالكتروني", _emailController),
              const SizedBox(height: 20),
              buildEditField("نبذة:", _bioController, isLongField: true),
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

              // dynamic skills List
              Column(
                children: skills.map((skill) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: buildSkillField(skill),
                )).toList(),
              ),

              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Text('عرض الأوسمة ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Icon(Icons.arrow_back_ios, size: 18, color: Colors.black),
                ],
              ),
              const SizedBox(height: 30),
              // save button
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
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF1A237E),
        unselectedItemColor: Colors.grey,
        currentIndex: 1,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'الاعدادات'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'الملف الشخصي'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'الدردشة'),
          BottomNavigationBarItem(icon: Icon(Icons.star_outline), label: 'لوحة الصدارة'),
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'الرئيسية'),
        ],
      ),
    );
  }

  // build Name/Email/Bio fields 
  Widget buildEditField(String label, TextEditingController controller, {bool isLongField = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: isLongField ? 4 : 1,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFEEEEEE)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF344966)),
            ),
          ),
        ),
      ],
    );
  }

  //   skill fields with placeholder 
  Widget buildSkillField(String skill) {
    bool isNewSkill = skill.isEmpty;
    bool isReadOnly = !isNewSkill; 
    
    return StatefulBuilder(
      builder: (context, setInternalState) {
        return TextField(
          readOnly: isReadOnly,
          controller: isNewSkill ? null : TextEditingController(text: skill),
          style: const TextStyle(fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            // placeholder shown only if the skill is new and empty
            hintText: isNewSkill ? "أدخل مهارة جديدة" : null,
            hintStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.normal),
            suffixIcon: IconButton(
              icon: const Icon(Icons.edit_outlined, color: Colors.black87, size: 20),
              onPressed: () {
                setInternalState(() {
                  isReadOnly = !isReadOnly;
                });
              },
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFEEEEEE)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF344966)),
            ),
          ),
        );
      }
    );
  }
}
