import 'dart:async';
import 'package:diploma/pages/map/indoor/indoor_map.dart';
import 'package:flutter/material.dart';
import '../../constans/app_colors.dart';
import '../../services/location_service.dart';
import '../college_data/about_specialty_screen.dart';
import 'map_to_college.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  int lastZoneIndex = -1;
  int currentPageIndex = 0;
  final screens = const [MapToCollege(), IndoorMap(), AboutSpecialtyScreen()];
  NavigationDestinationLabelBehavior labelBehavior = NavigationDestinationLabelBehavior.onlyShowSelected;
  final LocationService locationService = LocationService();
  late StreamSubscription locationSubscription;


  @override
  void initState() {
    super.initState();
    locationSubscription = locationService.startTrackingLocation(
      onZoneChanged: (index) {
        if (lastZoneIndex != index) {
          setState(() {
            currentPageIndex = index;
            lastZoneIndex = index;
          });
        }
      },
    );
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
      bottomNavigationBar: NavigationBar(
        backgroundColor: AppColors.secondaryBackground,
        labelBehavior: labelBehavior,
        selectedIndex: currentPageIndex,
        indicatorColor: AppColors.accent,
        onDestinationSelected: (i) => setState(() => currentPageIndex = i),
        destinations: [
          NavigationDestination(icon: Icon(Icons.map, color: AppColors.text), label: "Шлях до коледжу"),
          NavigationDestination(icon: Icon(Icons.apartment, color: AppColors.text), label: "Мапа коледжу"),
          NavigationDestination(icon: Icon(Icons.book, color: AppColors.text), label: "Про спеціальність"),
        ],
      ),
      body: IndexedStack(index: currentPageIndex, children: screens),
    );
  }
}
