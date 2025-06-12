import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationService {
  final Location _location = Location();
  static final LatLng firstCorner = LatLng(49.588293516204295, 34.54250456374839);
  static final LatLng secondCorner = LatLng(49.58774404905202, 34.54379202411088);
  static final LatLng thirdCorner = LatLng(49.58715284330548, 34.54324485345682);
  static final LatLng fourthCorner = LatLng(49.587723183088805, 34.54183937589443);

  Future<LocationData?> getCurrentLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        print('Location service is disabled.');
        return null;
      }
    }

    permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        print('Location permission not granted.');
        return null;
      }
    }

    try {
      return await _location.getLocation();
    } catch (e) {
      print('Failed to get location: $e');
      return null;
    }
  }

  Stream<LocationData> getLocationStream() {
    return _location.onLocationChanged;
  }

  StreamSubscription<LocationData> startTrackingLocation({
    required void Function(int zoneIndex) onZoneChanged,
  }) {
    final LatLng cornerA = firstCorner;
    final LatLng cornerB = secondCorner;
    final LatLng cornerC = thirdCorner;
    final LatLng cornerD = fourthCorner;
    int lastZoneIndex = -1;

    return getLocationStream().listen((loc) {
      final double lat = loc.latitude!;
      final double lng = loc.longitude!;

      final corners = [cornerA, cornerB, cornerC, cornerD];
            double cross(double x1, double y1, double x2, double y2) {
        return x1 * y2 - y1 * x2;
      }

      bool isInside = true;
      double? lastCross;
      for (int i = 0; i < 4; i++) {
        final a = corners[i];
        final b = corners[(i + 1) % 4];

        double dx1 = b.latitude - a.latitude;
        double dy1 = b.longitude - a.longitude;
        double dx2 = lat - a.latitude;
        double dy2 = lng - a.longitude;
        double c = cross(dx1, dy1, dx2, dy2);

        if (i == 0) {
          lastCross = c;
        } else {
          if ((lastCross! >= 0 && c < 0) || (lastCross < 0 && c >= 0)) {
            isInside = false;
            break;
          }
        }
      }

      final int zoneIndex = isInside ? 1 : 0;
      if (zoneIndex != lastZoneIndex) {
        lastZoneIndex = zoneIndex;
        onZoneChanged(zoneIndex);
      }
    });
  }
}