import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 

class SignUp extends StatefulWidget {
  const SignUp({super.key});
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final nameController = TextEditingController(); 
  final email = TextEditingController();
  final pass = TextEditingController();
  final confirmPass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6F3),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: BlocConsumer<RegisterCubit, RegisterState>(
          listener: (context, state) {
            if (state is RegisterSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("تم إنشاء الحساب بنجاح"), backgroundColor: Colors.green),
              );
              Navigator.pop(context); 
            } else if (state is RegisterFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: const Color.fromARGB(255, 212, 41, 29)),
              );
            }
          },
          builder: (_, state) {
            return Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/logo.png',
                      width: 320,
                      height: 320,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'حيث تلتقي المهارات',
                      style: TextStyle(
                        fontSize: 20, 
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF2E4365),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
                      ),
                      child: Column(
                        children: [
                          TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                              hintText: 'الاسم الكامل',
                              filled: true,
                              fillColor: const Color(0xFFF7F6F3),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: email,
                            decoration: InputDecoration(
                              hintText: 'البريد الإلكتروني',
                              filled: true,
                              fillColor: const Color(0xFFF7F6F3),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: pass,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'كلمة المرور',
                              filled: true,
                              fillColor: const Color(0xFFF7F6F3),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: confirmPass,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'تأكيد كلمة المرور',
                              filled: true,
                              fillColor: const Color(0xFFF7F6F3),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                            ),
                          ),
                          const SizedBox(height: 20),
                          state is RegisterLoading
                              ? const CircularProgressIndicator()
                              : SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF2E4365),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                    ),
                                    onPressed: () {
                                      if (nameController.text.isEmpty || email.text.isEmpty || pass.text.isEmpty) {
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("الرجاء ملء جميع الحقول"), backgroundColor: Colors.red));
                                        return;
                                      }
                                      if (pass.text != confirmPass.text) {
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("كلمات المرور غير متطابقة"), backgroundColor: Colors.red));
                                        return;
                                      }
                                      context.read<RegisterCubit>().register(
                                        nameController.text.trim(),
                                        email.text.trim(),
                                        pass.text.trim(),
                                      );
                                    },
                                    child: const Text("إنشاء الحساب", style: TextStyle(fontSize: 16, color: Colors.white)),
                                  ),
                                ),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('لديك حساب؟ سجل', style: TextStyle(color: Color(0xFF2E4365), fontSize: 14)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  Future<void> register(String name, String email, String password) async {
    emit(RegisterLoading());
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      String uid = userCredential.user!.uid;

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'uid': uid,
        'name': name,
        'email': email,
        'bio': '',
        'profilePic': '',
        'skills': [],
        'isProfileComplete': false,
        'teachingHours': 0,
        'isBanned': false,
        'hasWarning': false,
        'warningMessage': '',
        'createdAt': FieldValue.serverTimestamp(),
      });

      emit(RegisterSuccess());
    } on FirebaseAuthException catch (e) {
      String msg = "خطأ في إنشاء الحساب";
      if (e.code == 'email-already-in-use') msg = "البريد الإلكتروني مستخدم مسبقاً";
      if (e.code == 'weak-password') msg = "كلمة المرور ضعيفة جداً";
      emit(RegisterFailure(msg));
    } catch (e) {
      emit(RegisterFailure("حدث خطأ غير متوقع: $e"));
    }
  }
}

abstract class RegisterState {}
class RegisterInitial extends RegisterState {}
class RegisterLoading extends RegisterState {}
class RegisterSuccess extends RegisterState {}
class RegisterFailure extends RegisterState { final String message; RegisterFailure(this.message); }
