import 'package:epose_app/core/configs/app_colors.dart';
import 'package:epose_app/core/ui/widgets/button/button_widget.dart';
import 'package:epose_app/core/ui/widgets/text/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/configs/app_dimens.dart';
import '../../../../core/ui/widgets/textfield/custom_textfield_widget.dart';
import '../controller/addInfomationRegister_controller.dart';

class AddInfomationRegisterPage
    extends GetView<AddInfomationRegisterController> {
  const AddInfomationRegisterPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const TextWidget(
                  text: "Thêm thông tin cá nhân của bạn",
                  size: AppDimens.textSize42,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.center,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 40),
                formAddInfomationRegister(),
                const SizedBox(height: 40),
                ButtonWidget(
                  text: 'Xác nhận',
                  ontap: () {
                    if (controller.formKey.currentState!.validate()) {
                      controller.addInfomation();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Form formAddInfomationRegister() {
    return Form(
      key: controller.formKey,
      child: Column(
        children: [
          CustomTextFieldWidget(
            obscureText: false,
            enableColor: AppColors.primary,
            focusedColor: AppColors.primary,
            hintText: 'Nhập họ và tên...',
            hintColor: Colors.grey,
            borderRadius: AppDimens.radius5,
            keyboardType: TextInputType.text,
            controller: controller.nameController,
            labelText: 'Họ và tên',
            isShowBorder: true,
            enable: true,
            onChanged: (value) {
              controller.nameController.text = value;
            },
          ),
          const SizedBox(height: AppDimens.spacing15),
          CustomTextFieldWidget(
            obscureText: false,
            enableColor: AppColors.primary,
            focusedColor: AppColors.primary,
            hintText: 'Nhập số điện thoại...',
            hintColor: Colors.grey,
            borderRadius: AppDimens.radius5,
            keyboardType: TextInputType.phone,
            controller: controller.phoneController,
            labelText: 'Số điện thoại',
            isShowBorder: true,
            enable: true,
            onChanged: (value) {
              controller.phoneController.text = value;
            },
          ),
          const SizedBox(height: AppDimens.spacing15),
          DropdownButtonFormField<String>(
            isDense: true,
            dropdownColor: AppColors.primary2,
            decoration: InputDecoration(
              labelText: 'Giới tính',
              labelStyle: const TextStyle(
                color: AppColors.primary,
                fontSize: AppDimens.textSize16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimens.radius5),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.primary),
                borderRadius: BorderRadius.circular(AppDimens.radius5),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.primary),
                borderRadius: BorderRadius.circular(AppDimens.radius5),
              ),
            ),
            value:
                controller.selectedGender.value, 
            items: ['Nam', 'Nữ', 'Khác']
                .map((gender) => DropdownMenuItem(
                      value: gender,
                      child: TextWidget(
                          text:gender,
                          size: AppDimens.textSize16,
                          color: AppColors.primary
                        ),
                    ))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                controller.selectedGender.value = value;
              }
            },
            validator: (value) =>
                value == null ? 'Vui lòng chọn giới tính' : null,
          ),
        ],
      ),
    );
  }
}
