import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../firebase_options.dart';
import 'login_forget_pass.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (_) => RegisterCubit(),
        child: const RegisterScreen(),
      ),
    );
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6F3),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: BlocConsumer<RegisterCubit, RegisterState>(
          listener: (context, state) {
            if (state is RegisterSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("تم إنشاء الحساب بنجاح"),
                  backgroundColor: Colors.green,
                ),
              );
            } else if (state is RegisterFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Color.fromARGB(255, 212, 41, 29),
                ),
              );
            }
          },
          builder: (_, state) {
            return Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Text(
                      'تلاق',
                      style: TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E4365),
                      ),
                    ),

                    const SizedBox(height: 6),
                    const Text(
                      'حيث تلتقي المهارات',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),

                    const SizedBox(height: 40),

                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                        //TF of email
                          TextField(
                            controller: email,
                            decoration: InputDecoration(
                              hintText: 'البريد الإلكتروني',
                              filled: true,
                              fillColor: const Color(0xFFF7F6F3),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 16,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
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
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 16,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
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
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 16,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          //Button
                          state is RegisterLoading
                              ? const CircularProgressIndicator()
                              : SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF2E4365),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    onPressed: () {
                                      if (email.text.isEmpty ||
                                          pass.text.isEmpty ||
                                          confirmPass.text.isEmpty) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "الرجاء ملء جميع الحقول",
                                            ),backgroundColor: Color.fromARGB(255, 212, 41, 29),
                                          ),
                                        );
                                        return;
                                      }

                                      if (pass.text != confirmPass.text) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "كلمة المرور وتأكيدها غير متطابقين",
                                            ),backgroundColor: Color.fromARGB(255, 212, 41, 29),
                                          ),
                                        );
                                        return;
                                      }

                                      context.read<RegisterCubit>().register(
                                        email.text.trim(),
                                        pass.text.trim(),
                                      );
                                    },
                                    child: const Text(
                                      "إنشاء الحساب",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                          const SizedBox(height: 16),
                          
                          //TextButton to navigate 
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BlocProvider(
                                    create: (_) => LoginCubit(),
                                    child: const LoginScreen(),
                                  ),
                                ),
                              );
                            },
                            child: const Text(
                              'لديك حساب؟ سجل',
                              style: TextStyle(
                                color: Color(0xFF2E4365),
                                fontSize: 14,
                              ),
                            ),
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

//Cubit
class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  Future<void> register(String email, String password) async {
    emit(RegisterLoading());
    try {
      UserCredential user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      emit(
        user.user != null
            ? RegisterSuccess()
            : RegisterFailure("حدث خطأ أثناء إنشاء الحساب"),
      );
    } on FirebaseAuthException catch (e) {
      String msg = "تأكد من البريد الإلكتروني وكلمة المرور";
      if (e.code == 'email-already-in-use') {
        msg = "هذا البريد الإلكتروني مستخدم مسبقاً";
      }
      if (e.code == 'invalid-email') msg = "البريد الإلكتروني غير صالح";
      if (e.code == 'weak-password') msg = "كلمة المرور ضعيفة جداً";
      emit(RegisterFailure(msg));
    } catch (_) {
      emit(RegisterFailure("حدث خطأ غير متوقع"));
    }
  }
}

//States
abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {}

class RegisterFailure extends RegisterState {
  final String message;
  RegisterFailure(this.message);
}
