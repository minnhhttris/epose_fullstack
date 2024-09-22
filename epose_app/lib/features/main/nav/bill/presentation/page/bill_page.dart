import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/ui/widgets/appbar/appbar_widget.dart';
import '../controller/bill_controller.dart';

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
