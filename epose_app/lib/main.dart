import 'app.config.dart';
import 'package:epose_app/app.dart';
import 'package:flutter/material.dart';

void main() async {
  await appConfig();
  runApp(const App());
}
