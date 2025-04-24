import 'dart:async';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import '../constans/app_colors.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  LocationData? currentLocation;

  void getCurrentLocation() {
    Location location = Location();

    location.getLocation().then((location) {
      currentLocation = location;
      setState(() {});
    });

    location.onLocationChanged.listen((newLocation) async {
      currentLocation = newLocation;
      GoogleMapController googleMapController = await _controller.future;

      googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            zoom: 18,
            target: LatLng(newLocation.latitude!, newLocation.longitude!),
          ),
        ),
      );

      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(
          "Шлях до коледжу",
          style: TextStyle(color: AppColors.text, fontFamily: 'NotoSans'),
        ),
        centerTitle: true,
        leading: Icon(Icons.menu),
        shape: Border(bottom: BorderSide(color: AppColors.accent, width: 2)),
      ),
      body:
          currentLocation == null
              ? Center(
                child: CircularProgressIndicator(),
              ) // або splash/map loading
              : GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    currentLocation!.latitude!,
                    currentLocation!.longitude!,
                  ),
                  zoom: 15,
                ),
                onMapCreated: (mapController) {
                  _controller.complete(mapController);
                },
              ),
    );
  }
}
