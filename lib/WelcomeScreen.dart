import 'package:flutter/material.dart';
import 'ChatbotView.dart'; 

class AIWelcomeScreen extends StatelessWidget {
  final VoidCallback? onContinue;

  const AIWelcomeScreen({super.key, this.onContinue});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6F3),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2E4365)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      extendBodyBehindAppBar: true, 
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isSmallScreen = constraints.maxHeight < 600;
            final imageHeight = isSmallScreen ? constraints.maxHeight * 0.35 : constraints.maxHeight * 0.45;
            
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: constraints.maxHeight * 0.08),
                          Text(
                            'مساعدك في التعلم!',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 28 : 32,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF2C2C2C),
                            ),
                            textAlign: TextAlign.center,
                            textDirection: TextDirection.rtl,
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              'باستخدام مساعد الذكاء الاصطناعي\nستتمكن من اختيار جلسة التعلم المناسبة',
                              style: TextStyle(
                                fontSize: isSmallScreen ? 18 : 20,
                                color: const Color(0xFF8A8A8A),
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                          SizedBox(height: constraints.maxHeight * 0.05),
                          SizedBox(
                            height: imageHeight,
                            child: Center(
                              child: Icon(
                                Icons.smart_toy_outlined,
                                size: imageHeight * 0.8,
                                color: const Color(0xFF3A4F6C),
                              ),
                            ),
                          ),
                          SizedBox(height: constraints.maxHeight * 0.05),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56.0,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ChatbotView()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E4365),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
                        elevation: 0,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'إكمال',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                          SizedBox(width: 12),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
