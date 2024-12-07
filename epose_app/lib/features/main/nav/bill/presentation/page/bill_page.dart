import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:epose_app/core/configs/app_colors.dart';
import '../../../../../../core/configs/app_images_string.dart';
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
          tabState(),
          listBill(),
        ],
      ),
    );
  }

  Widget listBill() {
    return Expanded(
      child: Obx(
        () => ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          itemCount: controller.filteredBills.length,
          itemBuilder: (context, index) {
            final bill = controller.filteredBills[index];
            final firstItem = bill.billItems.first;

            return BillCard(
              idBill: bill.idBill,
              productName: firstItem.clothes.nameItem,
              startDate: bill.dateStart,
              endDate: bill.dateEnd,
              imageUrl: firstItem.clothes.listPicture.first,
              total: bill.sum,
            );
          },
        ),
      ),
    );
  }

  Widget tabState() {
    return Container(
      height: 120,
      color: AppColors.white,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: controller.orderStatus.length,
        itemBuilder: (context, index) {
          final status = controller.orderStatus[index];
          return Obx(
            () => GestureDetector(
              onTap: () => controller.changeSelectedStatus(status),
              child: Container(
                width: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.primary1,
                      child: Image.asset(
                        status == 'Tất cả'
                            ? AppImagesString.eAll
                            : controller.statementMapping[controller
                                .getStatementFromStatus(status)]?['icon'],
                        width: 80,
                        height: 80,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      status,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      height: 3,
                      width: 100,
                      color: controller.selectedStatus.value == status
                          ? AppColors.primary
                          : AppColors.grey2,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
