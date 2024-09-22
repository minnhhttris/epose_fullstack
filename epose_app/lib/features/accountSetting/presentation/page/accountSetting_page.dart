import 'package:epose_app/core/configs/app_dimens.dart';
import 'package:epose_app/core/ui/widgets/text/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/configs/app_colors.dart';
import '../../../../core/ui/widgets/button/button_widget.dart';
import '../controller/accountSetting_controller.dart';
import '../widgets/accountSetting_appbar.dart';

class AccountSettingPage extends GetView<AccountSettingController> {
  const AccountSettingPage({super.key});
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: const AccountSettingAppbar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            sectionTitle('Cài đặt'),
            settingItem(Icons.person, 'Thông tin cá nhân', () {
              // Điều hướng đến trang Thông tin cá nhân
            }),
            const Divider(
              color: AppColors.grey1,
              thickness: 0.5,
            ),
            settingItem(Icons.location_on, 'Địa chỉ', () {
              // Điều hướng đến trang Địa chỉ
            }),
            const Divider(
              color: AppColors.grey1,
              thickness: 0.5,
            ),
            settingItem(Icons.credit_card, 'Tài khoản liên kết', () {
              // Điều hướng đến trang Tài khoản liên kết
            }),
            const Divider(
              color: AppColors.grey1,
              thickness: 0.5,
            ),
            settingItem(Icons.lock, 'Đặt lại mã pin', () {
              // Điều hướng đến trang Đặt lại mã pin
            }),
            const Divider(
              color: AppColors.grey1,
              thickness: 0.5,
            ),
            settingItem(Icons.notifications, 'Thông báo', () {
              // Điều hướng đến trang Thông báo
            }),
            const Divider(
              color: AppColors.grey1,
              thickness: 0.5,
            ),
            settingItem(Icons.fingerprint, 'Đăng nhập FaceID/TouchID', () {
              // Điều hướng đến trang FaceID/TouchID
            }),
            const Divider(
              color: AppColors.grey1,
              thickness: 0.5,
            ),
            sectionTitle('Hỗ trợ'),
            settingItem(Icons.policy, 'Chính sách và bảo mật', () {
              // Điều hướng đến trang Chính sách và bảo mật
            }),
            const Divider(
              color: AppColors.grey1,
              thickness: 0.5,
            ),
            settingItem(Icons.help_outline, 'Trợ giúp', () {
              // Điều hướng đến trang Trợ giúp
            }),
            const Divider(
              color: AppColors.grey1,
              thickness: 0.5,
            ),
            logoutButton(),
          ],
        ),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: TextWidget(
        text: title,
      ),
    );
  }

  Widget settingItem(IconData icon, String title, Function() onTap) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 60,
      child: ListTile(
        leading: Icon(icon, color: Colors.black),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  Widget logoutButton() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ButtonWidget(
        ontap: () {
          Get.offAllNamed('/login');
        },
        text: 'Đăng xuất',
        backgroundColor: AppColors.white, 
        textColor: AppColors.primary,
        isBorder: true,
        borderColor: AppColors.primary,
        borderRadius: AppDimens.radius10,
      ),
    );
  }
}
