import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/ui/widgets/appbar/appbar_widget.dart';
import '../controller/setLocation_controller.dart';

class SetLocationPage extends GetView<SetLocationController> {
  const SetLocationPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarWidget(),
      body: Center(
        child: Text('SetLocation Page'),
      ),
    );
  }
}
