import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/configs/app_colors.dart';
import '../controller/coins_controller.dart';

class CoinsPage extends GetView<CoinsController> {
  const CoinsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Điểm danh nhận xu thưởng"),
        backgroundColor: AppColors.primary,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        return Column(
          children: [
            SizedBox(height: 20),
            Text(
              "Điểm danh tuần này",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(7, (index) {
                  return Column(
                    children: [
                      Icon(
                        controller.attendanceDays[index]
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: controller.attendanceDays[index]
                            ? Colors.green
                            : Colors.grey,
                        size: 40,
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Thứ ${index + 2}",
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  );
                }),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => controller.checkIn(),
              child: Text("Điểm danh ngay"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Xu hiện tại: ${controller.user?.coins ?? 0}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        );
      }),
    );
  }
}
