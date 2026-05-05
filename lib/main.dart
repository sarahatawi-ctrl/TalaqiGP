import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; 
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'provider/theme_provider.dart';
import 'login_forget_pass.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("✅ Firebase initialized successfully!");
  } catch (e) {
    print("❌ Firebase initialization failed: $e");
  }

  runApp(
  
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        
        BlocProvider(create: (_) => LoginCubit()), 
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Talaaq App',

      themeMode: themeProvider.isDark ? ThemeMode.dark : ThemeMode.light,
      
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFF2E4365),
        fontFamily: 'Cairo',
        scaffoldBackgroundColor: const Color(0xFFF7F6F3), 
      ),

      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Cairo',
        primaryColor: const Color(0xFF2E4365),
        scaffoldBackgroundColor: const Color(0xFF121212), 
        cardColor: const Color(0xFF1E1E1E), 
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          iconTheme: IconThemeData(color: Colors.white),
        ),
      ),

      
      home: const LoginScreen(), 
    );
  }
}
