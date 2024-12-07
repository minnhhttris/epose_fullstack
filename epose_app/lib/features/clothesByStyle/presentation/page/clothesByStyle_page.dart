import 'package:epose_app/core/ui/widgets/text/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../main/nav/clothes/presentation/widgets/clothes_card_widget.dart';
import '../controller/clothesByStyle_controller.dart';

class ClothesByStylePage extends GetView<ClothesByStyleController> {
  ClothesByStylePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Lấy styleName từ controller
    final styleName = controller.styleName.value;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: TextWidget(
          text:'$styleName',
          size: 24,
        ),
      ),
      body: Obx(() {
        // Hiển thị trạng thái loading
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // Lấy danh sách sản phẩm đã lọc
        final filteredClothes = controller.listClothes;

        // Kiểm tra danh sách sản phẩm trống
        if (filteredClothes.isEmpty) {
          return const Center(child: Text('Không có sản phẩm.'));
        }
        
        // Hiển thị danh sách sản phẩm trong GridView
        return GridView.builder(
          padding: const EdgeInsets.all(3.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 3.0,
            mainAxisSpacing: 3.0,
            childAspectRatio: 0.6,
          ),
          itemCount: filteredClothes.length,
          itemBuilder: (context, index) {
            final clothes = filteredClothes[index];
            return ClothesCard(
              clothes: clothes,
            );
          },
        );
      }),
    );
  }
}
