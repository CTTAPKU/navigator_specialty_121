import 'dart:async';
import 'dart:math';

import 'package:diploma/pages/map/indoor_map.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../constans/app_colors.dart';
import 'about_specialty_screen.dart';
import 'map/map_to_college.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  bool _isInsideZone = false;
  LatLng leftCorner = LatLng(49.588146979696404, 34.54255187102403);
  LatLng rightCorner = LatLng(49.587301908027996, 34.54306953730695);
  int currentPageIndex = 0;
  final screens = const [MapToCollege(), IndoorMap(), AboutSpecialtyScreen()];
  final List<String> titles = ["Шлях до коледжу", "Мапа коледжу", "Про спеціальність"];
  NavigationDestinationLabelBehavior labelBehavior = NavigationDestinationLabelBehavior.onlyShowSelected;

  Location location = Location();
  late StreamSubscription<LocationData> locationSubscription;

  void _startTrackingLocation() {
    locationSubscription = location.onLocationChanged.listen((loc) {
      final double lat = loc.latitude!;
      final double lng = loc.longitude!;

      final double latMin = min(leftCorner.latitude, rightCorner.latitude);
      final double latMax = max(leftCorner.latitude, rightCorner.latitude);
      final double lngMin = min(leftCorner.longitude, rightCorner.longitude);
      final double lngMax = max(leftCorner.longitude, rightCorner.longitude);

      final bool isInside = lat >= latMin && lat <= latMax && lng >= lngMin && lng <= lngMax;

      if (isInside && !_isInsideZone) {
        setState(() {
          _isInsideZone = true;
          currentPageIndex = 1;
        });
      } else if (!isInside && _isInsideZone) {
        setState(() {
          _isInsideZone = false;
          currentPageIndex = 0;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _startTrackingLocation();
  }

  @override
  void dispose() {
    locationSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.secondaryBackground,
        title: Text(titles[currentPageIndex], style: TextStyle(color: AppColors.text, fontFamily: 'NotoSans')),
        centerTitle: true,
        shape: Border(bottom: BorderSide(color: AppColors.primary, width: 2)),
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: AppColors.secondaryBackground,
        labelBehavior: labelBehavior,
        selectedIndex: currentPageIndex,
        indicatorColor: AppColors.accent,
        onDestinationSelected: (i) => setState(() => currentPageIndex = i),
        destinations: [
          NavigationDestination(icon: Icon(Icons.map, color: AppColors.text), label: "Шлях до коледжу"),
          NavigationDestination(icon: Icon(Icons.home_rounded, color: AppColors.text), label: "Мапа коледжу"),
          NavigationDestination(icon: Icon(Icons.home_rounded, color: AppColors.text), label: "Про спеціальність"),
        ],
      ),
      body: IndexedStack(index: currentPageIndex, children: screens),
    );
  }
}
