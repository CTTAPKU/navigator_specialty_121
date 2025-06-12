import 'dart:async';
import 'package:diploma/services/polyline_service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import '../../constans/app_colors.dart';
import '../../services/location_service.dart';

class MapToCollege extends StatefulWidget {
  const MapToCollege({super.key});

  @override
  State<MapToCollege> createState() => _MapToCollegeState();
}

class _MapToCollegeState extends State<MapToCollege> {
  final Completer<GoogleMapController> _controller = Completer();
  static const LatLng destination = LatLng(49.587832, 34.542990);
  LocationData? currentLocation;
  List<LatLng> polylineCoordinates = [];

  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor userCurrentLocationIcon = BitmapDescriptor.defaultMarker;

  final LocationService locationService = LocationService();
  late StreamSubscription<LocationData> locationSubscription;

  Future<void> initializeLocation() async {
    currentLocation = await locationService.getCurrentLocation();
    if (currentLocation != null) {
      polylineCoordinates =
      await PolylineService().getPolyPoints(currentLocation!);
      setState(() {});
    }

    locationSubscription =
        locationService.getLocationStream().listen((newLocation) async {
          currentLocation = newLocation;
          GoogleMapController googleMapController = await _controller.future;
          googleMapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                zoom: 17.5,
                target: LatLng(newLocation.latitude!, newLocation.longitude!),
              ),
            ),
          );
          setState(() {});
        });
  }



  void changeMapIcon() {
    BitmapDescriptor.asset(
      ImageConfiguration(size: Size(50, 50)),
      "assets/images/pppclogo.png",
    ).then((icon) {
      destinationIcon = icon;
    });

    BitmapDescriptor.asset(
      ImageConfiguration(size: Size(50, 50)),
      "assets/icons/point.png",
    ).then((icon) {
      userCurrentLocationIcon = icon;
    });
  }

  @override
  void initState() {
    super.initState();
    initializeLocation();
    changeMapIcon();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
      backgroundColor: AppColors.secondaryBackground,
      title: Text("Шлях до коледжу", style: TextStyle(color: AppColors.text, fontFamily: 'NotoSans')),
      centerTitle: true,
      shape: Border(bottom: BorderSide(color: AppColors.primary, width: 2)),
    ),
      body: currentLocation == null
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(
                currentLocation!.latitude!,
                currentLocation!.longitude!,
              ),
              zoom: 15,
            ),
            polylines: {
              Polyline(
                polylineId: PolylineId("route"),
                points: polylineCoordinates,
                color: AppColors.accent,
              ),
            },
            markers: {
              Marker(
                markerId: MarkerId("destination"),
                position: destination,
                icon: destinationIcon,
              ),
              Marker(
                markerId: MarkerId("currentLoc"),
                position: LatLng(
                  currentLocation!.latitude!,
                  currentLocation!.longitude!,
                ),
                icon: userCurrentLocationIcon,
              ),
            },
            onMapCreated: (mapController) {
              _controller.complete(mapController);
            },
            mapToolbarEnabled: false,
          ),
    );
  }
}
