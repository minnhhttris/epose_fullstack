import 'dart:async';
import 'dart:convert';
import 'package:epose_app/core/configs/app_constants.dart';
import 'package:epose_app/core/ui/snackbar/snackbar.dart';
import 'package:epose_app/features/maps/location/models/place_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

enum MapAction {
  zoomIn,
  zoomOut,
  resetZoom,
}

// Location Controller
class LocationController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final MapController mapController = MapController();

  LatLng initialCenter = const LatLng(10.0323, 105.7682);

  TextEditingController searchController = TextEditingController();

  bool isSubmit = false;
  var labelMark = false.obs;
  var currentZoom = 16.0.obs;
  var isLoading = false.obs; // Add this variable to track loading state

  Timer? debounce;

  var listLocationName = <dynamic>[];

  late PlaceMap resutlPlaceSearch = PlaceMap();

  late AnimationController animationController;

  var dataAgument = Get.arguments;

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    if (dataAgument is Map<String, dynamic>) {
      var placeMap = dataAgument['placeMap'] as Map<String, dynamic>;
      LatLng latlng =
          LatLng(double.parse(placeMap['lat']), double.parse(placeMap['lon']));
      initialCenter = latlng;
      if (placeMap['display_name'] != AppConstants.disPlayLoacionCurrent) {
        resutlPlaceSearch.displayName = placeMap['display_name'];
      }
    }
  }

  void setLoading(bool value) {
    isLoading.value = value;
  }

  // ============= CONTROL ZOOM-IN, ZOOM-OUT AND RETURN TO MARKER
  void performAction(MapAction action) {
    switch (action) {
      case MapAction.zoomIn:
        currentZoom.value++;
        _animatedMove(mapController.camera.center, currentZoom.value);
        break;
      case MapAction.zoomOut:
        currentZoom.value--;
        _animatedMove(mapController.camera.center, currentZoom.value);
        break;
      case MapAction.resetZoom:
        currentZoom.value = 16.0;
        _animatedMove(initialCenter, currentZoom.value);
        break;
    }
  }

  //============== SHOW MARKER NAME LOCAION DEFAULT STATUS IS HIDDEN
  void showMarker() {
    labelMark.value = !labelMark.value;
    update(["fetchMarkerLabel"]);
    Timer(const Duration(seconds: 3), () {
      // Hide the marker
      labelMark.value = false;
      update(["fetchMarkerLabel"]);
    });
  }

  // check khu vuc trong phạm vi việt nam
  bool isWithinBounds(double latitude, double longitude) {
    return latitude >= 8.1790665 &&
        latitude <= 23.393395 &&
        longitude >= 102.14441 &&
        longitude <= 109.464202;
  }

  //================= MOVE MARKER TO NEW LOCATION AND UPDATE MAP ====================================
  void updateMapLocation(LatLng newCenter, {dynamic dataLocaiton}) {
    if (dataLocaiton != null) {
      try {
        PlaceMap place = PlaceMap.fromJson(dataLocaiton);
        // Check if the location is within the boundaries of Vietnam
        if (isWithinBounds(newCenter.latitude, newCenter.longitude)) {
          mapController.move(newCenter, mapController.camera.zoom);
          initialCenter = newCenter;
          resutlPlaceSearch = place;
          update();
          resetSearch();
        } else {
          SnackbarUtil.show("Errors outside the scope of search");
        }
      } catch (e) {
        print('Data location is invalid: $e');
      }
    } else {
      mapController.move(newCenter, mapController.camera.zoom);
      initialCenter = newCenter;
      resutlPlaceSearch = PlaceMap();
      resutlPlaceSearch.displayName = AppConstants.disPlayLoacionCurrent;
      resutlPlaceSearch.lat = initialCenter.latitude;
      resutlPlaceSearch.lon = initialCenter.longitude;
      update();
      resetSearch();
    }
  }

  //======================  REST SEARCH ======================================
  void resetSearch() {
    listLocationName = [];
    searchController.text = "";
    isSubmit = false;
    update(['fetchSearchComment']);
  }

  //=====================  GET CURRENT LOCATION FUNCTION ===================================
  Future<void> getCurrentLocation() async {
    setLoading(true);
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setLoading(false);
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setLoading(false);
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setLoading(false);
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    LatLng currentLocation = LatLng(position.latitude, position.longitude);
    setLoading(false);
    resutlPlaceSearch.displayName = "your current Locaiton";
    updateMapLocation(currentLocation);
  }

  // =========================== SEARCH FUNCTION ===============================
  Future<void> searchLocation(
      LocationController controller, String query) async {
    setLoading(true);
    final response = await http.get(
      Uri.parse(
          'https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=1'),
    );
    if (response.statusCode == 200) {
      final List results = json.decode(response.body);
      if (results.isNotEmpty) {
        // Check if the location is within the boundaries of Vietnam
        LatLng latLng = LatLng(
            double.parse(results[0]['lat']), double.parse(results[0]['lon']));
        updateMapLocation(latLng, dataLocaiton: results[0]);
      }
    }
    setLoading(false);
  }

  //==================== COMMENT SEARCH FUNCITON ==========================
  Future<void> commentSearch(
      LocationController controller, String query) async {
    setLoading(true);
    final response = await http.get(
      Uri.parse(
          'https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=1'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> results = json.decode(response.body);

      if (results.isNotEmpty) {
        PlaceMap place = PlaceMap.fromJson(results[0]);
        if (isWithinBounds(place.lat ?? 0.0, place.lon ?? 0.0)) {
          listLocationName = results;
        } else {
          listLocationName = [];
        }
      } else {
        listLocationName = [];
      }
      update(['fetchSearchComment']);
    }
    setLoading(false);
  }

  //=============================== ANIMATION MOVE ============================
  void _animatedMove(LatLng destLocation, double destZoom) {
    final latTween = Tween<double>(
      begin: mapController.camera.center.latitude,
      end: destLocation.latitude,
    );
    final lngTween = Tween<double>(
      begin: mapController.camera.center.longitude,
      end: destLocation.longitude,
    );
    final zoomTween = Tween<double>(
      begin: mapController.camera.zoom,
      end: destZoom,
    );

    Animation<double> animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.fastOutSlowIn,
    );

    animationController.addListener(() {
      mapController.move(
        LatLng(
          latTween.evaluate(animation),
          lngTween.evaluate(animation),
        ),
        zoomTween.evaluate(animation),
      );
    });

    animationController.forward(from: 0.0);
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
