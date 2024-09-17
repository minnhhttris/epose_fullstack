import 'dart:async';

import 'package:epose_app/core/configs/app_colors.dart';
import 'package:epose_app/core/configs/app_dimens.dart';
import 'package:epose_app/core/ui/snackbar/snackbar.dart';
import 'package:epose_app/core/ui/widgets/appbar/get_location_appbar.dart';
import 'package:epose_app/core/ui/widgets/button/button_widget.dart';
import 'package:epose_app/core/ui/widgets/text/text_widget.dart';
import 'package:epose_app/features/maps/location/models/place_map.dart';
import 'package:epose_app/features/maps/location/presentation/controller/location_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LocationPage extends GetView<LocationController> {
  const LocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocationController>(
      init: LocationController(),
      builder: (controller) {
        return Scaffold(
          appBar: const GetLocationAppbar(),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: Get.height * .1),
                        width: Get.width,
                        height: Get.height * .65,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: AppColors.gray.withOpacity(.5),
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 10,
                              right: 10,
                              child: Container(
                                width: 180,
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: AppColors.primary,
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.location_on_rounded,
                                      color: AppColors.white,
                                    ),
                                    TextWidget(
                                      text: "Current location",
                                      size: AppDimens.textSize15,
                                      color: AppColors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Maps(controller.mapController,
                                controller.initialCenter),
                            Positioned(
                                right: 5,
                                top: 5,
                                child: SizedBox(child: buttoCurrentLocation())),
                            Positioned(
                              bottom: 10,
                              right: 0,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  buttonControllerSizeMaps(
                                      controller, MapAction.resetZoom),
                                  buttonControllerSizeMaps(
                                      controller, MapAction.zoomIn),
                                  buttonControllerSizeMaps(
                                      controller, MapAction.zoomOut),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      ButtonWidget(
                        ontap: () {
                          if (controller.resutlPlaceSearch.allow()) {
                            Get.back(result: controller.resutlPlaceSearch);
                          } else {
                            SnackbarUtil.show("Please select location");
                          }
                        },
                        text: "SAVE LOCATION",
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                  Positioned(
                      child: Column(
                    children: [
                      searchBox(controller),
                      const SizedBox(
                        height: 5,
                      ),
                      GetBuilder<LocationController>(
                        id: "fetchSearchComment",
                        builder: (_) => Column(
                          children: [
                            if (controller.listLocationName.isNotEmpty)
                              for (var i = 0;
                                  i < controller.listLocationName.length;
                                  i++)
                                commentSearch(controller.listLocationName[i]),
                          ],
                        ),
                      ),
                    ],
                  )),
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return Center(
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(.6),
                                borderRadius: BorderRadius.circular(10)),
                            child: LoadingAnimationWidget.staggeredDotsWave(
                                color: AppColors.white, size: 90),
                          ),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    }),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  ElevatedButton buttoCurrentLocation() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10)),
      onPressed: () {
        controller.getCurrentLocation();
      },
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_on,
            color: AppColors.white,
          ),
          SizedBox(
            width: 5,
          ),
          TextWidget(
            text: "Get Current location",
            size: AppDimens.textSize14,
            fontWeight: FontWeight.w500,
            color: AppColors.white,
          )
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget Maps(MapController mapController, LatLng center) {
    // Define the bounds for Vietnam
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: center,
        initialZoom: 16,
        interactionOptions:
            const InteractionOptions(flags: ~InteractiveFlag.doubleTapZoom),
      ),
      children: [
        openStreetMapTileLayer,
        MarkerLayer(markers: [
          Marker(
            point: controller.initialCenter,
            width: 60,
            height: 100,
            alignment: Alignment.centerLeft,
            child: GestureDetector(
                onTap: () {
                  controller.showMarker();
                },
                child: GetBuilder<LocationController>(
                  id: "fetchMarkerLabel",
                  builder: (_) => Stack(
                    children: [
                      const Positioned(
                        bottom: 0,
                        child: Icon(
                          Icons.location_on,
                          size: 60,
                          color: AppColors.markerLocation,
                        ),
                      ),
                      controller.labelMark.value
                          ? Positioned(
                              child: Container(
                                decoration: BoxDecoration(boxShadow: [
                                  BoxShadow(
                                      color: AppColors.black.withOpacity(.2),
                                      blurRadius: 3)
                                ], color: AppColors.white),
                                child: TextWidget(
                                  text: controller
                                          .resutlPlaceSearch.displayName ??
                                      "Can't display location name",
                                  fontWeight: FontWeight.w500,
                                  size: AppDimens.textSize10,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                )),
          )
        ])
      ],
    );
  }

  TileLayer get openStreetMapTileLayer => TileLayer(
        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        userAgentPackageName: 'com.example.app',
      );

  ElevatedButton buttonControllerSizeMaps(
      LocationController controller, MapAction action) {
    IconData iconData;
    switch (action) {
      case MapAction.zoomIn:
        iconData = Icons.zoom_in;
        break;
      case MapAction.zoomOut:
        iconData = Icons.zoom_out;
        break;
      default:
        iconData = Icons.location_searching;
    }
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        backgroundColor: AppColors.primary,
      ),
      onPressed: () {
        controller.performAction(action);
      },
      child: Icon(
        iconData,
        color: AppColors.white,
        size: AppDimens.textSize26,
      ),
    );
  }


// Search Box Widget
  Widget searchBox(LocationController controller) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.gray2.withOpacity(.5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.gray.withOpacity(.3),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.search),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller.searchController,
              decoration: const InputDecoration(
                hintStyle: TextStyle(fontWeight: FontWeight.w400),
                border: InputBorder.none,
                hintText: "Enter location",
              ),
              onChanged: (value) {
                controller.debounce?.cancel();
                controller.debounce = Timer(
                  const Duration(milliseconds: 500),
                  () {
                    if (!controller.isSubmit) {
                      controller.commentSearch(
                          controller, controller.searchController.text);
                    }
                  },
                );
              },
              onSubmitted: (value) {
                controller.isSubmit = true;
                controller.searchLocation(controller, value);
              },
            ),
          ),
        ],
      ),
    );
  }

  // Optional Comment Search Widget
  Container commentSearch(dynamic locationName) {
    // goi model cua place
    PlaceMap place = PlaceMap.fromJson(locationName);
    return Container(
      width: Get.width,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 2,
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          LatLng location = LatLng(place.lat ?? 0.0, place.lon ?? 0.0);
          controller.updateMapLocation(location, dataLocaiton: locationName);
        },
        child: TextWidget(
          text: place.displayName.toString(),
          size: AppDimens.textSize14,
          color: AppColors.gray,
        ),
      ),
    );
  }
}
