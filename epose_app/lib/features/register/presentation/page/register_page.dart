import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../core/configs/app_colors.dart';
import '../../../../core/configs/app_dimens.dart';
import '../../../../core/configs/app_images_string.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/ui/widgets/button/button_widget.dart';
import '../../../../core/ui/widgets/text/text_widget.dart';
import '../../../../core/ui/widgets/textfield/custom_textfield_widget.dart';
import '../controller/register_controller.dart';

class RegisterPage extends GetView<RegisterController> {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[

                registerTitle(),
                const SizedBox(height: AppDimens.spacing40),
                formRegister(),
                const SizedBox(height: AppDimens.rowSpacing),
                alreadyHaveAccount(),
                const SizedBox(height: AppDimens.rowSpacing),
                registerButton(),
                const SizedBox(height: AppDimens.rowSpacing),

                const TextWidget(
                  text: "OR",
                  size: AppDimens.textSize16,
                  color: AppColors.grey,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(height: AppDimens.rowSpacing),
                socialRegister(),
                const SizedBox(height: AppDimens.spacing40),
                termsAndPolicies(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget registerTitle() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextWidget(
          text: 'Đăng ký',
          color: AppColors.primary,
          size: AppDimens.textSize42,
          fontWeight: FontWeight.w900,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppDimens.rowSpacing),
        TextWidget(
          text:
              'Đăng ký tài khoản của bạn để bắt đầu trải nghiệm trọn vẹn ứng dụng của chúng tôi!',
          color: AppColors.grey,
          size: AppDimens.textSize14,
          fontWeight: FontWeight.w400,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Form formRegister() {
    return Form(
      key: controller.formKey,
      child: Column(
        children: [
          CustomTextFieldWidget(
            obscureText: false,
            focusedColor: AppColors.primary,
            hintText: 'Nhập email...',
            hintColor: Colors.grey,
            borderRadius: AppDimens.radius5,
            keyboardType: TextInputType.emailAddress,
            controller: controller.emailController,
            labelText: 'Email',
            isShowBorder: true,
            enable: true,
            onChanged: (value) {
              controller.emailController.text = value;
            },
          ),
          const SizedBox(height: AppDimens.spacing15),
          Obx(
            () => CustomTextFieldWidget(
              obscureText: controller.isObscure.value,
              focusedColor: AppColors.primary,
              hintText: 'Nhập mật khẩu...',
              hintColor: Colors.grey,
              borderRadius: AppDimens.radius5,
              keyboardType: TextInputType.visiblePassword,
              controller: controller.passwordController,
              labelText: 'Mật khẩu',
              isShowBorder: true,
              enable: true,
              onChanged: (value) {
                controller.passwordController.text = value;
              },
              suffixIcon: IconButton(
                icon: Icon(
                  controller.isObscure.value
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: () {
                  controller.toggleObscure();
                },
              ),
            ),
          ),
          const SizedBox(height: AppDimens.spacing15),
          Obx(
            () => CustomTextFieldWidget(
              obscureText: controller.isObscure.value,
              focusedColor: AppColors.primary,
              hintText: 'Xác nhận lại mật khẩu...',
              hintColor: Colors.grey,
              borderRadius: AppDimens.radius5,
              keyboardType: TextInputType.visiblePassword,
              controller: controller.confirmPasswordController,
              labelText: 'Xác nhận mật khẩu',
              isShowBorder: true,
              enable: true,
              onChanged: (value) {
                controller.confirmPasswordController.text = value;
              },
              suffixIcon: IconButton(
                icon: Icon(
                  controller.isObscure.value
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: () {
                  controller.toggleObscure();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

    Widget alreadyHaveAccount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const TextWidget(
          text: 'Đã có tài khoản? ',
          color: AppColors.grey,
          size: AppDimens.textSize14,
        ),
        GestureDetector(
          onTap: () {
            Get.offNamed(Routes.login);
          },
          child: const TextWidget(
            text: 'Đăng nhập tại đây',
            color: AppColors.secondary,
            size: AppDimens.textSize14,
          ),
        ),
      ],
    );
  }


  Widget registerButton() {
    return ButtonWidget(
      borderRadius: AppDimens.radius5,
      height: AppDimens.textSize48,
      text: 'Đăng ký',
      ontap: () {
        if (controller.formKey.currentState!.validate()) {
          // Xử lý đăng ký
        }
      },
      backgroundColor: AppColors.primary,
    );
  }


Widget socialRegister() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        height: 40,
        width: 40,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blue, 
        ),
        child: IconButton(
          icon: const Icon(
            FontAwesomeIcons.facebookF,
            color: Colors.white, 
            size: 30, 
          ),
          onPressed: () {
            // Xử lý đăng ký bằng Facebook
          },
        ),
      ),
      const SizedBox(width: AppDimens.columnSpacing), 
      Container(
        height: 45,
        width: 45,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.white, 
            width: 2.0,
          ),
        ),
        child: SvgPicture.asset(
          AppImagesString.eGmail, 
        ),
      ),
    ],
  );
}



  Widget termsAndPolicies() {
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        const TextWidget(
          text: 'Khi nhấn đăng ký, đồng nghĩa bạn đã chấp nhận ',
          size: AppDimens.textSize12,
          color: AppColors.black,
          fontWeight: FontWeight.w400,
          textAlign: TextAlign.center,
        ),
        GestureDetector(
          onTap: () {
            // Xử lý khi nhấn 
          },
          child: const TextWidget(
            text: 'Điều khoản và Chính sách',
            size: AppDimens.textSize12,
            color: Colors.blue, 
            textAlign: TextAlign.center,
            fontWeight: FontWeight.bold,
            textDecoration: TextDecoration.underline, 
          ),
        ),
        const TextWidget(
          text: ' của chúng tôi',
          size: AppDimens.textSize12,
          color: AppColors.black,
          fontWeight: FontWeight.w400,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

}
