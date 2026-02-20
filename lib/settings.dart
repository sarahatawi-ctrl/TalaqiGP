import 'package:flutter/material.dart';

void main() {
  runApp(const TalaaqApp());
}

class TalaaqApp extends StatefulWidget {
  const TalaaqApp({super.key});

  @override
  State<TalaaqApp> createState() => _TalaaqAppState();
}

class _TalaaqAppState extends State<TalaaqApp> {
  
  bool _isDark = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar', 'SA'),
      
      
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
      ),
      
      
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
      ),
      
     
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,

      home: Directionality(
        textDirection: TextDirection.rtl,
        child: SettingsPage(
          isDarkMode: _isDark,
          onChanged: (value) {
            setState(() {
              _isDark = value;  
            });
          },
        ),
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onChanged;

  const SettingsPage({super.key, required this.isDarkMode, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    const Color primaryNavy = Color(0xFF344966);
    
    Color sectionBg = isDarkMode ? Colors.grey[900]! : const Color(0xFFF3F5F9);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'الإعدادات',
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_forward_ios, color: isDarkMode ? Colors.white : Colors.black, size: 22),
            onPressed: () {},
          ),
          const SizedBox(width: 10),
        ],
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
                  buildSettingsItem(Icons.person_outline, 'الملف الشخصي', isDarkMode),
                  buildSettingsItem(Icons.lock_outline, 'مساعدك في التعلم', isDarkMode),
                  buildSettingsItem(Icons.notifications_none, 'جلسات التعلم', isDarkMode, isLast: true),
                ],
              ),
            ),

            const SizedBox(height: 30),

            const Text('التفضيلات', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(color: sectionBg, borderRadius: BorderRadius.circular(15)),
              child: ListTile(
                leading: Icon(Icons.dark_mode_outlined, color: isDarkMode ? Colors.white70 : Colors.black54),
                title: const Text('الوضع الداكن', style: TextStyle(fontSize: 16)),
                trailing: Switch(
                  value: isDarkMode,
                  onChanged: onChanged,
                  activeColor: primaryNavy,
                ),
              ),
            ),

            const SizedBox(height: 30),

            const Text('الإجراءات', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(color: sectionBg, borderRadius: BorderRadius.circular(15)),
              child: Column(
                children: [
                  buildSettingsItem(Icons.help_outline, 'الأسئلة الشائعة', isDarkMode),
                  buildSettingsItem(Icons.logout, 'تسجيل الخروج', isDarkMode, isLast: true),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: isDarkMode ? Colors.white : const Color(0xFF1A237E),
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'الاعدادات'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'الملف الشخصي'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'البحث'),
          BottomNavigationBarItem(icon: Icon(Icons.star_outline), label: 'لوحة الصدارة'),
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'الرئيسية'),
        ],
      ),
    );
  }

  Widget buildSettingsItem(IconData icon, String title, bool isDark, {bool isLast = false}) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: isDark ? Colors.white70 : Colors.black54),
          title: Text(title, style: const TextStyle(fontSize: 16)),
          trailing: const Icon(Icons.arrow_back_ios, size: 16, color: Colors.black26),
          onTap: () {},
        ),
        if (!isLast) Divider(height: 1, indent: 50, endIndent: 20, color: isDark ? Colors.white10 : Colors.black12),
      ],
    );
  }
}
