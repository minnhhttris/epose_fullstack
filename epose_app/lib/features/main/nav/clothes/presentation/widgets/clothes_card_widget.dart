import 'package:epose_app/features/store/presentation/controller/store_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../../../core/configs/app_colors.dart';
import '../../../../../../core/configs/app_dimens.dart';
import '../../../../../../core/routes/routes.dart';
import '../../../../../../core/services/model/clothes_model.dart';
import '../../../../../clothesByStyle/presentation/controller/clothesByStyle_controller.dart';
import '../../../home/presentation/controller/home_controller.dart';
import '../controller/clothes_controller.dart';

class ClothesCard extends StatelessWidget {
  final ClothesModel clothes;


  const ClothesCard({
    Key? key,
    required this.clothes,
  }) : super(key: key);

  // Định dạng giá thành tiền tệ
  String formatPrice(double price) {
    final formatCurrency =
        NumberFormat.currency(locale: 'vi_VN', symbol: 'vnđ');
    return formatCurrency.format(price);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final result = await Get.toNamed(
          Routes.detailsClothes,
          arguments: {
            'idItem': clothes.idItem,
            'sourcePage': Get.currentRoute,
          },
        );

        // if (result == true) {
        //   if (Get.currentRoute == Routes.main) {
        //     Get.find<ClothesController>().init();
        //     Get.find<ClothesController>().getAllClothes();
        //   } else if (Get.currentRoute == Routes.store) {
        //     Get.find<StoreController>().getMyStore();
        //   } else if (Get.currentRoute == Routes.home) {
        //     Get.find<HomeController>().init();
        //     Get.find<HomeController>().getTop10RatedClothes();
        //   } else if (Get.currentRoute == Routes.clothesByStyle) {
        //     Get.find<ClothesByStyleController>().init();
        //     Get.find<ClothesByStyleController>().getAllClothes();
        //   }
        // }
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const SizedBox(width: 5),
                    CircleAvatar(
                      backgroundColor: AppColors.white,
                      radius: 20,
                      backgroundImage: NetworkImage(
                        clothes.store != null ? clothes.store!.logo : '',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      clothes.store != null ? clothes.store!.nameStore : " ",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: AppColors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
          
              ],
            ),
            const SizedBox(height: 2),
            ClipRRect(
              child: Image.network(
                clothes.listPicture.isNotEmpty ? clothes.listPicture.first : '',
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
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
                              formatPrice(clothes.price),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: AppDimens.textSize13,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 5),
                  // Tags for color, style, and gender
                  Wrap(
                    spacing: 3,
                    children: [
                      _buildTag(getColorName(clothes.color.name)), // Màu sắc
                      _buildTag(getStyleName(clothes.style.name)), // Kiểu dáng
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
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  // Hàm chuyển đổi màu sắc sang tiếng Việt
  String getColorName(String color) {
    switch (color.toLowerCase()) {
      case 'red':
        return 'Đỏ';
      case 'blue':
        return 'Xanh dương';
      case 'green':
        return 'Xanh lá';
      case 'yellow':
        return 'Vàng';
      case 'black':
        return 'Đen';
      case 'white':
        return 'Trắng';
      case 'pink':
        return 'Hồng';
      case 'purple':
        return 'Tím';
      case 'orange':
        return 'Cam';
      case 'brown':
        return 'Nâu';
      case 'gray':
        return 'Xám';
      case 'beige':
        return 'Be';
      case 'colorfull':
        return 'Nhiều màu';
      default:
        return 'Không xác định';
    }
  }

// Hàm chuyển đổi kiểu dáng sang tiếng Việt
  String getStyleName(String style) {
    switch (style.toLowerCase()) {
      case 'ao_dai':
        return 'Áo dài';
      case 'tu_than':
        return 'Tứ thân';
      case 'co_phuc':
        return 'Cổ phục';
      case 'ao_ba_ba':
        return 'Áo bà ba';
      case 'da_hoi':
        return 'Dạ hội';
      case 'nang_tho':
        return 'Nàng thơ';
      case 'hoc_duong':
        return 'Học đường';
      case 'vintage':
        return 'Vintage';
      case 'ca_tinh':
        return 'Cá tính';
      case 'sexy':
        return 'Sexy';
      case 'cong_so':
        return 'Công sở';
      case 'dan_toc':
        return 'Dân tộc';
      case 'do_doi':
        return 'Đồ đôi';
      case 'hoa_trang':
        return 'Hóa trang';
      case 'cac_nuoc':
        return 'Các nước';
      default:
        return 'Không xác định';
    }
  }

// Hàm chuyển đổi giới tính sang tiếng Việt
  String getGenderName(String gender) {
    switch (gender.toLowerCase()) {
      case 'male':
        return 'Nam';
      case 'female':
        return 'Nữ';
      case 'unisex':
        return 'Không phân biệt';
      case 'other':
        return 'Khác';
      default:
        return 'Không xác định';
    }
  }
}
