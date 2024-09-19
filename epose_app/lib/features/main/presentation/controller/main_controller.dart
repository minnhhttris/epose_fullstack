import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/configs/enum.dart';
import '../../../../core/ui/dialogs/dialogs.dart';
import '../../nav/bill/di/bill_binding.dart';
import '../../nav/bill/presentation/page/bill_page.dart';
import '../../nav/clothes/di/clothes_binding.dart';
import '../../nav/clothes/presentation/page/clothes_page.dart';
import '../../nav/home/di/home_binding.dart';
import '../../nav/home/presentation/page/home_page.dart';
import '../../nav/posts/di/posts_binding.dart';
import '../../nav/posts/presentation/page/posts_page.dart';
import '../../nav/profile/di/profile_binding.dart';
import '../../nav/profile/presentation/page/profile_page.dart';

class MainController extends GetxController {
  RxInt currentIndex = 0.obs;

  //final GetuserUseCase _getuserUseCase;

  //MainController(this._getuserUseCase, this.locationService);

  bool user = false;

  var isLocationServiceEnabled = false.obs;

  var showRequiredLocationBox = true.obs;
  
  
  @override
  void onInit() {
    super.onInit();
  }

  Future<void> initializeLocation() async {
    isLoading.value = true;
    isLoading.value = false;
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
