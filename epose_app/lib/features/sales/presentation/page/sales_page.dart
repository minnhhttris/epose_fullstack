import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/ui/widgets/appbar/appbar_widget.dart';
import '../controller/sales_controller.dart';

class SalesPage extends GetView<SalesController> {
  const SalesPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarWidget(),
      body: Center(
        child: Text('Sales Page'),
      ),
    );
  }
}
