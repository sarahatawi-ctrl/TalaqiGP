import 'package:flutter/material.dart';

class RequestsPage extends StatelessWidget {
  const RequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, 
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          // سهم العودة (تم استبداله ليكون متوافقاً مع RTL)
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.brown),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'الطلبات',
            style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, 
            children: [
              const Text(
                'طلبات التعليم\nالكروشية',
                style: TextStyle(color: Colors.grey, height: 1.5),
              ),
              const SizedBox(height: 20),
              
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.blueGrey.withOpacity(0.1)),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage('assets/redProfileIcon.png'),
                    ),
                    const SizedBox(width: 15),
                    
                    const Text(
                      'فجر',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    
                    const Spacer(),
                    
                    const Icon(Icons.cancel_outlined, color: Colors.brown, size: 28),
                    const SizedBox(width: 10),
                    const Icon(Icons.check_circle_outline, color: Colors.brown, size: 28),
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
