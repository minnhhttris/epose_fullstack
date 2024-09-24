import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/configs/app_colors.dart';
import '../../../../core/configs/app_dimens.dart';
import '../../../../core/ui/widgets/button/button_widget.dart';
import '../../../../core/ui/widgets/text/text_widget.dart';
import '../controller/bagShopping_controller.dart';
import '../widgets/bagShopping_card_widget.dart';

class BagShoppingPage extends GetView<BagShoppingController> {
  const BagShoppingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Giỏ hàng',
          style: TextStyle(color: AppColors.black),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Obx(
        () => ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: controller.shoppingBag.length,
          itemBuilder: (context, storeIndex) {
            final store = controller.shoppingBag[storeIndex];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextWidget(
                    text: store['storeName'] as String,
                    size: AppDimens.textSize16,
                    color: AppColors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: (store['products'] as List).length,
                  itemBuilder: (context, productIndex) {
                    final product = store['products'][productIndex];
                    return BagShoppingCard(
                      imageUrl: product['imageUrl'],
                      productName: product['productName'],
                      size: product['size'],
                      price: product['price'],
                      quantity: product['quantity'],
                      isSelected: product['isSelected'],
                      onIncrement: () {
                        controller.incrementQuantity(storeIndex, productIndex);
                      },
                      onDecrement: () {
                        controller.decrementQuantity(storeIndex, productIndex);
                      },
                      onSelect: (isSelected) {
                        controller.toggleSelection(storeIndex, productIndex);
                      },
                    );
                  },
                ),
                const Divider(),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TextWidget(
                    text: 'Tổng thanh toán',
                    size: AppDimens.textSize14,
                    color: AppColors.grey,
                  ),
                  Obx(
                    () => TextWidget(
                      text: '${controller.totalAmount} đ', 
                      size: AppDimens.textSize18,
                      color: AppColors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: Get.width * 0.3+10,
                child: ButtonWidget(
                  ontap: () {
                    // Xử lý thuê ngay
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
