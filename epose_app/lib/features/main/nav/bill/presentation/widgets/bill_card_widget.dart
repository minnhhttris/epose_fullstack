import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Import for currency formatting
import '../../../../../../core/configs/app_colors.dart';
import '../../../../../../core/routes/routes.dart';
import '../../../../../billOfStore/presentation/controller/billOfStore_controller.dart';
import '../controller/bill_controller.dart';

class BillCard extends StatelessWidget {
  final String idBill;
  final String productName;
  final DateTime startDate;
  final DateTime endDate;
  final String imageUrl;
  final double total; // New parameter for total amount

  const BillCard({
    Key? key,
    required this.idBill,
    required this.productName,
    required this.startDate,
    required this.endDate,
    required this.imageUrl,
    required this.total, // Initialize total
  }) : super(key: key);

  String formatDateRange(DateTime start, DateTime end) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return '${formatter.format(start)} - ${formatter.format(end)}';
  }

  String formatCurrency(double amount) {
    final NumberFormat formatter =
        NumberFormat.currency(locale: 'vi_VN', symbol: 'vnđ');
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: AppColors.grey2.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(color: Colors.grey.shade300),
        ),
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ngày thuê: ${formatDateRange(startDate, endDate)}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.grey,
                    ),
                  ),
                  Text(
                    'Tổng tiền: ${formatCurrency(total)}', 
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.grey,
                    ),
                  ),
                  Row(
                    children: [
                      const Text(
                        'Thông tin chi tiết:',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.grey,
                        ),
                      ),
                      const SizedBox(width: 5),
                      InkWell(
                        onTap: () {
                          Get.toNamed(Routes.detailsBill, arguments: {'idBill': idBill});
                        },
                        child: const Text(
                          'Xem thêm...',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
