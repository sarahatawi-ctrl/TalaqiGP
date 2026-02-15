import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';

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
        create: (_) => LoginCubit(),
        child: const LoginScreen(),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6F3),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("تم تسجيل الدخول بنجاح"),
                  backgroundColor: Colors.green,
                ),
              );
            } else if (state is LoginFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: const Color.fromARGB(255, 212, 41, 29),
                ),
              );
            }
          },
          builder: (context, state) {
            return Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    //Talaqi
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
                          // TF of Email
                          TextField(
                            controller: emailController,
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

                          // TF of password
                          TextField(
                            controller: passwordController,
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

                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BlocProvider(
                                      create: (_) => ResetPasswordCubit(),
                                      child: const ResetPasswordScreen(),
                                    ),
                                  ),
                                );
                              },
                              child: const Text(
                                'نسيت كلمة المرور؟',
                                style: TextStyle(
                                  color: Color(0xFF2E4365),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),

                          //Button
                          state is LoginLoading
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
                                      final email = emailController.text.trim();
                                      final password = passwordController.text
                                          .trim();

                                      if (email.isEmpty || password.isEmpty) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "الرجاء إدخال البريد الإلكتروني وكلمة المرور",
                                            ),
                                            backgroundColor: Color.fromARGB(
                                              255,
                                              212,
                                              41,
                                              29,
                                            ),
                                          ),
                                        );
                                        return;
                                      }

                                      context.read<LoginCubit>().login(
                                        email,
                                        password,
                                      );
                                    },
                                    child: const Text(
                                      "تسجيل الدخول",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
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

//Reset Screen
class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6F3),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF2E4365)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
          listener: (context, state) {
            if (state is ResetPasswordSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني",
                  ),
                  backgroundColor: Colors.green,
                ),
              );
              //Back after 2Sec
              Future.delayed(const Duration(seconds: 2), () {
                Navigator.pop(context);
              });
            } else if (state is ResetPasswordFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: const Color.fromARGB(255, 212, 41, 29),
                ),
              );
            }
          },
          builder: (context, state) {
            return Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    //Talaqi
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
                      'إعادة تعيين كلمة المرور',
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
                          const Text(
                            'أدخل بريدك الإلكتروني وسنرسل لك رابط لإعادة تعيين كلمة المرور',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),

                          const SizedBox(height: 20),

                          // TF of Email
                          TextField(
                            controller: emailController,
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

                          const SizedBox(height: 20),

                          //Button
                          state is ResetPasswordLoading
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
                                      final email = emailController.text.trim();

                                      if (email.isEmpty) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "الرجاء إدخال البريد الإلكتروني",
                                            ),
                                            backgroundColor: Color.fromARGB(
                                              255,
                                              212,
                                              41,
                                              29,
                                            ),
                                          ),
                                        );
                                        return;
                                      }

                                      context
                                          .read<ResetPasswordCubit>()
                                          .resetPassword(email);
                                    },
                                    child: const Text(
                                      "إرسال رابط إعادة التعيين",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
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

//Login Cubit

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  Future<void> login(String email, String password) async {
    emit(LoginLoading());

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(LoginSuccess());
    } on FirebaseAuthException {
      emit(LoginFailure("تأكد من البريد الإلكتروني وكلمة المرور"));
    }
  }
}

//Login States
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginFailure extends LoginState {
  final String message;
  LoginFailure(this.message);
}

//Reset Password Cubit

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit() : super(ResetPasswordInitial());

  Future<void> resetPassword(String email) async {
    emit(ResetPasswordLoading());

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      emit(ResetPasswordSuccess());
    } on FirebaseAuthException catch (e) {
      String message = "حدث خطأ أثناء إرسال البريد الإلكتروني";

      if (e.code == 'user-not-found') {
        message = "البريد الإلكتروني غير مسجل";
      } else if (e.code == 'invalid-email') {
        message = "البريد الإلكتروني غير صالح";
      }

      emit(ResetPasswordFailure(message));
    }
  }
}

//Reset Password States
abstract class ResetPasswordState {}

class ResetPasswordInitial extends ResetPasswordState {}

class ResetPasswordLoading extends ResetPasswordState {}

class ResetPasswordSuccess extends ResetPasswordState {}

class ResetPasswordFailure extends ResetPasswordState {
  final String message;
  ResetPasswordFailure(this.message);
}
