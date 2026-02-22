import 'package:flutter/material.dart';

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
  // list to store profile skills
  List<String> skills = ["تطوير الألعاب", "تصميم الواجهات"];

  //  add a new empty skill field
  void addSkill() {
    setState(() {
      skills.add("");       
    });
  }

  //  display the success dialog upon saving
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
                
                const Icon(
                  Icons.check_circle_outline_rounded,
                  size: 90,
                  color: Color(0xFF344966),
                ),
                const SizedBox(height: 20),
                const Text(
                  'تم الحفظ بنجاح',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
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
              // user profile image with camera edit icon
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
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Color(0xFF6D6D9E),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // profile data input fields
              buildEditField("الأسم", "سديم ناصر"),
              const SizedBox(height: 20),
              buildEditField("البريد الالكتروني", "sade-em@gmail.com"),
              const SizedBox(height: 20),
              buildEditField("نبذة:", "", isLongField: true),
              const SizedBox(height: 20),

              // skills section 
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('المهارات', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: Icon(Icons.add_circle_outline, color: Colors.grey[600]),
                    onPressed: addSkill,    
                  ),
                ],
              ),
              const SizedBox(height: 10),
              
              
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
      //  navigation bar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF1A237E),
        unselectedItemColor: Colors.grey,
        currentIndex: 1,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'الاعدادات'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'الملف الشخصي'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'البحث'),
          BottomNavigationBarItem(icon: Icon(Icons.star_outline), label: 'لوحة الصدارة'),
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'الرئيسية'),
        ],
      ),
    );
  }

 
  Widget buildEditField(String label, String initialValue, {bool isLongField = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          maxLines: isLongField ? 4 : 1,
          decoration: InputDecoration(
            hintText: initialValue,
            hintStyle: const TextStyle(color: Colors.grey),
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

 
  Widget buildSkillField(String skill) {
    return TextField(
      decoration: InputDecoration(
        hintText: skill.isEmpty ? "أدخل مهارة جديدة" : skill,
        suffixIcon: const Icon(Icons.edit_outlined, color: Colors.grey, size: 20),
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
}
