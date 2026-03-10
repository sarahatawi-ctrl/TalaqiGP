import 'package:flutter/material.dart';

void main() {
  runApp(const TalaqiAdmin());
}

class TalaqiAdmin extends StatelessWidget {
  const TalaqiAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AdminReportsPage(),
    );
  }
}

class AdminReportsPage extends StatelessWidget {
  const AdminReportsPage({super.key});

  static const Color primary = Color(0xFF344966);

  final List<Map<String, dynamic>> reports = const [
    {
      "name": "محمد أحمد",
      "email": "mohamed@gmail.com",
      "reason": "محتوى غير لائق",
      "details": "المستخدم يرسل رسائل غير مناسبة في المحادثة.",
      "image": "https://i.pravatar.cc/150?img=3"
    },
    {
      "name": "سارة علي",
      "email": "sara@gmail.com",
      "reason": "سلوك مسيء أو تنمر",
      "details": "تم استخدام ألفاظ غير محترمة أثناء النقاش.",
      "image": "https://i.pravatar.cc/150?img=5"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: primary,
          centerTitle: true,
          title: const Text(
            "البلاغات",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: reports.length,
          itemBuilder: (context, index) {
            final item = reports[index];
            return _reportCard(context, item);
          },
        ),
      ),
    );
  }

  Widget _reportCard(BuildContext context, Map item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundImage: NetworkImage(item["image"]),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item["name"],
                  style:
                      const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 4),
                Text(
                  item["email"],
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 6),
                Text("سبب البلاغ: ${item["reason"]}"),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_left, color: primary),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ReportDetailsPage(data: item),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

class ReportDetailsPage extends StatelessWidget {
  final Map data;

  const ReportDetailsPage({super.key, required this.data});

  static const Color primary = Color(0xFF344966);

  void showPopup(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle_outline,
              size: 70,
              color: primary,
            ),
            const SizedBox(height: 15),
            Text(
              message,
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("موافق"),
            )
          ],
        ),
      ),
    );
  }

  Widget infoBox(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: primary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: primary,
          leading: IconButton(
            icon: const Icon(Icons.chevron_right, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            "تفاصيل البلاغ",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(data["image"]),
              ),
              const SizedBox(height: 20),
              Text(
                data["name"],
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(
                data["email"],
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 25),

              infoBox("سبب البلاغ", data["reason"]),
              infoBox("تفاصيل إضافية", data["details"]),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        showPopup(context, "تم تجاهل البلاغ");
                      },
                      child: const Text("تجاهل"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        showPopup(context, "تم إرسال تنبيه للمستخدم");
                      },
                      child: const Text("تنبيه"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        showPopup(context, "تم حظر المستخدم");
                      },
                      child: const Text("حظر"),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
