import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/ui/widgets/appbar/appbar_widget.dart';
import '../controller/resetPassword_controller.dart';

class ResetPasswordPage extends GetView<ResetPasswordController> {
  const ResetPasswordPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarWidget(),
      body: Center(
        child: Text('ResetPassword Page'),
      ),
    );
  }
}
