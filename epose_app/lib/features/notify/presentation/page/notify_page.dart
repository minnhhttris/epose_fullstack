import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/ui/widgets/appbar/appbar_widget.dart';
import '../controller/notify_controller.dart';

class NotifyPage extends GetView<NotifyController> {
  const NotifyPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarWidget(),
      body: Center(
        child: Text('Notify Page'),
      ),
    );
  }
}
