

import 'package:epose_app/core/ui/widgets/button/button_widget.dart';
import 'package:epose_app/core/ui/widgets/text/text_widget.dart';
import 'package:epose_app/core/ui/widgets/textfield/custom_textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/configs/app_colors.dart';
import '../controller/clothes_status_controller.dart';

class ClothesStatusPage extends GetView<ClothesStatusController> {
  @override
  Widget build(BuildContext context) {
    final descriptionController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Xác nhận trạng thái quần áo'),
        centerTitle: true,
      ),
      body: Obx(() {
        final bill = controller.billDetails.value;
        if (bill == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: bill.billItems.length,
          itemBuilder: (context, index) {
            final item = bill.billItems[index];

            return Card(
              margin: const EdgeInsets.all(16.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      text: item.clothes.nameItem,
                      size: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        item.clothes.listPicture.first,
                        height: 300,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 10),
                    CustomTextFieldWidget(
                      controller: descriptionController,
                      maxLines: 3,
                      hintText: "Mô tả trạng thái",
                      textColor: AppColors.black,
                      obscureText: false,
                    ),
                    const SizedBox(height: 15),
                    imagesBoxClothes(),
                    const SizedBox(height: 15),
                    ButtonWidget(
                      ontap: () {
                        controller.createClothesStatus(
                          controller.billId,
                          item.idItem,
                          descriptionController.text,
                        );
                      },
                      text: "Gửi xác nhận",
                      height: 40,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
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
            children: controller.listPicture.map((image) {
              return Stack(
                children: [
                  Image.file(
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
              margin: !controller.checkListEmpty()
                  ? const EdgeInsets.only(top: 10)
                  : null,
              height: controller.checkListEmpty() ? 180 : 40,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.gray.withOpacity(0.1),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(10),
                color: AppColors.gray.withOpacity(0.0),
              ),
              child: controller.checkListEmpty()
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
