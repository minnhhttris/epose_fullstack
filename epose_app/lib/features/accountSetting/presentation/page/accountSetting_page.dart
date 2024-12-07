import 'package:epose_app/core/configs/app_dimens.dart';
import 'package:epose_app/core/ui/widgets/text/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/configs/app_colors.dart';
import '../../../../core/routes/routes.dart';
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
              Get.toNamed(Routes.settingInfomation);
            }),
            const Divider(
              color: AppColors.grey1,
              thickness: 0.5,
            ),
            // settingItem(Icons.password, 'Thay đổi mật khẩu', () {
            //   Get.toNamed(Routes.resetPassword);
            // }),
            // const Divider(
            //   color: AppColors.grey1,
            //   thickness: 0.5,
            // ),
            settingItem(Icons.location_on, 'Địa chỉ', () {
              Get.toNamed(Routes.address);
            }),
            const Divider(
              color: AppColors.grey1,
              thickness: 0.5,
            ),
            // settingItem(Icons.credit_card, 'Tài khoản liên kết', () {
            // }),
            // const Divider(
            //   color: AppColors.grey1,
            //   thickness: 0.5,
            // ),
            settingItem(Icons.verified_user, 'Định danh tài khoản', () {
              Get.toNamed(Routes.identifyUser);
            }),
            // const Divider(
            //   color: AppColors.grey1,
            //   thickness: 0.5,
            // ),
            // settingItem(Icons.notifications, 'Thông báo', () {
            // }),
            // const Divider(
            //   color: AppColors.grey1,
            //   thickness: 0.5,
            // ),
            // settingItem(Icons.fingerprint, 'Đăng nhập FaceID/TouchID', () {
            // }),
            const Divider(
              color: AppColors.grey1,
              thickness: 0.5,
            ),
            sectionTitle('Hỗ trợ'),
            settingItem(Icons.policy, 'Chính sách và bảo mật', () {
              Get.toNamed(Routes.policySecurity);
            }),
            const Divider(
              color: AppColors.grey1,
              thickness: 0.5,
            ),
            settingItem(Icons.help_outline, 'Trợ giúp', () {
            }),
            const Divider(
              color: AppColors.grey1,
              thickness: 0.5,
            ),
            SizedBox(height: Get.height * 0.1),
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
          controller.logout();
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
