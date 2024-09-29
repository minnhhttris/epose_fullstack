import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/ui/widgets/appbar/appbar_widget.dart';

class SearchPage extends GetView<SearchController> {
  const SearchPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarWidget(),
      body: Center(
        child: Text('SearchPage Page'),
      ),
    );
  }
}
