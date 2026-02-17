import 'package:flutter/material.dart';
import 'badge_widget.dart';

class BadgesScreen extends StatelessWidget {
  const BadgesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF5D4037),
            size: 20,
          ),
          onPressed: () {
           
            Navigator.of(context).pop();
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                'الأوسمة',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {

            double badgeSize = _calculateBadgeSize(constraints.maxWidth);
            
            return Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                    
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: _calculateSpacing(constraints.maxWidth),
                        runSpacing: 20,
                        children: [
                          BadgeWidget(
                            number: '5',
                            label: 'ساعات',
                            isOrange: true,
                            size: badgeSize,
                          ),
                          BadgeWidget(
                            number: '10',
                            label: 'ساعات',
                            isOrange: true,
                            size: badgeSize,
                          ),
                          BadgeWidget(
                            number: '15',
                            label: 'ساعة',
                            isOrange: true,
                            size: badgeSize,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                   
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: _calculateSpacing(constraints.maxWidth),
                        runSpacing: 20,
                        children: [
                          BadgeWidget(
                            number: '20',
                            label: 'ساعة',
                            isOrange: false,
                            size: badgeSize,
                          ),
                          BadgeWidget(
                            number: '25',
                            label: 'ساعة',
                            isOrange: false,
                            size: badgeSize,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

 
  double _calculateBadgeSize(double screenWidth) {
    if (screenWidth < 600) {
      
      return 100.0;
    } else if (screenWidth < 900) {
     
      return 120.0;
    } else {
      
      return 140.0;
    }
  }

 
  double _calculateSpacing(double screenWidth) {
    if (screenWidth < 600) {
    
      return 16.0;
    } else if (screenWidth < 900) {
      
      return 24.0;
    } else {
      
      return 32.0;
    }
  }
}
