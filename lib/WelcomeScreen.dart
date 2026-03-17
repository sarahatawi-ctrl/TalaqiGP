import 'package:flutter/material.dart';
import 'ChatbotView.dart'; // تأكد أن ملف الشات بوت موجود في نفس المجلد

class AIWelcomeScreen extends StatelessWidget {
  const AIWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // الخلفية مع التدرج اللوني
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2E4365), Color(0xFF1A237E)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // المحتوى الرئيسي
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // أيقونة ترحيبية أو شعار
                    const Icon(
                      Icons.auto_awesome,
                      size: 100,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      'مرحباً بك في تلاق',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'اكتشف مهارات جديدة وتبادل الخبرات مع شركاء التعلم المبدعين',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 60),
                    // زر ابدأ الآن
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // هذا هو الربط المطلوب لصفحة الشات بوت
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ChatbotView()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF2E4365),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 5,
                        ),
                        child: const Text(
                          'ابدأ الآن',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
