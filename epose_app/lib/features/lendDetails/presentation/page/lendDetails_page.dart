import 'package:epose_app/core/ui/widgets/button/button_widget.dart';
import 'package:epose_app/core/ui/widgets/text/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/configs/app_colors.dart';
import '../controller/lendDetails_controller.dart';

class LendDetailsPage extends GetView<LendDetailsController> {
  const LendDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Chi tiết đơn thuê'),
      ),
      body: Obx(
        () {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.billItems.isEmpty) {
            return const Center(child: Text('Không có sản phẩm thuê.'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildUserInfo(),
                const Divider(thickness: 0.5),
                _buildProductList(),
                const Divider(thickness: 0.5),
                _buildDateSelection(context),
                const Divider(thickness: 0.5),
                _buildRentalSummary(),
                const SizedBox(height: 30),
                _buildConfirmButton(),
              ],
            ),
          );
        },
      ),
    );
  }

  // Hiển thị thông tin người dùng
  Widget _buildUserInfo() {
    final user = controller.user;

    if (user == null) {
      return const Center(child: Text('Không thể tải thông tin người dùng.'));
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            text: "Thông tin người thuê:",
            size: 16,
            fontWeight: FontWeight.bold,
          ),
          TextWidget(
            text: 'Tên: ${user.userName ?? 'Chưa có'}',
            size: 14,
          ),
          TextWidget(
            text: 'Số điện thoại: ${user.phoneNumbers ?? 'Chưa có'}',
            size: 14,
          ),
          TextWidget(
            text: 'Địa chỉ: ${user.address ?? 'Chưa có'}',
            size: 14,
          ),
        ],
      ),
    );
  }

  // Hiển thị danh sách sản phẩm
  Widget _buildProductList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.billItems.length,
        itemBuilder: (context, index) {
          final billItem = controller.billItems[index];
          final totalProductPrice = billItem.clothes.price * billItem.quantity;

          return Card(
            color: Colors.white,
            margin: const EdgeInsets.symmetric(vertical: 5.0),
            child: Container(
              height: 160,
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      billItem.clothes.listPicture.isNotEmpty
                          ? billItem.clothes.listPicture.first
                          : 'https://via.placeholder.com/80',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextWidget(
                          text: billItem.clothes.nameItem,
                          fontWeight: FontWeight.bold,
                          size: 16,
                        ),
                        const SizedBox(height: 5),
                        TextWidget(
                          text:
                              'Kích cỡ: ${billItem.size}, Số lượng: ${billItem.quantity}',
                          size: 14,
                        ),
                        TextWidget(
                          text:
                              'Giá: ${NumberFormat("#,##0", "vi_VN").format(billItem.clothes.price)} vnđ',
                          size: 14,
                          color: AppColors.primary,
                        ),
                        TextWidget(
                          text:
                              'Tổng: ${NumberFormat("#,##0", "vi_VN").format(totalProductPrice)} vnđ',
                          size: 14,
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Chọn ngày thuê
  Widget _buildDateSelection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 40,
          child: Obx(
            () => ButtonWidget(
              width: Get.width * 0.43,
              text: controller.startDate.value != null
                  ? 'Ngày thuê: ${DateFormat('dd/MM/yyyy').format(controller.startDate.value!)}'
                  : 'Chọn ngày thuê',
              ontap: () async {
                // Ngày thuê phải cách hiện tại 2 ngày
                DateTime minStartDate =
                    DateTime.now().add(const Duration(days: 2));

                final selectedStartDate = await showDatePicker(
                  context: context,
                  initialDate: minStartDate,
                  firstDate: minStartDate,
                  lastDate: DateTime(2100),
                  builder: (context, child) {
                    return Theme(
                      data: ThemeData.light().copyWith(
                        colorScheme: ColorScheme.light(
                          primary: AppColors.primary, // Màu tiêu đề và nút
                          onPrimary: Colors.white, // Màu chữ tiêu đề
                          surface: AppColors.primary3, // Màu nền
                          onSurface: AppColors.black, // Màu chữ nội dung
                        ),
                        dialogBackgroundColor:
                            AppColors.white, // Màu nền hộp thoại
                        textButtonTheme: TextButtonThemeData(
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.primary, // Màu nút chọn
                          ),
                        ),
                      ),
                      child: child!,
                    );
                  },
                );

                if (selectedStartDate != null) {
                  controller.startDate.value = selectedStartDate;
                  // Đặt lại ngày trả nếu nó nhỏ hơn ngày thuê
                  if (controller.endDate.value != null &&
                      controller.endDate.value!.isBefore(selectedStartDate)) {
                    controller.endDate.value = null;
                    Get.snackbar(
                      'Lỗi',
                      'Ngày trả không thể trước ngày thuê.',
                    );
                  }
                }
              },
              textColor: AppColors.primary,
              backgroundColor: AppColors.white,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          height: 40,
          child: Obx(
            () => ButtonWidget(
              width: Get.width * 0.40,
              text: controller.endDate.value != null
                  ? 'Ngày trả: ${DateFormat('dd/MM/yyyy').format(controller.endDate.value!)}'
                  : 'Chọn ngày trả',
              ontap: () async {
                if (controller.startDate.value == null) {
                  Get.snackbar(
                    'Lỗi',
                    'Vui lòng chọn ngày thuê trước.',
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                  return;
                }

                final selectedEndDate = await showDatePicker(
                  context: context,
                  initialDate: controller.startDate.value!,
                  firstDate: controller.startDate.value!,
                  lastDate: DateTime(2100),
                  builder: (context, child) {
                    return Theme(
                      data: ThemeData.light().copyWith(
                        colorScheme: ColorScheme.light(
                          primary: AppColors.primary, // Màu tiêu đề và nút
                          onPrimary: Colors.white, // Màu chữ tiêu đề
                          surface: AppColors.primary3, // Màu nền
                          onSurface: AppColors.black, // Màu chữ nội dung
                        ),
                        dialogBackgroundColor:
                            AppColors.white, // Màu nền hộp thoại
                        textButtonTheme: TextButtonThemeData(
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.primary, // Màu nút chọn
                          ),
                        ),
                      ),
                      child: child!,
                    );
                  },
                );

                if (selectedEndDate != null) {
                  // Ràng buộc tránh số âm ngày
                  if (selectedEndDate.isBefore(controller.startDate.value!)) {
                    Get.snackbar(
                      'Lỗi',
                      'Ngày trả không thể trước ngày thuê.',
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  } else {
                    controller.endDate.value = selectedEndDate;
                  }
                }
              },
              textColor: AppColors.primary,
              backgroundColor: AppColors.white,
            ),
          ),
        ),
      ],
    );
  }


  // Hiển thị tổng kết đơn thuê
  Widget _buildRentalSummary() {
    final startDate = controller.startDate.value;
    final endDate = controller.endDate.value;

    // Tính tổng số ngày thuê
    int totalDays = 0;
    if (startDate != null && endDate != null) {
      totalDays = endDate.difference(startDate).inDays;
      // Nếu thuê và trả trong cùng một ngày, tính là một ngày
      if (totalDays == 0) {
        totalDays = 1;
      }
    }

    // Tính tổng giá tiền thuê
    final totalRentalPrice = controller.billItems.fold<double>(
      0,
      (sum, item) => sum + (item.clothes.price * item.quantity * totalDays),
    );

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            text: 'Tổng số ngày thuê: $totalDays',
            size: 16,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 5),
          TextWidget(
            text:
                'Tổng giá tiền thuê: ${NumberFormat("#,##0", "vi_VN").format(totalRentalPrice)} VND',
            size: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.red,
          ),
        ],
      ),
    );
  }


  // Nút xác nhận thuê
  Widget _buildConfirmButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: ButtonWidget(
        ontap: () {
          if (controller.isValidRentalDetails()) {
            Get.snackbar("Xác nhận", "Thông tin thuê đã được xác nhận!");
          } else {
            Get.snackbar("Lỗi", "Vui lòng chọn đầy đủ ngày thuê và sản phẩm!");
          }
        },
        text: 'Thanh toán',
      ),
    );
  }
}
