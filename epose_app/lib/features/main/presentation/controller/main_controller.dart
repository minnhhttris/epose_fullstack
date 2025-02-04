import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/configs/enum.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/services/user/domain/use_case/get_user_use_case.dart';
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
  RxInt currentIndex = 2.obs;

  final GetuserUseCase _getuserUseCase;

  MainController(this._getuserUseCase);

  late bool user;

  Future<void> checkIfUserLoggedIn() async {
    final user = await _getuserUseCase.getUser();
    this.user = user != null; 
    update(); 
  }

  
  
  @override
  void onInit() {
    super.onInit();
    checkIfUserLoggedIn(); 
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
        page: () => ClothesPage(),
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

    if ((index == 1 || index == 3 || index== 4) && !user) {
      DialogsUtils.showAlertDialog2(
          title: "Chưa đăng nhập",
          message: "Bạn có muốn đăng nhập để sử dụng chức năng này không?",
          typeDialog: TypeDialog.warning,
          onPress: () {
            Get.offAllNamed(Routes.login);
          }
        );
    }

    currentIndex.value = index;

    Get.offAndToNamed(pages[index], id: 10);
  }
}
