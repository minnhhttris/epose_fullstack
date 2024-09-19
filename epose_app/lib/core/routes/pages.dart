import 'package:get/get.dart';

import '../../features/login/di/login_binding.dart';
import '../../features/login/presentation/page/login_page.dart';
import '../../features/main/nav/bill/di/bill_binding.dart';
import '../../features/main/nav/bill/presentation/page/bill_page.dart';
import '../../features/main/nav/clothes/di/clothes_binding.dart';
import '../../features/main/nav/clothes/presentation/page/clothes_page.dart';
import '../../features/main/nav/home/di/home_binding.dart';
import '../../features/main/nav/home/presentation/page/home_page.dart';
import '../../features/main/nav/posts/di/posts_binding.dart';
import '../../features/main/nav/posts/presentation/page/posts_page.dart';
import '../../features/main/nav/profile/di/profile_binding.dart';
import '../../features/main/nav/profile/presentation/page/profile_page.dart';
import '../../features/register/di/register_binding.dart';
import '../../features/register/presentation/page/register_page.dart';
import '../../features/splash/di/splash_binding.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import 'routes.dart';

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

    // màng hình login
    GetPage(
      name: Routes.login,
      page: () => const LoginPage(),
      binding: LoginBinding(),
    ),

    // màng hình register
    GetPage(
      name: Routes.register,
      page: () => const RegisterPage(),
      binding: RegisterBinding(),
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
