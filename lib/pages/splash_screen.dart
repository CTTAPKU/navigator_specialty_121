import 'package:diploma/pages/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constans/app_colors.dart';
import 'map_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () async {
      final prefs = await SharedPreferences.getInstance();
      final loginStatus = prefs.getBool('loginStatus') ?? false;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => loginStatus ? MapScreen() : WelcomePage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: CircularProgressIndicator(), // або твій логотип
      ),
    );
  }
}
