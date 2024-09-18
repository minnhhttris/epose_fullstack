import 'package:epose_app/core/data/pref/prefs';
import 'package:epose_app/core/services/get_location_case.dart';
import 'package:epose_app/core/services/save_location_case.dart';
import 'package:epose_app/features/maps/location/models/place_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationService extends GetxService {
  final GetLocationCase getLocationCase;
  final SaveLoactionCase saveLocationCase;
  final Prefs prefs;

  LocationService(this.getLocationCase, this.saveLocationCase, this.prefs);

  Rx<PlaceMap?> place = Rx<PlaceMap?>(null);
  RxString? nameLocation;
  LatLng? latLng;

  Future<PlaceMap?> getLocation() async {
    return await getLocationCase.getLocation();
  }
  
  
  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Lưu vị trí hiện tại
    PlaceMap placeMap = PlaceMap(
      lat: position.latitude,
      lon: position.longitude,
      displayName: "Accessing your current location",
    );
    await saveLocationCase.saveLocation(placeMap);
    place.value = placeMap;
  }

  Future<void> initializeLocation() async {
    await getCurrentLocation();
  }

  Future<bool> isLocationServiceEnabled() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return false;
  }
  
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return false;
    }
  }
  
  if (permission == LocationPermission.deniedForever) {
    return false;
  }

  return true;
}
  
}
