import 'package:flutter/material.dart';
import '../../../../../../core/configs/app_colors.dart';
import '../../../../../../core/configs/app_dimens.dart';

class ClothesCard extends StatelessWidget {
  final String imageUrl;
  final String storeName;
  final String price;
  final String productName;
  final String tags;

  const ClothesCard({
    Key? key,
    required this.imageUrl,
    required this.storeName,
    required this.price,
    required this.productName,
    required this.tags,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(5.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey[200],
                radius: 15,
                backgroundImage: NetworkImage(
                    'https://pos.nvncdn.com/af3c03-152482/ps/20230826_8rhbS9b5xv.jpeg'),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      storeName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: AppDimens.textSize14,
                        color: AppColors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Theo dõi',
                      style: TextStyle(
                        fontSize: AppDimens.textSize12,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          // Ảnh sản phẩm
          ClipRRect(
            child: Image.network(
              imageUrl,
              width: double.infinity,
              height: 160,
              fit: BoxFit.cover,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Row(
                children: [
                  Column(
                    children: [
                      Text(
                        productName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: AppDimens.textSize16,
                          color: AppColors.black,
                        ),
                      ),
                      Text(
                        price,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: AppDimens.textSize16,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.favorite_border),
                    color: AppColors.primary,
                  )
                ],
              ),
              const SizedBox(height: 5),
              // Các tag của sản phẩm
              Wrap(
                spacing: 4,
                children: tags
                    .split(',')
                    .map(
                      (tag) => Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          tag.trim(),
                          style: const TextStyle(
                            fontSize: AppDimens.textSize12,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
