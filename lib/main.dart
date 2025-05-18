import 'package:diploma/pages/map_screen.dart';
import 'package:diploma/pages/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarIconBrightness: Brightness.dark,
  ));
  await dotenv.load(fileName: "data.env");
  runApp(
    MaterialApp(
      home: const WelcomePage(),
    ),
  );
}
