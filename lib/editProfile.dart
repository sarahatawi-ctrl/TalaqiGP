import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show listEquals; 
import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'package:firebase_auth/firebase_auth.dart';     

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  List<String> skills = [];
  
  String _originalName = "";
  String _originalBio = "";
  List<String> _originalSkills = [];
  String _currentProfilePic = ""; 

  bool _isLoading = true; 

  @override
  void initState() {
    super.initState();
    _loadUserData(); 
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists) {
        var data = doc.data() as Map<String, dynamic>;
        setState(() {
          _nameController.text = data['name'] ?? "";
          _bioController.text = data['bio'] ?? "";
          skills = List<String>.from(data['skills'] ?? []);
          _currentProfilePic = data['profilePic'] ?? 'assets/avatar1.png'; 
          
          _originalName = _nameController.text;
          _originalBio = _bioController.text;
          _originalSkills = List<String>.from(skills);
          
          _isLoading = false;
        });
      }
    }
  }

  void _showAvatarPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 400,
          child: Column(
            children: [
              const Text(
                "اختر صورة ملف شخصي ",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, 
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: 16, 
                  itemBuilder: (context, index) {
                    String avatarPath = 'assets/avatar${index + 1}.png';
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _currentProfilePic = avatarPath; 
                        });
                        Navigator.pop(context); 
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _currentProfilePic == avatarPath ? const Color(0xFF2E4365) : Colors.transparent,
                            width: 3,
                          ),
                        ),
                        child: CircleAvatar(
                          backgroundImage: AssetImage(avatarPath),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _saveChanges() async {
    List<String> cleanedSkills = skills.map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
    String currentName = _nameController.text.trim();
    String currentBio = _bioController.text.trim();

    var doc = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).get();
    String oldPic = doc.data()?['profilePic'] ?? "";

    bool isChanged = currentName != _originalName || 
                    currentBio != _originalBio || 
                    !listEquals(cleanedSkills, _originalSkills) ||
                    _currentProfilePic != oldPic;

    if (!isChanged) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("لم تقم بإجراء أي تغييرات")));
      return;
    }

    if (currentName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("الاسم مطلوب")));
      return;
    }

    setState(() => _isLoading = true);
    final user = FirebaseAuth.instance.currentUser;
    
    try {
      await FirebaseFirestore.instance.collection('users').doc(user?.uid).update({
        'name': currentName,
        'bio': currentBio,
        'skills': cleanedSkills, 
        'profilePic': _currentProfilePic, 
        'isProfileComplete': currentName.isNotEmpty && currentBio.isNotEmpty && cleanedSkills.isNotEmpty, 
      });

      showSuccessDialog();
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("خطأ في الحفظ: $e")));
    }
  }

  void showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_outline, size: 80, color: Color(0xFF2E4365)),
            const SizedBox(height: 20),
            const Text("تم حفظ التعديلات بنجاح", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.pop(context); 
                Navigator.pop(context); 
              }, 
              child: const Text("موافق", style: TextStyle(color: Color(0xFF2E4365), fontWeight: FontWeight.bold))
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
        appBar: AppBar(
          backgroundColor: Colors.transparent, 
          elevation: 0,
          centerTitle: true,
          title: Text('تعديل الملف الشخصي', style: TextStyle(color: isDark ? Colors.white : Colors.black, fontWeight: FontWeight.bold)),
          
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 22, color: primaryNavy),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: _isLoading 
          ? const Center(child: CircularProgressIndicator(color: primaryNavy))
          : SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 70,
                      backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
                      backgroundImage: _currentProfilePic.startsWith('assets') 
                          ? AssetImage(_currentProfilePic) as ImageProvider
                          : NetworkImage(_currentProfilePic),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 5,
                      child: GestureDetector(
                        onTap: _showAvatarPicker, 
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(color: primaryNavy, shape: BoxShape.circle),
                          child: const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              buildInteractiveField(context, "الاسم", _nameController, primaryNavy),
              buildInteractiveField(context, "نبذة", _bioController, primaryNavy, isLongField: true),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('المهارات', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline, color: primaryNavy, size: 26),
                    onPressed: () => setState(() => skills.add("")), 
                  ),
                ],
              ),
              ...skills.asMap().entries.map((entry) {
                int idx = entry.key;
                return buildInteractiveField(
                  context, null, TextEditingController(text: entry.value), primaryNavy, 
                  isSkill: true, initialValue: entry.value,
                  onChanged: (val) => skills[idx] = val,
                );
              }).toList(),
              const SizedBox(height: 40),
              SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveChanges, 
                  style: ElevatedButton.styleFrom(backgroundColor: primaryNavy, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: const Text('حفظ', style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInteractiveField(BuildContext context, String? label, TextEditingController controller, Color primaryColor, 
      {bool isLongField = false, bool isSkill = false, String initialValue = "", Function(String)? onChanged}) {
    bool _isEditing = (isSkill && initialValue.isEmpty);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return StatefulBuilder(
      builder: (context, setInternalState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (label != null) Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: controller,
              readOnly: !_isEditing,
              onChanged: onChanged,
              maxLines: isLongField ? null : 1,
              decoration: InputDecoration(
                filled: true,
                fillColor: isDark ? const Color(0xFF1E1E1E) : Colors.white, 
                suffixIcon: IconButton(
                  icon: Icon(_isEditing ? Icons.check : Icons.edit_outlined, color: primaryColor),
                  onPressed: () => setInternalState(() => _isEditing = !_isEditing),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10), 
                  borderSide: BorderSide(color: isDark ? Colors.grey[700]! : const Color(0xFFEEEEEE))
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10), 
                  borderSide: BorderSide(color: primaryColor, width: 2)
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }
}
