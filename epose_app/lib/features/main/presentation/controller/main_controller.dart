import 'package:epose_app/core/configs/enum.dart';
import 'package:epose_app/core/services/location_service.dart';
import 'package:epose_app/core/ui/dialogs/dialogs.dart';
import 'package:epose_app/features/main/nav/bill/di/bill_binding.dart';
import 'package:epose_app/features/main/nav/bill/presentation/page/bill_page.dart';
import 'package:epose_app/features/main/nav/clothes/di/clothes_binding.dart';
import 'package:epose_app/features/main/nav/clothes/presentation/page/clothes_page.dart';
import 'package:epose_app/features/main/nav/home/di/home_binding.dart';
import 'package:epose_app/features/main/nav/home/presentation/page/home_page.dart';
import 'package:epose_app/features/main/nav/posts/di/posts_binding.dart';
import 'package:epose_app/features/main/nav/posts/presentation/page/posts_page.dart';
import 'package:epose_app/features/main/nav/profile/di/profile_binding.dart';
import 'package:epose_app/features/main/nav/profile/presentation/page/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class MainController extends GetxController {
  RxInt currentIndex = 0.obs;

  //final GetuserUseCase _getuserUseCase;

  //MainController(this._getuserUseCase, this.locationService);

  MainController(this.locationService);

  final LocationService locationService;

  bool user = false;

  var isLocationServiceEnabled = false.obs;

  var showRequiredLocationBox = true.obs;
  
  
  @override
  void onInit() {
    super.onInit();
    // _getuserUseCase.getUser().then((value) {
    //   if (value != null) {
    //     user = true;
    //   }
    // });
    checkLocationService();
  }

  Future<void> initializeLocation() async {
    isLoading.value = true;
    await locationService.initializeLocation();
    isLoading.value = false;
  }

  Future<void> checkLocationService() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      isLocationServiceEnabled.value = false;
      return;
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        isLocationServiceEnabled.value = false;
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      isLocationServiceEnabled.value = false;
      return;
    }

    isLocationServiceEnabled.value = true;
    initializeLocation();
  }

  // ignore: non_constant_identifier_names
  Future<void> CloseRequiredLocationBox() async {
    showRequiredLocationBox.value=false;
  }

  final pages = <String>[
    '/clothes',
    '/posts',
    '/home',
    '/bill',
    '/profile'
  ];

  var isLoading = false.obs;

  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    if (settings.name == '/clothes') {
      return GetPageRoute(
        settings: settings,
        page: () => const ClothesPage(),
        binding: ClothesBinding(),
        transition: Transition.fadeIn,
      );
    }

    if (settings.name == '/posts') {
      return GetPageRoute(
        settings: settings,
        page: () => const PostsPage(),
        binding: PostsBinding(),
        transition: Transition.fadeIn,
      );
    }

    if (settings.name == '/home') {
      return GetPageRoute(
        settings: settings,
        page: () => const HomePage(),
        binding: HomeBinding(),
        transition: Transition.fadeIn,
      );
    }

    if (settings.name == '/bill') {
      return GetPageRoute(
        settings: settings,
        page: () => const BillPage(),
        binding: BillBinding(),
        transition: Transition.fadeIn,
      );
    }

    if (settings.name == '/profile') {
      return GetPageRoute(
        settings: settings,
        page: () => const ProfilePage(),
        binding: ProfileBinding(),
        transition: Transition.fadeIn,
      );
    }

    return null;
  }

  void onChangeItemBottomBar(int index) {
    if (currentIndex.value == index) return;

    if (index == 2 && !user) {
      DialogsUtils.showAlertDialog(
          title: "Don't have account",
          message: "you want login account",
          typeDialog: TypeDialog.warning);
    }

    currentIndex.value = index;

    Get.offAndToNamed(pages[index], id: 10);
  }
}
