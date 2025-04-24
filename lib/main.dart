import 'package:diploma/pages/map_screen.dart';
import 'package:diploma/pages/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(
    MaterialApp(
      home: const MapScreen(),
    ),
  );
}
