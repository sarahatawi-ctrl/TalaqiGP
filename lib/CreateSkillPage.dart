import 'dart:async';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CreateSkillPage(),
    );
  }
}

class CreateSkillPage extends StatelessWidget {
  const CreateSkillPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Directionality(
      textDirection: TextDirection.rtl,
      child: CreateSkillScreen(),
    );
  }
}

class CreateSkillScreen extends StatefulWidget {
  const CreateSkillScreen({super.key});

  @override
  State<CreateSkillScreen> createState() => _CreateSkillScreenState();
}

class _CreateSkillScreenState extends State<CreateSkillScreen> {
  List<PlatformFile> selectedFiles = [];
  String? duplicateMessage;

  Future<void> _pickFiles() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      bool hasDuplicate = false;

      for (var file in result.files) {
        bool alreadyExists = selectedFiles.any(
          (existingFile) =>
              existingFile.name == file.name &&
              existingFile.size == file.size,
        );

        if (!alreadyExists) {
          selectedFiles.add(file);
        } else {
          hasDuplicate = true;
        }
      }

      if (hasDuplicate) {
        setState(() {
          duplicateMessage = "أحد الملفات التي اخترتها مرفوع مسبقاً";
        });

        Timer(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              duplicateMessage = null;
            });
          }
        });
      }

      setState(() {});
    }
  }

  void _removeFile(int index) {
    setState(() {
      selectedFiles.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              const Text(
                "إضافة مهارة",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E3E5C),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "قم بإدخال تفاصيل المهارة وإرفاق الملفات الداعمة",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 30),

              const Text('اسم المهارة'),
              const SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  hintText: 'مثال: برمجة ألعاب',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text('الوصف'),
              const SizedBox(height: 8),
              TextField(
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'اكتب وصف مختصر عن المهارة...',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _pickFiles,
                  icon: const Icon(Icons.attach_file,color: Colors.black,),
                  label: const Text("إرفاق الملفات", style: TextStyle(color: Colors.black),),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),

              if (duplicateMessage != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline,
                          size: 20, color: Colors.orange),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          duplicateMessage!,
                          style: const TextStyle(color: Colors.orange),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 16),

              if (selectedFiles.isNotEmpty)
                Column(
                  children: List.generate(selectedFiles.length, (index) {
                    final file = selectedFiles[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.insert_drive_file,
                              color: Color(0xFF2E3E5C)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              file.name,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            onPressed: () => _removeFile(index),
                            icon: const Icon(Icons.close),
                          )
                        ],
                      ),
                    );
                  }),
                ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const SkillSuccessScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E3E5C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    "إرسال",
                    style: TextStyle(color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
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

class SkillSuccessScreen extends StatelessWidget {
  const SkillSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      body: Stack(
        children: [
          Center(
            child: Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 30,
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(
                    Icons.check_circle_rounded,
                    size: 90,
                    color: Color(0xFF2E3E5C),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'تم الإرسال بنجاح',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E3E5C),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.close, size: 28),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CreateSkillPage()),
                  (route) => false,
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
