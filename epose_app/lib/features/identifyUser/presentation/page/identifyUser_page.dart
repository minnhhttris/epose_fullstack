import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:epose_app/core/ui/widgets/button/button_widget.dart';
import '../../../../core/configs/app_colors.dart';
import '../../../../core/configs/app_dimens.dart';
import '../controller/identifyUser_controller.dart';
import '../widgets/identifyUser_appbar.dart';

class IdentifyUserPage extends GetView<IdentifyUserController> {
  IdentifyUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IdentifyUserAppbar(),
      body: Obx(() {
        return controller.isLoading.value
            ? Center(child: CircularProgressIndicator(color: AppColors.primary))
            : SingleChildScrollView(
                padding: const EdgeInsets.all(AppDimens.spacing20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("CCCD:",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextField(
                      controller: controller.identityController,
                      decoration: InputDecoration(
                        hintText: "Nhập số CCCD",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: AppDimens.spacing20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        imageUploader(
                          label: "Mặt trước",
                          image: controller.frontImage,
                          imageUrl: controller.frontImageUrl,
                          onTap: () => controller.pickImage(true),
                        ),
                        imageUploader(
                          label: "Mặt sau",
                          image: controller.backImage,
                          imageUrl: controller.backImageUrl,
                          onTap: () => controller.pickImage(false),
                        ),
                      ],
                    ),
                    SizedBox(height: AppDimens.spacing30),
                    ButtonWidget(
                      ontap: controller.submitIdentification,
                      text: 'Lưu thông tin',
                    ),
                  ],
                ),
              );
      }),
    );
  }

  Widget imageUploader({
    required String label,
    File? image,
    String? imageUrl,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.w600)),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
              image: image != null
                  ? DecorationImage(image: FileImage(image), fit: BoxFit.cover)
                  : imageUrl != null
                      ? DecorationImage(
                          image: NetworkImage(imageUrl), fit: BoxFit.cover)
                      : null,
            ),
            child: (image == null && imageUrl == null)
                ? Center(
                    child:
                        Icon(Icons.add_a_photo, color: Colors.grey, size: 50))
                : null,
          ),
        ),
      ],
    );
  }
}
