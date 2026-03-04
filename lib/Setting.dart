import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'LoginScreen.dart';

abstract class RegisterState {}
class RegisterInitial extends RegisterState {}
class RegisterLoading extends RegisterState {}
class RegisterSuccess extends RegisterState {}
class RegisterFailure extends RegisterState {
  final String message;
  RegisterFailure(this.message);
}

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());
  Future<void> register(String email, String password) async {
    emit(RegisterLoading());
    await Future.delayed(const Duration(seconds: 1));
    emit(RegisterSuccess());
  }
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final email = TextEditingController();
  final pass = TextEditingController();
  final confirmPass = TextEditingController(); 

  @override
  void dispose() {
    email.dispose(); pass.dispose(); confirmPass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: const Color(0xFFF7F6F3),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: BlocConsumer<RegisterCubit, RegisterState>(
              listener: (context, state) {
                if (state is RegisterSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("تم إنشاء الحساب بنجاح"), backgroundColor: Colors.green),
                  );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                }
              },
              builder: (context, state) {
                return Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const Text('تلاق', style: TextStyle(fontSize: 64, fontWeight: FontWeight.bold, color: Color(0xFF2E4365))),
                        const Text('حيث تلتقي المهارات', style: TextStyle(fontSize: 16, color: Colors.grey)),
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
                                controller: email, 
                                textAlign: TextAlign.right,
                                decoration: InputDecoration(hintText: 'البريد الإلكتروني', filled: true, fillColor: const Color(0xFFF7F6F3), border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none))
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: pass, 
                                textAlign: TextAlign.right,
                                obscureText: true, 
                                decoration: InputDecoration(hintText: 'كلمة المرور', filled: true, fillColor: const Color(0xFFF7F6F3), border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none))
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: confirmPass, 
                                textAlign: TextAlign.right,
                                obscureText: true, 
                                decoration: InputDecoration(hintText: 'تأكيد كلمة المرور', filled: true, fillColor: const Color(0xFFF7F6F3), border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none))
                              ),
                              const SizedBox(height: 20),
                              state is RegisterLoading
                                  ? const CircularProgressIndicator()
                                  : SizedBox(width: double.infinity, height: 50, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2E4365), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))), onPressed: () => context.read<RegisterCubit>().register(email.text.trim(), pass.text.trim()), child: const Text("إنشاء الحساب", style: TextStyle(color: Colors.white)))),
                              const SizedBox(height: 16),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context); 
                                },
                                child: const Text('لديك حساب؟ سجل', style: TextStyle(color: Color(0xFF2E4365))),
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
        ),
      ),
    );
  }
}
