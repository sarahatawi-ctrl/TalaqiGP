import 'package:flutter/material.dart';
import 'WelcomeScreen.dart'; 

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
        scaffoldBackgroundColor: Colors.white,
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
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("تم تسجيل الخروج بنجاح", style: TextStyle(fontSize: 20)),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        setState(() => _isLoggedIn = true);
                      },
                      child: const Text(" تسجيل الدخول"),
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

  const SettingsPage({
    super.key, 
    required this.isDarkMode, 
    required this.onThemeChanged,
    required this.onLogout,
  });

  // FAQ Dialog 
  void showFAQDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('الأسئلة الشائعة', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildFAQItem('ما هو تطبيق تلاقِ؟', 'هو تعزيز ثقافة تبادل المعرفة بشكل تطوعي، حيث يمنح كل مستخدم فرصة ليكون معلماً ومتعلماً في آن واحد'),
                  _buildFAQItem('كيف يمكنني مشاركة مهاراتي؟', ' أضف مهاراتك في ملفك الشخصي، وستجد من يحتاج تعلم هذه المهارة'),
                  _buildFAQItem('كيف يتم توثيق الساعات التطوعية؟', 'يوفر التطبيق نظاماً داخلياً يحسب ساعات الجلسات التعليمية ويوثقها كعمل تطوعي معتمد داخل المنصة'),
                  _buildFAQItem('هل هناك رسوم مادية؟', 'لا، التطبيق قائم كلياً على مبدأ التطوع وتبادل المنفعة المعرفية بدون أي مقابل مادي'),
                  _buildFAQItem('ما الفائدة من جمع الأوسمة؟', 'الأوسمة هي تقدير رقمي لجهودك التطوعية، وتساهم في رفع رتبتك في لوحة الصدارة لزيادة فرصك في التعاون'),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('إغلاق')),
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
          Text(question, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF344966))),
          const SizedBox(height: 4),
          Text(answer, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          const Divider(),
        ],
      ),
    );
  }

  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('تسجيل الخروج'),
          content: const Text('هل أنت متأكد أنك تريد مغادرة التطبيق الآن؟'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                onLogout();
              }, 
              child: const Text('خروج', style: TextStyle(color: Colors.red))
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryNavy = Color(0xFF344966);
    Color sectionBg = isDarkMode ? Colors.grey[900]! : const Color(0xFFF3F5F9);

    return Scaffold(
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
                  buildSettingsItem(Icons.person_outline, 'الملف الشخصي', isDarkMode, () {}),
                  
                  buildSettingsItem(Icons.lightbulb_outline, 'مساعدك في التعلم', isDarkMode, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                    );
                  }),
                  
                  buildSettingsItem(Icons.notifications_none, 'جلسات التعلم', isDarkMode, () {}, isLast: true),
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
                trailing: Switch(value: isDarkMode, onChanged: onThemeChanged, activeColor: primaryNavy),
              ),
            ),
            const SizedBox(height: 30),
            const Text('الإجراءات', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(color: sectionBg, borderRadius: BorderRadius.circular(15)),
              child: Column(
                children: [
                  buildSettingsItem(Icons.help_outline, 'الأسئلة الشائعة', isDarkMode, () => showFAQDialog(context)),
                  buildSettingsItem(Icons.logout, 'تسجيل الخروج', isDarkMode, () => showLogoutDialog(context), isLast: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSettingsItem(IconData icon, String title, bool isDark, VoidCallback onTap, {bool isLast = false}) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: isDark ? Colors.white70 : Colors.black54),
          title: Text(title, style: const TextStyle(fontSize: 16)),
          trailing: const Icon(Icons.arrow_back_ios, size: 16, color: Colors.black26),
          onTap: onTap,
        ),
        if (!isLast) Divider(height: 1, indent: 50, endIndent: 20, color: isDark ? Colors.white10 : Colors.black12),
      ],
    );
  }
}
