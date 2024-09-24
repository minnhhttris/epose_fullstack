import 'package:epose_app/core/ui/widgets/button/button_widget.dart';
import 'package:epose_app/core/ui/widgets/textfield/custom_textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/configs/app_colors.dart';
import '../../../../core/configs/app_dimens.dart';
import '../../../../core/ui/widgets/avatar/avatar.dart';
import '../../../../core/ui/widgets/text/text_widget.dart';
import '../controller/settingInfomation_controller.dart';
import '../widgets/settingInfomation_appbar.dart';

class SettingInfomationPage extends GetView<SettingInfomationController> {
  const SettingInfomationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SettingInfomationAppbar(),
      body: Padding(
        padding: const EdgeInsets.only(
          left: AppDimens.spacing20,
          right: AppDimens.spacing20,
          bottom: AppDimens.spacing20,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              userInfo(),
              const SizedBox(height: AppDimens.spacing10),
              userDetails(context),
              const SizedBox(height: AppDimens.spacing30),
              ButtonWidget(
                ontap: () {
                  if (controller.formKey.currentState!.validate()) {
                    // Xử lý
                  }
                },
                text: 'Lưu thông tin',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget userInfo() {
    return SizedBox(
      height: Get.height * 0.25,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            height: Get.height * 0.15,
            decoration: const BoxDecoration(
              color: AppColors.primary2,
            ),
          ),
          Positioned(
            top: Get.height * 0.10,
            child: Column(
              children: [
                GestureDetector(
                  child: GetBuilder<SettingInfomationController>(
                    id: "updateAvatar",
                    builder: (_) {
                      return Avatar(
                        authorImg: controller.user?.email ?? '',
                        radius: 60,
                      );
                    },
                  ),
                ),
                const SizedBox(height: AppDimens.spacing5),
                TextWidget(
                  text: controller.user?.email ?? 'User name',
                  size: AppDimens.textSize14,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Form userDetails(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TextWidget(
            text: 'Họ và tên',
            size: AppDimens.textSize14,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
            textAlign: TextAlign.left,
          ),
          nameUser(),
          const SizedBox(height: AppDimens.spacing15),
          const TextWidget(
            text: 'Giới tính',
            size: AppDimens.textSize14,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
            textAlign: TextAlign.left,
          ),
          genderUser(),
          const SizedBox(height: AppDimens.spacing15),
          const TextWidget(
            text: 'Ngày sinh',
            size: AppDimens.textSize14,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
            textAlign: TextAlign.start,
          ),
          dateOfBirthUser(context),
          const SizedBox(height: AppDimens.spacing15),
          const TextWidget(
            text: 'Số điện thoại',
            size: AppDimens.textSize14,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
            textAlign: TextAlign.start,
          ),
          phoneUser(),
          const SizedBox(height: AppDimens.spacing15),
          const TextWidget(
            text: 'Xác thực định danh',
            size: AppDimens.textSize14,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
            textAlign: TextAlign.start,
          ),
          identifyUser(),
        ],
      ),
    );
  }

  CustomTextFieldWidget nameUser() {
    return CustomTextFieldWidget(
      textColor: AppColors.primary,
      height: 30,
      controller: controller.nameController,
      obscureText: false,
      enableColor: AppColors.grey1,
      focusedColor: AppColors.grey1,
      decorationType: InputDecorationType.underline,
    );
  }

  CustomTextFieldWidget phoneUser() {
    return CustomTextFieldWidget(
      textColor: AppColors.primary,
      controller: controller.phoneController,
      obscureText: false,
      hintText: 'Nhập số điện thoại...',
      hintColor: AppColors.grey,
      enableColor: AppColors.grey1,
      focusedColor: AppColors.grey1,
      decorationType: InputDecorationType.underline,
      keyboardType: TextInputType.phone,
    );
  }

  DropdownButtonFormField<String> genderUser() {
    return DropdownButtonFormField<String>(
      isDense: true,
      dropdownColor: AppColors.primary2,
      decoration: const InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.grey1),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.grey1),
        ),
      ),
      value: controller.selectedGender.value,
      items: ['  Nam', '  Nữ', '  Khác']
          .map((gender) => DropdownMenuItem(
                value: gender,
                child: TextWidget(
                    text: gender,
                    size: AppDimens.textSize16,
                    color: AppColors.primary),
              ))
          .toList(),
      onChanged: (value) {
        if (value != null) {
          controller.selectedGender.value = value;
        }
      },
      validator: (value) => value == null ? 'Vui lòng chọn giới tính' : null,
    );
  }

  GestureDetector dateOfBirthUser(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: AppColors.primary,
                  onPrimary: Colors.white,
                  onSurface: AppColors.black,
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                  ),
                ),
              ),
              child: child!,
            );
          },
        );
        if (pickedDate != null) {
          controller.dateOfBirthController.text =
              '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
        }
      },
      child: AbsorbPointer(
        child: CustomTextFieldWidget(
          height: 30,
          controller: controller.dateOfBirthController,
          obscureText: false,
          textColor: AppColors.primary,
          enableColor: AppColors.grey1,
          focusedColor: AppColors.grey1,
          decorationType: InputDecorationType.underline,
          suffixIcon:
              const Icon(Icons.calendar_month_rounded, color: AppColors.primary),
        ),
      ),
    );
  }

  GestureDetector identifyUser() {
    return GestureDetector(
      onTap: () {
        // Xử lý chuyển trang xác thực định danh
      },
      child: AbsorbPointer(
        child: CustomTextFieldWidget(
          labelText: 'Định danh tài khoản của bạn!',
          labelColor: AppColors.grey,
          textColor: AppColors.grey,
          controller: controller.identityController,
          height: 30,
          obscureText: false,
          enableColor: AppColors.grey1,
          focusedColor: AppColors.grey1,
          decorationType: InputDecorationType.underline,
          suffixIcon: const Icon(Icons.arrow_forward_ios, color: AppColors.grey1),
        ),
      ),
    );
  }
}
