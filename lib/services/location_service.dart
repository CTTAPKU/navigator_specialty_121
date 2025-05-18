import 'package:location/location.dart';

class LocationService {
  final Location location = Location();

  Future<LocationData> getCurrentLocation() async {
    return await location.getLocation();
  }

  Stream<LocationData> getLocationStream() {
    return location.onLocationChanged;
  }

}