import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/configs/app_colors.dart';
import '../../../../core/configs/app_dimens.dart';
import '../../../../core/ui/widgets/button/button_widget.dart';
import '../../../../core/ui/widgets/text/text_widget.dart';
import '../../../../core/ui/widgets/textfield/custom_textfield_widget.dart';
import '../controller/editPosts_controller.dart';

class EditPostsPage extends GetView<EditPostsController> {
  const EditPostsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chỉnh sửa Bài viết'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      textAlign: TextAlign.left,
                      text: 'Thông tin bài viết',
                      size: AppDimens.textSize16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                    captionPosts(),
                    const SizedBox(height: 20),

                    TextWidget(
                      textAlign: TextAlign.left,
                      text: 'Hình ảnh',
                      size: AppDimens.textSize16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: 10),
                    imagesBoxClothes(),
                    
                    const SizedBox(height: 30),
                    ButtonWidget(
                      ontap: () {
                        if (controller.formKey.currentState!.validate()) {
                          controller.updatePosts(controller.posts!.idPosts);
                        } else {
                          Get.snackbar('Lỗi', 'Vui lòng điền đầy đủ thông tin');
                        }
                      },
                      text: 'Cập nhật bài viết',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget captionPosts() {
    return CustomTextFieldWidget(
      height: 30.0,
      decorationType: InputDecorationType.underline,
      controller: controller.captionController,
      hintText: 'Nhập caption...',
      hintColor: AppColors.grey3,
      obscureText: false,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Caption không được để trống';
        }
        return null;
      },
    );
  }

  
  Column imagesBoxClothes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          return Wrap(
            spacing: 15,
            runSpacing: 15,
            children: controller.combinedPictures.map((image) {
              return Stack(
                children: [
                  // Kiểm tra nếu là URL thì dùng Image.network, nếu là File thì dùng Image.file
                  image is String
                      ? Image.network(
                          image,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          image,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () => controller.removeImage(image),
                      child: Container(
                        color: Colors.red,
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          );
        }),
        GestureDetector(
          onTap: () {
            controller.pickImages();
          },
          child: Obx(
            () => Container(
              width: double.infinity,
              margin: controller.combinedPictures.isNotEmpty
                  ? const EdgeInsets.only(top: 10)
                  : null,
              height: controller.combinedPictures.isEmpty ? 180 : 40,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.gray.withOpacity(0.1),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(10),
                color: AppColors.gray.withOpacity(0.0),
              ),
              child: controller.combinedPictures.isEmpty
                  ? const Icon(
                      Icons.add_photo_alternate,
                      size: 120,
                    )
                  : const Icon(
                      Icons.add,
                      size: 30,
                      color: AppColors.primary,
                    ),
            ),
          ),
        ),
      ],
    );
  }

}