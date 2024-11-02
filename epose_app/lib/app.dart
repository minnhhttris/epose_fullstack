import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_biding.dart';
import 'core/configs/app_colors.dart';
import 'core/routes/pages.dart';
import 'core/utils/behavior.dart';

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
      theme: ThemeData(
        appBarTheme: const AppBarTheme(backgroundColor: AppColors.white),
        scaffoldBackgroundColor: AppColors.white,
      ),
    );
  }
}
