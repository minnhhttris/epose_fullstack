import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/configs/app_colors.dart';
import '../../../../core/configs/app_dimens.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/ui/widgets/button/button_widget.dart';
import '../../../../core/ui/widgets/text/text_widget.dart';
import '../../../../core/ui/widgets/textfield/custom_textfield_widget.dart';
import '../controller/login_controller.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              loginTitle(),
              const SizedBox(height: AppDimens.spacing40),
              formLogin(),
              const SizedBox(height: AppDimens.rowSpacing),
              dontHaveAccountTiltle(),
              const SizedBox(height: AppDimens.rowSpacing),
              loginButton(),
              const SizedBox(height: AppDimens.spacing40),
              TextButton(
                onPressed: () {
                  Get.offNamed(Routes.main);
                },
                child: const Text(
                  'Tiếp tục mà không dùng tài khoản',
                  style: TextStyle(
                    color: Colors.brown,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget loginTitle() {
    return const Column(
      children: [
        TextWidget(
          text: 'Đăng nhập',
          color: AppColors.primary,
          size: AppDimens.textSize42,
          fontWeight: FontWeight.w900,
        ),
        SizedBox(height: AppDimens.rowSpacing),
        TextWidget(
          text:
              'Đăng nhập tài khoản của bạn để bắt đầu trải nghiệm trọn vẹn ứng dụng của chúng tôi!',
          color: AppColors.grey,
          size: AppDimens.textSize14,
          fontWeight: FontWeight.w400,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Form formLogin() {
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
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email là bắt buộc.';
              }

              final emailRegex = RegExp(
                  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.(com|net|edu|vn)$');

              if (!emailRegex.hasMatch(value)) {
                return 'Email phải là một địa chỉ email hợp lệ.';
              }

              return null;
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
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Mật khẩu là bắt buộc.';
                }

                if (value.length < 6) {
                  return 'Mật khẩu phải chứa ít nhất 6 ký tự.';
                }

                if (value.length > 32) {
                  return 'Mật khẩu không được vượt quá 32 ký tự.';
                }

                final passwordRegex = RegExp(
                    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$%\^&\*])(?!.*\s).*$');

                if (!passwordRegex.hasMatch(value)) {
                  return 'Mật khẩu phải chứa ít nhất một chữ hoa, một chữ thường, một số và một ký tự đặc biệt.';
                }

                return null;
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

  Row dontHaveAccountTiltle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        const TextWidget(
          text: 'Chưa có tài khoản? ',
          color: AppColors.primary,
          size: AppDimens.textSize14,
        ),
        GestureDetector(
          onTap: () {
            Get.offNamed(Routes.register);
          },
          child: const TextWidget(
            text: 'Tạo tại đây',
            color: AppColors.secondary,
            size: AppDimens.textSize14,
          ),
        ),
      ],
    );
  }

  Row loginButton() {
    return Row(
      children: [
        Expanded(
          child: ButtonWidget(
            borderRadius: AppDimens.radius5,
            height: AppDimens.textSize48,
            text: 'Đăng nhập',
            ontap: () {
              controller.login();
            },
            backgroundColor: AppColors.primary,
          ),
        ),
        // const SizedBox(width: AppDimens.columnSpacing),
        // Container(
        //   height: AppDimens.textSize48,
        //   width: AppDimens.textSize48,
        //   decoration: BoxDecoration(
        //     border: Border.all(
        //       color: AppColors.primary,
        //       width: 1.0,
        //     ),
        //     color: AppColors.primary2,
        //     borderRadius: BorderRadius.circular(AppDimens.radius5),
        //   ),
        //   child: Center(
        //     child: IconButton(
        //       icon: const Icon(
        //         size: AppDimens.textSize28,
        //         Icons.fingerprint,
        //         color: AppColors.black,
        //       ),
        //       onPressed: () {
        //         // Xử lý khi nhấn vào nút
        //       },
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
