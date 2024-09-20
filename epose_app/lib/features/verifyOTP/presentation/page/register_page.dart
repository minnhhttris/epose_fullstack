import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/ui/widgets/appbar/appbar_widget.dart';
import '../controller/verifyOTP_controller.dart';

class VerifyOTPPage extends GetView<VerifyOTPController> {
  const VerifyOTPPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarWidget(),
      body: Center(
        child: Text('VerifyOTP Page'),
      ),
    );
  }
}
