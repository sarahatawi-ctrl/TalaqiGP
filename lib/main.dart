import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Talaqi Login',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF2D4363),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto', // Defaulting to Roboto, but would use a custom Arabic font if available
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLargeScreen = size.width > 600;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: isLargeScreen ? 500 : double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  // Logo Section
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Placeholder for the floral background element
                      Icon(
                        Icons.filter_vintage_outlined,
                        size: 180,
                        color: const Color(0xFFEAE3D2).withOpacity(0.8),
                      ),
                      const Text(
                        'تلاقي',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D4363),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 60),
                  // Login Card Section
                  Container(
                    padding: const EdgeInsets.all(32.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F7FF),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Center(
                          child: Text(
                            'مرحباً بعودتك',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D4363),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        const Text(
                          'اسم المستخدم',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF2D4363),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          textAlign: TextAlign.right,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(color: Color(0xFF8B4C4C), width: 1),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(color: Color(0xFF8B4C4C), width: 1),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'كلمة المرور',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF2D4363),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          obscureText: true,
                          textAlign: TextAlign.right,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            suffixIcon: const Icon(Icons.visibility_off_outlined, color: Color(0xFF4A2C2C)),
                            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(color: Color(0xFF8B4C4C), width: 1),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(color: Color(0xFF8B4C4C), width: 1),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'نسيت كلمة المرور؟',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF2D4363),
                          ),
                        ),
                        const SizedBox(height: 40),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2D4363),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'تسجيل دخول',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Center(
                          child: Text(
                            'لا يوجد لديك حساب؟ انشاء حساب',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF2D4363),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
