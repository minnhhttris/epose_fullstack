import 'package:epose_app/core/ui/widgets/appbar/appbar_widget.dart';
import 'package:epose_app/features/main/nav/bill/presentation/controller/bill_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BillPage extends GetView<BillController> {
  const BillPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarWidget(),
      body: Center(
        child: Text('Bill Page'),
      ),
    );
  }
}
