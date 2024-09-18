import 'package:epose_app/core/ui/widgets/appbar/appbar_widget.dart';
import 'package:epose_app/features/main/nav/profile/presentation/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarWidget(),
      body: Center(
        child: Text('Profile Page'),
      ),
    );
  }
}
