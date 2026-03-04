import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'SignUp.dart'; 
import 'HomePage.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F6F3),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const Text('تلاق', style: TextStyle(fontSize: 64, fontWeight: FontWeight.bold, color: Color(0xFF2E4365))),
                  const Text('حيث تلتقي المهارات', style: TextStyle(fontSize: 16, color: Colors.grey)),
                  const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)]),
                    child: Column(
                      children: [
                        TextField(textAlign: TextAlign.right, decoration: InputDecoration(hintText: 'البريد الإلكتروني', filled: true, fillColor: const Color(0xFFF7F6F3), border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none))),
                        const SizedBox(height: 12),
                        TextField(textAlign: TextAlign.right, obscureText: true, decoration: InputDecoration(hintText: 'كلمة المرور', filled: true, fillColor: const Color(0xFFF7F6F3), border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none))),
                        const SizedBox(height: 20),
                        SizedBox(width: double.infinity, height: 50, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2E4365), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))), onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage())), child: const Text("تسجيل الدخول", style: TextStyle(color: Colors.white)))),
                        const SizedBox(height: 16),
                        TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen())), child: const Text('ليس لديك حساب؟ انشئ الآن', style: TextStyle(color: Color(0xFF2E4365)))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
