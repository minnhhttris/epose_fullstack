import 'package:epose_app/core/ui/widgets/text/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../../core/configs/app_colors.dart';
import '../controller/rating_controller.dart';

class RatingPage extends GetView<RatingController> {
  const RatingPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Map lưu trữ dữ liệu đánh giá tạm thời
    final Map<String, Map<String, dynamic>> ratings = {};

    return Scaffold(
      appBar: AppBar(
        title: const Text('Đánh giá đơn thuê'),
      ),
      body: Obx(() {
        final bill = controller.billDetails.value;
        if (bill == null) {
          return const Center(child: CircularProgressIndicator());
        }

        // Hiển thị danh sách sản phẩm trong Bill
        return ListView.builder(
          itemCount: bill.billItems.length,
          itemBuilder: (context, index) {
            final item = bill.billItems[index];
            return Card(
              color: Colors.white,
              margin:const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      text: item.clothes.nameItem,
                      size: 18, 
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        item.clothes.listPicture.first,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        TextWidget(
                          text: "Đánh giá: ",
                          size: 14,
                        ),
                        Expanded(
                          child: RatingBar.builder(
                            initialRating: ratings[item.idItem]?['ratingStar'] ?? 0,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              ratings[item.idItem] = {
                                ...?ratings[item.idItem],
                                'ratingStar': rating,
                              };
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextWidget(
                      text: "Nhận xét:",
                      size: 14,
                    ),
                    const SizedBox(height: 5),
                    TextField(
                      maxLines: 5, 
                      minLines: 3, 
                      decoration: InputDecoration(
                        hintText: 'Nhận xét của bạn...',
                        hintStyle: const TextStyle(
                          color: Colors.grey, 
                          fontStyle: FontStyle.italic,
                        ),
                        
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 16.0,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: AppColors.primary, 
                            width: 1.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.grey, 
                            width: 1.0,
                          ),
                        ),
                        filled: true,
                        fillColor: AppColors.white, 
                      ),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black, 
                      ),
                      onChanged: (value) {
                        ratings[item.idItem] = {
                          ...?ratings[item.idItem],
                          'ratingComment': value,
                        };
                      },
                    ),

                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          final ratingStar =
                              ratings[item.idItem]?['ratingStar'] ?? 1.0;
                          final ratingComment =
                              ratings[item.idItem]?['ratingComment'] ?? '';
                          controller.submitRating(
                            bill.idBill,
                            item.idItem,
                            ratingStar,
                            ratingComment,
                          );
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 5,
                          ),
                          textStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: const Text('Gửi đánh giá'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
