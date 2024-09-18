import 'package:epose_app/app_biding.dart';
import 'package:epose_app/core/configs/app_colors.dart';
import 'package:epose_app/core/routes/pages.dart';
import 'package:epose_app/core/utils/behavior.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Pages.initial,
      scrollBehavior: MyBehavior(),
      getPages: Pages.routes,
      initialBinding: AppBinding(),
      // locale: LocalizationService.locale,
      // fallbackLocale: LocalizationService.fallbackLocale,
      // translations: LocalizationService(),
      theme: ThemeData(
        appBarTheme: const AppBarTheme(backgroundColor: AppColors.white),
        scaffoldBackgroundColor: AppColors.white,
      ),
    );
  }
}
