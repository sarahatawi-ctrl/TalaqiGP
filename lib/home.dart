import 'package:flutter/material.dart';
import 'Leaderboard.dart';
import 'Setting.dart';
import 'CreateSkillPage.dart'; // Import the CreateSkillPage


class HomePage extends StatefulWidget {
  const HomePage({super.key});


  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  final List<Map<String, String>> _allItems = [
    {'title': 'تصميم الواجهات', 'name': 'محمد أحمد', 'image': 'https://i.pravatar.cc/150?u=11'},
    {'title': 'برمجة فلاتر', 'name': 'شذا محمد', 'image': 'https://i.pravatar.cc/150?u=12'},
    {'title': 'اللغة الانجليزية', 'name': 'مهند فيصل', 'image': 'https://i.pravatar.cc/150?u=13'},
    {'title': 'تطوير المواقع', 'name': 'نورة محمد', 'image': 'https://i.pravatar.cc/150?u=14'},
    {'title': 'تحليل البيانات', 'name': 'أحمد عبدالحميد', 'image': 'https://i.pravatar.cc/150?u=15'},
    {'title': 'التسويق الرقمي', 'name': 'سارة علي', 'image': 'https://i.pravatar.cc/150?u=16'},
    {'title': 'الأمن السيبراني', 'name': 'خالد فهد', 'image': 'https://i.pravatar.cc/150?u=17'},
    {'title': 'إدارة المشاريع', 'name': 'ريم عبدالله', 'image': 'https://i.pravatar.cc/150?u=18'},
    {'title': 'الذكاء الاصطناعي', 'name': 'فيصل حسن', 'image': 'https://i.pravatar.cc/150?u=19'},
    {'title': 'التصميم الجرافيكي', 'name': 'ليلى إبراهيم', 'image': 'https://i.pravatar.cc/150?u=20'},
  ];


  List<Map<String, String>> _displayedItems = [];
  final TextEditingController _searchController = TextEditingController( );


  @override
  void initState() {
    super.initState();
    _displayedItems = List.from(_allItems);
    _searchController.addListener(_filterItems);
  }


  @override
  void dispose() {
    _searchController.removeListener(_filterItems);
    _searchController.dispose();
    super.dispose();
  }


  void _filterItems() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _displayedItems = List.from(_allItems);
      } else {
        _displayedItems = _allItems.where((item) {
          final title = item['title']!.toLowerCase();
          final name = item['name']!.toLowerCase();
          return title.contains(query) || name.contains(query);
        }).toList();
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F6F3),
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                  ),
                  child: TextField(
                    controller: _searchController,
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 18),
                    decoration: const InputDecoration(
                      hintText: 'بحث في المهارات أو الأشخاص...',
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _displayedItems.length,
                  itemBuilder: (context, index) {
                    final item = _displayedItems[index];
                    return _buildCard(item['title']!, item['name']!, item['image']!); 
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateSkillScreen()));
          },
          backgroundColor: const Color(0xFF2E4365),
          child: const Icon(Icons.add, color: Colors.white, size: 30),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF1A237E),
          unselectedItemColor: Colors.grey,
          currentIndex: 0,
          onTap: (index) {
            if (index == 4) Navigator.push(context, MaterialPageRoute(builder: (context) => const Setting()));
            if (index == 1) Navigator.push(context, MaterialPageRoute(builder: (context) => const Leaderboard()));
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
            BottomNavigationBarItem(icon: Icon(Icons.star_outline), label: 'لوحة الصدارة'),
            BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'المحادثة'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'الملف الشخصي'),
            BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'الاعدادات'),
          ],
        ),
      ),
    );
  }


  Widget _buildCard(String title, String name, String imageUrl) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          CircleAvatar(radius: 35, backgroundColor: Colors.grey[200], backgroundImage: NetworkImage(imageUrl)),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 4),
                Text(name, style: const TextStyle(color: Colors.grey, fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

