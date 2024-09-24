import 'package:flutter/material.dart';
import '../../../../core/configs/app_colors.dart';
import '../../../../core/configs/app_dimens.dart';

class BagShoppingCard extends StatelessWidget {
  final String imageUrl;
  final String productName;
  final String size;
  final String price;
  final int quantity;
  final bool isSelected;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final ValueChanged<bool?> onSelect;

  const BagShoppingCard({
    Key? key,
    required this.imageUrl,
    required this.productName,
    required this.size,
    required this.price,
    required this.quantity,
    required this.isSelected,
    required this.onIncrement,
    required this.onDecrement,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Checkbox để chọn sản phẩm
          Checkbox(
            value: isSelected,
            onChanged: onSelect,
            activeColor: AppColors.primary,
          ),
          Image.network(
            imageUrl,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: AppDimens.textSize14,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Size: $size',
                  style: const TextStyle(
                    fontSize: AppDimens.textSize12,
                    color: AppColors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  price,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: AppDimens.textSize14,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            children: [
              IconButton(
                onPressed: onIncrement,
                icon: const Icon(Icons.add),
                iconSize: 24,
                color: AppColors.primary,
              ),
              Text(
                '$quantity',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: AppDimens.textSize14,
                ),
              ),
              IconButton(
                onPressed: onDecrement,
                icon: const Icon(Icons.remove),
                iconSize: 24,
                color: AppColors.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
