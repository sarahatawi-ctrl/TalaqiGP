import 'package:flutter/material.dart';
import 'Chat.dart'; // Import the ChatScreen





class RequestsPage extends StatefulWidget {
  const RequestsPage({super.key});


  @override
  State<RequestsPage> createState() => _RequestsPageState();
}


class _RequestsPageState extends State<RequestsPage> {
  static const Color primaryColor = Color(0xFF2E4365);
  String? status; 


  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F6F3),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          
          automaticallyImplyLeading: false, 
          title: const Text(
            'الطلبات',
            style: TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios, color: primaryColor, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(width: 10), 
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'طلبات التعليم',
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 25),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'الكروشية',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 26,
                          backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=redProfile' ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatScreen()));
                            },
                            child: const Text(
                              'فجر',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        if (status == null) ...[
                          IconButton(
                            icon: const Icon(Icons.close, color: primaryColor),
                            onPressed: () => setState(() => status = "rejected"),
                          ),
                          IconButton(
                            icon: const Icon(Icons.check, color: primaryColor),
                            onPressed: () => setState(() => status = "accepted"),
                          ),
                        ] else
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: status == "accepted"
                                  ? Colors.green.withOpacity(0.15)
                                  : Colors.red.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              status == "accepted" ? "مقبول" : "مرفوض",
                              style: TextStyle(
                                color: status == "accepted" ? Colors.green : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

