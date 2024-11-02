import 'package:epose_app/core/ui/widgets/button/button_widget.dart';
import 'package:epose_app/core/ui/widgets/text/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/configs/app_colors.dart';
import '../../../../core/routes/routes.dart';
import '../controller/bagShopping_controller.dart';
import '../widgets/bagShopping_card_widget.dart';
import '../../../../core/services/model/bagShopping_model.dart';

class BagShoppingPage extends GetView<BagShoppingController> {
  const BagShoppingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giỏ hàng', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Obx(
        () {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else if (controller.shoppingBag.isEmpty) {
            return const Center(child: Text('Giỏ hàng của bạn trống.'));
          } else {
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              itemCount: controller.shoppingBag.length,
              itemBuilder: (context, storeIndex) {
                final store = controller.shoppingBag[storeIndex];
                final storeName = store['storeName'];
                final storeLogo =
                    (store['products'] as List<BagItemModel>).first.store.logo;
                final products = store['products'] as List<BagItemModel>;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          if (storeLogo.isNotEmpty)
                            Image.network(
                              storeLogo,
                              width: 30,
                              height: 30,
                              fit: BoxFit.cover,
                            ),
                          const SizedBox(width: 8),
                          Text(
                            storeName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: products.length,
                      itemBuilder: (context, productIndex) {
                        final product = products[productIndex];

                        return BagShoppingCard(
                          bagItem: product,
                          onIncrement: () {
                            controller.incrementQuantity(
                                storeIndex, productIndex);
                          },
                          onDecrement: () {
                            controller.decrementQuantity(
                                storeIndex, productIndex);
                          },
                          onSelect: (isSelected) {
                            controller.toggleSelection(
                                storeIndex, productIndex);
                          },
                          onConfirmRemove: () {
                            controller.confirmRemoveItem(
                                product.idItem, product.size);
                          },
                        );
                      },
                    ),
                    const Divider(
                      color: AppColors.grey1,
                      thickness: 0.5,
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
        shadowColor: AppColors.primary,
        color: AppColors.white,
        child: Container(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tổng thanh toán',
                    style: TextStyle(color: AppColors.grey),
                  ),
                  Obx(
                    () {
                      final formattedTotalAmount =
                          NumberFormat("#,##0", "vi_VN")
                              .format(controller.totalAmount);
                      return TextWidget(
                        text: '$formattedTotalAmount vnđ',
                        fontWeight: FontWeight.bold,
                        size: 18,
                        color: AppColors.primary,
                      );
                    },
                  ),
                ],
              ),
              SizedBox(
                width: Get.width * 0.3 + 10,
                child: ButtonWidget(
                  ontap: () {
                    final selectedBagItems = controller.shoppingBag
                        .expand((store) => store['products'])
                        .where((item) => item.isSelected)
                        .cast<
                            BagItemModel>() 
                        .toList();

                    if (selectedBagItems.isNotEmpty) {
                      Get.toNamed(
                        Routes.lendDetails,
                        arguments:selectedBagItems, 
                      );
                    } else {
                      Get.snackbar(
                          "Thông báo", "Vui lòng chọn sản phẩm để thuê");
                    }
                  },
                  text: 'Thuê ngay',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
