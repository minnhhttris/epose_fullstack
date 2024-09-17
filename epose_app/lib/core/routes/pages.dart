import 'package:epose_app/core/routes/routes.dart';
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
import 'package:epose_app/features/splash/di/splash_binding.dart';
import 'package:epose_app/features/splash/presentation/pages/splash_page.dart';
import 'package:get/get.dart';

class Pages {
  static const initial = Routes.none;
  static const main = Routes.main;
  static final routes = [
    
    // màng hình chờ loading
    GetPage(
      name: Routes.none,
      page: () => const SplashPage(),
      binding: SplashBinding(),
    ),

    // màng hình chính
    GetPage(
      name: Routes.main,
      page: () => const SplashPage(),
      binding: SplashBinding(),
    ),

    // trang clothes
    GetPage(
      name: Routes.clothes,
      page: () => const ClothesPage(),
      binding: ClothesBinding(),
    ),

    // trang posts
    GetPage(
      name: Routes.posts,
      page: () => const PostsPage(),
      binding: PostsBinding(),
    ),

    // trang home 
    GetPage(
      name: Routes.home,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),

    // trang bill
    GetPage(
      name: Routes.bill,
      page: () => const BillPage(),
      binding: BillBinding(),
    ),

    // trang profile
    GetPage(
      name: Routes.profile,
      page: () => const ProfilePage(),
      binding: ProfileBinding(),
    ),

  ]; 
}
