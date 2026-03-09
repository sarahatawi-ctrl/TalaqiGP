import 'package:flutter/material.dart';
import 'AIWelcomeScreen.dart'; 
import 'LoginScreen.dart';
import 'Leaderboard.dart';
import 'HomePage.dart';
import 'allRequests.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _TalaaqAppState();
}

class _TalaaqAppState extends State<Setting> {
  bool _isDark = false;
  bool _isLoggedIn = true; 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar', 'SA'),
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF7F6F3),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
      ),
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: _isLoggedIn 
          ? SettingsPage(
              isDarkMode: _isDark,
              onThemeChanged: (value) => setState(() => _isDark = value),
              onLogout: () => setState(() => _isLoggedIn = false),
            )
          : Scaffold(
              backgroundColor: const Color(0xFFF7F6F3),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("تم تسجيل الخروج بنجاح", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E4365), 
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)), 
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12)
                      ),
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen())),
                      child: const Text("تسجيل الدخول", style: TextStyle(color: Colors.white, fontSize: 16)),
                    )
                  ],
                ),
              ),
            ),
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;
  final VoidCallback onLogout;

  const SettingsPage({super.key, required this.isDarkMode, required this.onThemeChanged, required this.onLogout});


  void _showFAQs(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('الأسئلة الشائعة', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF2E4365), fontWeight: FontWeight.bold)),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: [
                _buildFAQItem('ماهو تطبيق تلاق؟', 'هو تطبيق تعلمي يهدف لتبادل الخبرات والمهارات'),
                const Divider(),
                _buildFAQItem('هل التطبيق مجاني؟', 'نعم، تطبيق تلاق قائم على التطوع وبشكل مجاني بالكامل'),
                const Divider(),
                _buildFAQItem('كيف أتواصل مع شريك التعلم؟', 'بمجرد قبول الطلب، ستفتح لك نافذة المحادثة المباشرة مع الشريك'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('إغلاق', style: TextStyle(color: Color(0xFF2E4365))),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(question, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 5),
          Text(answer, style: const TextStyle(fontSize: 13, color: Colors.grey)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryNavy = Color(0xFF2E4365); 
    Color sectionBg = isDarkMode ? Colors.grey[900]! : Colors.white;

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF121212) : const Color(0xFFF7F6F3),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text('الإعدادات', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text('الحساب', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(color: sectionBg, borderRadius: BorderRadius.circular(15)),
              child: Column(
                children: [
                  buildSettingsItem(Icons.person_outline, 'الملف الشخصي', isDarkMode, primaryNavy, () {}),
                  buildSettingsItem(Icons.lightbulb_outline, 'مساعدك في التعلم', isDarkMode, primaryNavy, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const AIWelcomeScreen()));
                  }),
                  buildSettingsItem(Icons.notifications_none, 'جلسات التعلم', isDarkMode, primaryNavy, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const allRequests()));
                  }, isLast: true),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text('التفضيلات', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(color: sectionBg, borderRadius: BorderRadius.circular(15)),
              child: ListTile(
                leading: const Icon(Icons.dark_mode_outlined, color: primaryNavy),
                title: const Text('الوضع الداكن', style: TextStyle(fontSize: 16)),
                trailing: Switch(value: isDarkMode, onChanged: onThemeChanged, activeThumbColor: primaryNavy),
              ),
            ),
            const SizedBox(height: 30),
            const Text('الإجراءات', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(color: sectionBg, borderRadius: BorderRadius.circular(15)),
              child: Column(
                children: [
                 
                  buildSettingsItem(Icons.help_outline, 'الأسئلة الشائعة', isDarkMode, primaryNavy, () => _showFAQs(context)),
                  buildSettingsItem(Icons.assignment_outlined, 'متابعة البلاغات', isDarkMode, primaryNavy, () {}),
                  buildSettingsItem(Icons.logout, 'تسجيل الخروج', isDarkMode, primaryNavy, onLogout, isLast: true),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF1A237E),
        unselectedItemColor: Colors.grey,
        currentIndex: 4,
        onTap: (index) {
          if (index == 0) Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
          if (index == 1) Navigator.push(context, MaterialPageRoute(builder: (context) => const Leaderboard()));
          if (index == 2) Navigator.push(context, MaterialPageRoute(builder: (context) => const allRequests()));
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
          BottomNavigationBarItem(icon: Icon(Icons.star_outline), label: 'لوحة الصدارة'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'المحادثة'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'الملف الشخصي'),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'الاعدادات'),
        ],
      ),
    );
  }

  Widget buildSettingsItem(IconData icon, String title, bool isDark, Color iconColor, VoidCallback onTap, {bool isLast = false}) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: iconColor),
          title: Text(title, style: const TextStyle(fontSize: 16)),
          trailing: const Icon(Icons.arrow_back_ios, size: 16, color: Colors.black26),
          onTap: onTap,
        ),
        if (!isLast) Divider(height: 1, indent: 50, endIndent: 20, color: isDark ? Colors.white10 : Colors.black12),
      ],
    );
  }
}
