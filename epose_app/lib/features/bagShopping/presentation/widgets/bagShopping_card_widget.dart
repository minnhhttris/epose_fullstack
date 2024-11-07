import 'package:epose_app/core/ui/widgets/text/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/configs/app_colors.dart';
import '../../../../core/services/model/bagShopping_model.dart';

class BagShoppingCard extends StatelessWidget {
  final BagItemModel bagItem;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final ValueChanged<bool?> onSelect;
  final VoidCallback onConfirmRemove;

  const BagShoppingCard({
    Key? key,
    required this.bagItem,
    required this.onIncrement,
    required this.onDecrement,
    required this.onSelect,
    required this.onConfirmRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final NumberFormat currencyFormat = NumberFormat("#,##0", "vi_VN");
    final String formattedPrice = currencyFormat.format(bagItem.clothes.price);

    return Dismissible(
      key: Key(bagItem.idItem), 
      direction: DismissDirection.endToStart, 
      confirmDismiss: (direction) async {
        onConfirmRemove();
        return false; 
      },
      background: Container(
        color: Colors.red,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.centerRight,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
    
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Checkbox(
            activeColor: AppColors.primary,
            value: bagItem.isSelected,
            onChanged: (value) {
              if (value != null) {
                onSelect(value);
              }
            },
          ),
          Image.network(
            bagItem.clothes.listPicture.isNotEmpty
                ? bagItem.clothes.listPicture.first
                : '',
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  text: bagItem.clothes.nameItem,
                  size: 14,
                  fontWeight: FontWeight.w500,
                ),
                const SizedBox(height: 5),
                TextWidget(
                  text: 'Size: ${bagItem.size}',
                  size: 12,
                  color: AppColors.grey,
                ),
                const SizedBox(height: 5),
                TextWidget(
                  text: '${formattedPrice} vnđ',
                  fontWeight: FontWeight.bold,
                  size: 14,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: onIncrement,
                icon: const Icon(Icons.add),
                color: AppColors.grey,
              ),
              Text(
                '${bagItem.quantity}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              IconButton(
                onPressed: onDecrement,
                icon: const Icon(Icons.remove),
                color: AppColors.grey,
              ),
            ],
          ),
        ],
      ),
      ),
    );
  }
}
