import 'dart:async';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import '../constans/app_colors.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  static const LatLng destination = LatLng(49.587832, 34.542990);
  LocationData? currentLocation;
  List<LatLng> polylineCoordinates = [];

  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor userCurrentLocationIcon = BitmapDescriptor.defaultMarker;

  void getCurrentLocation() async {
    Location location = Location();

    location.getLocation().then((location) {
      currentLocation = location;
      setState(() {});
      getPolyPoints();
    });

    GoogleMapController googleMapController = await _controller.future;

    location.onLocationChanged.listen((newLocation) {
      currentLocation = newLocation;

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

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: dotenv.env['API_KEY'],
      request: PolylineRequest(
        origin: PointLatLng(
          currentLocation!.latitude!,
          currentLocation!.longitude!,
        ),
        destination: PointLatLng(destination.latitude, destination.longitude),
        mode: TravelMode.driving,
      ),
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
      setState(() {});
    }
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
    getCurrentLocation();
    changeMapIcon();
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
                polylines: {
                  Polyline(
                    polylineId: PolylineId("route"),
                    points: polylineCoordinates,
                    color: AppColors.accent
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
                    icon: userCurrentLocationIcon
                  ),
                },
                onMapCreated: (mapController) {
                  _controller.complete(mapController);
                },
              ),
    );
  }
}
