import 'package:diploma/pages/map/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constans/app_colors.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  void saveCheckboxStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("loginStatus", true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              SizedBox(height: 100),
              Image.asset('assets/images/pppclogo.png', height: 90),
              SizedBox(height: 80),
              Text(
                "ВІТАЄМО У НАВІГАТОРІ-ПУТІВНИКУ",
                style: TextStyle(
                  color: AppColors.text,
                  fontSize: 40,
                  fontFamily: 'NotoSans',
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                "Тут ви знайдете інформацію про коледж та дізнаєтеся більше про свою спеціальність.",
                style: TextStyle(
                  color: AppColors.text,
                  fontSize: 20,
                  fontFamily: 'NotoSans',
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 80),
            child: TextButton(
              onPressed: () {
                saveCheckboxStatus();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const MapScreen())
                );
              },
              style: TextButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: Size(320, 80),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: Text(
                "ЗНАЙТИ СВІЙ ШЛЯХ",
                style: TextStyle(
                  color: AppColors.text,
                  fontSize: 20,
                  fontFamily: 'NotoSans',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
