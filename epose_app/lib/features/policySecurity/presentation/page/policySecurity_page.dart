import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/ui/widgets/appbar/appbar_widget.dart';
import '../controller/policySecurity_controller.dart';

class PolicySecurityPage extends GetView<PolicySecurityController> {
  const PolicySecurityPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarWidget(),
      body: Center(
        child: Text('PolicySecurity Page'),
      ),
    );
  }
}
