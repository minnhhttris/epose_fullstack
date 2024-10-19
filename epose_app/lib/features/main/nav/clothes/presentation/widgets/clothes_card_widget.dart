import 'package:epose_app/core/configs/app_images_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../../../core/configs/app_colors.dart';
import '../../../../../../core/configs/app_dimens.dart';
import '../../../../../../core/routes/routes.dart';
import '../../../../../../core/services/model/clothes_model.dart';
import '../../../../../../core/ui/widgets/button/button_widget.dart';

class ClothesCard extends StatelessWidget {
  final ClothesModel clothes;

  const ClothesCard({
    Key? key,
    required this.clothes,
  }) : super(key: key);

  // Định dạng giá thành tiền tệ
  String formatPrice(double price) {
    final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: 'vnđ');
    return formatCurrency.format(price);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.detailsClothes, arguments: clothes.idItem);
      },
      child: Card(
        color: AppColors.white,
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
                  backgroundColor: AppColors.white,
                  radius: 20,
                  backgroundImage: NetworkImage(clothes.store != null ? clothes.store!.logo : ''),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        clothes.store != null ? clothes.store!.nameStore : " ",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: AppDimens.textSize12,
                          color: AppColors.black,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      ButtonWidget(
                        ontap: () {},
                        text: "Theo dõi",
                        height: 18,
                        width: 50,
                        fontSize: 8,
                        fontWeight: FontWeight.w300,
                        textColor: AppColors.black,
                        backgroundColor: Colors.white,
                        isBorder: true,
                        borderColor: AppColors.grey1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            ClipRRect(
              child: Image.network(
                clothes.listPicture.isNotEmpty ? clothes.listPicture.first : '',
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          clothes.nameItem,
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: AppDimens.textSize13,
                            color: AppColors.black,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          formatPrice(
                              clothes.price), 
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: AppDimens.textSize13,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    SvgPicture.asset(
                      AppImagesString.eBagShopping,
                      color: AppColors.primary,
                      width: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                // Tags for color, style, and gender
                Wrap(
                  spacing: 4,
                  children: [
                    _buildTag(clothes.color.name), 
                    _buildTag(clothes.style.name), 
                    _buildTag(clothes.gender.name), 
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 8,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.grey1,
        ),
        color: AppColors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        tag,
        style: const TextStyle(
          fontSize: 10,
          color: AppColors.black,
        ),
      ),
    );
  }
}
