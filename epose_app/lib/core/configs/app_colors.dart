import 'package:epose_app/core/extensions/color.dart';
import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF977364);
  static const primary1 = Color(0xFFF1DED6);
  static const primary2 = Color(0xFFFFF2EC);
  static const secondary  = Color(0xFFFF8B00);
  static const secondary1 = Color.fromARGB(255, 248, 133, 98);

  static const grey = Color(0xFFACACAC);
  static const grey1 = Color(0xFF9DA8C3);
  static const grey2 = Color(0xFFF1F1F1);
  static const black = Color(0xFF020112);
  static const white = Color(0xFFFFFFFF);

  static const green = Color(0xFF009432);
  static const Color red = Color(0XFFc23616);

  static const Color grayTitle = Color(0XFF50555C);

  static const Color markerLocation = Colors.red;

  static const gray = Color(0xFF636363);
  static const Color gray2 = Color.fromARGB(255, 243, 243, 243);

  static const Color yellow = Color(0xFFFFD600);

  static const transparent = Colors.transparent;
  static const error = Color(0xFFF83758);
  static const colorPink = Color(0xFFF83758);
  static Color colorPink2 = HexColor('#b20088');
  static Color colorPink3 = HexColor('#f5ecef');
  static Color black4 = HexColor('#1F1F1F');
  static Color greenBold = HexColor('#4CAF50');

  static const blue = Color(0xFF5DCCFC);

  static Color getColorBMI(double bmi) {
    if (bmi < 18.5) {
      return const Color(0xFF84CDEE);
    } else if (bmi >= 18.5 && bmi < 25) {
      return AppColors.primary;
    } else if (bmi >= 25 && bmi < 30) {
      return const Color(0xFFFFDF32);
    } else {
      return const Color(0xFFF5554A);
    }
  }
}
