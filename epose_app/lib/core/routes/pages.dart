import 'package:get/get.dart';

import '../../features/accountSetting/di/accountSetting_binding.dart';
import '../../features/accountSetting/presentation/page/accountSetting_page.dart';
import '../../features/addInfomationRegister/di/addInfomationRegister_binding.dart';
import '../../features/addInfomationRegister/presentation/page/addInfomationRegister_page.dart';
import '../../features/bagShopping/di/bagShopping_binding.dart';
import '../../features/bagShopping/presentation/page/bagShopping_page.dart';
import '../../features/createClothes/di/createClothes_binding.dart';
import '../../features/createClothes/presentation/page/createClothes_page.dart';
import '../../features/createPosts/di/createPosts_binding.dart';
import '../../features/createPosts/presentation/page/createPosts_page.dart';
import '../../features/createStore/di/createStore_binding.dart';
import '../../features/createStore/presentation/page/createStore_page.dart';
import '../../features/details_clothes/di/details_posts_binding.dart';
import '../../features/details_clothes/presentation/page/details_posts_page.dart';
import '../../features/details_posts/di/details_clothes_binding.dart';
import '../../features/details_posts/presentation/page/details_clothes_page.dart';
import '../../features/login/di/login_binding.dart';
import '../../features/login/presentation/page/login_page.dart';
import '../../features/main/di/main_binding.dart';
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
import '../../features/main/presentation/page/main_page.dart';
import '../../features/message/di/message_binding.dart';
import '../../features/message/presentation/page/message_page.dart';
import '../../features/notify/di/notify_binding.dart';
import '../../features/notify/presentation/page/notify_page.dart';
import '../../features/onBoarding/di/onBoarding_binding.dart';
import '../../features/onBoarding/presentation/page/onBoarding_page.dart';
import '../../features/policySecurity/di/policySecurity_binding.dart';
import '../../features/policySecurity/presentation/page/policySecurity_page.dart';
import '../../features/register/di/register_binding.dart';
import '../../features/register/presentation/page/register_page.dart';
import '../../features/sales/di/sales_binding.dart';
import '../../features/sales/presentation/page/sales_page.dart';
import '../../features/search/di/search_binding.dart';
import '../../features/search/presentation/page/search_page.dart';
import '../../features/setPin/di/setPin_binding.dart';
import '../../features/setPin/presentation/page/setPin_page.dart';
import '../../features/settingInfomation/di/settingInfomation_binding.dart';
import '../../features/settingInfomation/presentation/page/settingInfomation_page.dart';
import '../../features/splash/di/splash_binding.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/store/di/store_binding.dart';
import '../../features/store/presentation/page/store_page.dart';
import '../../features/verifyOTP/di/verifyOTP_binding.dart';
import '../../features/verifyOTP/presentation/page/verifyOTP_page.dart';
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

    // màng hình onBoarding
    GetPage(
      name: Routes.onboarding,
      page: () => OnBoardingPage(),
      binding: OnBoardingBinding(),
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
      page: () => const MainPage(),
      binding: MainBinding(),
    ),

    // màng hình verifyOTP
    GetPage(
      name: Routes.verifyOTP,
      page: () => const VerifyOTPPage(),
      binding: VerifyOTPBinding(),
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

    // trang accountSetting
    GetPage(
      name: Routes.accountSetting,
      page: () => const AccountSettingPage(),
      binding: AccountSettingBinding(),
    ),

    //trang bagShopping
    GetPage(
      name: Routes.bagShopping,
      page: () => const BagShoppingPage(),
      binding: BagShoppingBinding(),
    ),

    // trang AddInfomationRegister
    GetPage(
      name: Routes.addInfomationRegister,
      page: () => const AddInfomationRegisterPage(),
      binding: AddInfomationRegisterBinding(),
    ),

    // trang message
    GetPage(
      name: Routes.mesage,
      page: () => const MessagePage(),
      binding: MessageBinding(),
    ),

    // trang notify
    GetPage(
      name: Routes.notify,
      page: () => const NotifyPage(),
      binding: NotifyBinding(),
    ),

    // trang PolicySecurity
    GetPage(
      name: Routes.policySecurity,
      page: () => const PolicySecurityPage(),
      binding: PolicySecurityBinding(),
    ),

    // trang store
    GetPage(
      name: Routes.store,
      page: () => const StorePage(),
      binding: StoreBinding(),
    ),

    // trang setPin
    GetPage(
      name: Routes.setPin,
      page: () => const SetPinPage(),
      binding: SetPinBinding(),
    ),

    //trang sales
    GetPage(
      name: Routes.sales,
      page: () => const SalesPage(),
      binding: SalesBinding(),
    ),

    // trang settingInformation
    GetPage(
      name: Routes.settingInfomation,
      page: () => const SettingInfomationPage(),
      binding: SettingInfomationBinding(),
    ),

    // trang Search
    GetPage(
      name: Routes.search,
      page: () => const SearchPage(),
      binding: SearchBinding(),
    ),

    // trang createStore
    GetPage(
      name: Routes.createStore,
      page: () => const CreateStorePage(),
      binding: CreateStoreBinding(),
    ),

    //trang createPosts
    GetPage(
      name: Routes.createPosts,
      page: () => const CreatePostsPage(),
      binding: CreatePostsBinding(),
    ),

    //trang createClothes
    GetPage(
      name: Routes.createClothes,
      page: () => CreateClothesPage(),
      binding: CreateClothesBinding(),
    ),

    //trang detailsPosts
    GetPage(
      name: Routes.detailsPosts,
      page: () => const DetailsPostsPage(),
      binding: DetailsPostsBinding(),
    ),

    //trang detailsClothes
    GetPage(
      name: Routes.detailsClothes,
      page: () => const DetailsClothesPage(),
      binding: DetailsClothesBinding(),
    ),

  ];
}
