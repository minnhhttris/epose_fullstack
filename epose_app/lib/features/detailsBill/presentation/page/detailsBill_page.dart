import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; 
import '../../../../core/services/model/bill_model.dart';
import '../controller/detailsBill_controller.dart';
import '../../../../../../core/configs/app_colors.dart';

class DetailsBillPage extends GetView<DetailsBillController> {
  const DetailsBillPage({super.key});

  String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    return formatter.format(amount);
  }

  String formatDate(DateTime date) {
    final formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(date);
  }

  Color getStatusColor(Statement status) {
    switch (status) {
      case Statement.PAID:
        return Colors.green.withOpacity(0.5);
      case Statement.CONFIRMED:
        return Colors.green.withOpacity(0.5);
      case Statement.UNPAID:
        return Colors.orange.withOpacity(0.5);
      case Statement.DELIVERING:
        return Colors.deepPurple.withOpacity(0.5);
      case Statement.PENDING_PICKUP:
        return Colors.deepPurple.withOpacity(0.5);
      case Statement.DELIVERED:
        return Colors.deepPurple.withOpacity(0.5);
      case Statement.RETURNED:
        return Colors.brown.withOpacity(0.5);
      case Statement.COMPLETED:
        return Colors.blue.withOpacity(0.5);
      case Statement.CANCELLED:
        return Colors.red.withOpacity(0.5);
      default:
        return Colors.white.withOpacity(0.5);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Chi tiết đơn hàng')
      ),
      body: Obx(
        () {
          final bill = controller.billDetails.value;
          if (bill == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  margin: const EdgeInsets.only(bottom: 20.0),
                  decoration: BoxDecoration(
                    color: getStatusColor(bill.statement),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Text(
                    '${controller.statementMapping[bill.statement]?['label']}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),

                // Bill Information
                Text('Thông tin thuê',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 10),
                Text('Tổng Tiền: ${formatCurrency(bill.sum)}'),
                Text('Đã thanh toán: ${formatCurrency(bill.downpayment)}'),
                Text('Ngày Tạo: ${formatDate(bill.createdAt)}'),
                Text('Ngày Bắt Đầu: ${formatDate(bill.dateStart)}'),
                Text('Ngày Kết Thúc: ${formatDate(bill.dateEnd)}'),

                const Divider(height: 20, color: AppColors.grey2),

                // User Information
                Text('Thông Tin Khách Thuê',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 10),
                Text('Tên: ${bill.user?.userName ?? "N/A"}'),
                Text("Căn Cước/CMND: ${bill.user?.cccd ?? "N/A"}"),
                Text('Email: ${bill.user?.email ?? "N/A"}'),
                Text('Số Điện Thoại: ${bill.user?.phoneNumbers ?? "N/A"}'),
                Text('Địa Chỉ: ${bill.user?.address ?? "N/A"}'),

                const Divider(height: 20, color: AppColors.grey2),

                // Store Information
                Text('Thông Tin Cửa Hàng',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 10),
                Text('Tên Cửa Hàng: ${bill.store?.nameStore ?? "N/A"}'),
                Text('Địa Chỉ Cửa Hàng: ${bill.store?.address ?? "N/A"}'),

                const Divider(height: 20, color: AppColors.grey2),

                // Items Information
                Text('Sản Phẩm Thuê',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 10),
                ...bill.billItems
                    .map((item) => buildBillItemCard(item))
                    .toList(),
              ],
            ),
          );
        },
      ),
    );
  }

  // Card to display each item in the bill
  Widget buildBillItemCard(BillItemModel item) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image of the item
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                item.clothes.listPicture.first,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 8),
            // Item details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.clothes.nameItem,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text('Size: ${item.size}'),
                  Text('Số lượng: ${item.quantity}'),
                  Text('Giá thuê: ${formatCurrency(item.clothes.price)}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
