import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:epose_app/core/configs/app_colors.dart';
import '../controller/bill_controller.dart';
import '../widgets/bill_appbar_widget.dart';
import '../widgets/bill_card_widget.dart';

class BillPage extends GetView<BillController> {
  const BillPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BillAppbar(),
      body: Column(
        children: [
          // Phần danh sách trạng thái đơn hàng
          Container(
            height: 100,
            padding: const EdgeInsets.symmetric(vertical: 5),
            color: AppColors.grey1.withOpacity(0.1),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.orderStatus.length,
              itemBuilder: (context, index) {
                final status = controller.orderStatus[index];
                return Obx(
                  () => GestureDetector(
                    onTap: () => controller.changeSelectedStatus(status),
                    child: Container(
                      width: 80,
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        color: controller.selectedStatus.value == status
                            ? AppColors.primary
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: AppColors.primary2,
                            child: Icon(
                              Icons
                                  .check_box_outline_blank, // Icon cho từng trạng thái
                              color: controller.selectedStatus.value == status
                                  ? AppColors.primary
                                  : AppColors.black,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            status,
                            style: TextStyle(
                              fontSize: 12,
                              color: controller.selectedStatus.value == status
                                  ? AppColors.white
                                  : AppColors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Danh sách đơn hàng
          Expanded(
            child: Obx(
              () => ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: controller.filteredOrders.length,
                itemBuilder: (context, index) {
                  final order = controller.filteredOrders[index];
                  return BillCard(
                    productName: order['productName']!,
                    rentalPeriod: order['rentalPeriod']!,
                    imageUrl: order['imageUrl']!,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
