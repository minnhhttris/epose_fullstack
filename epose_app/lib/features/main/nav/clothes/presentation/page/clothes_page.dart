import 'package:epose_app/core/ui/widgets/button/button_widget.dart';
import 'package:epose_app/core/ui/widgets/text/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/configs/app_colors.dart';
import '../../../../../../core/configs/app_dimens.dart';
import '../../../../../../core/services/model/clothes_model.dart';
import '../controller/clothes_controller.dart';
import '../widgets/clothes_appbar_widget.dart';
import '../widgets/clothes_card_widget.dart';
import '../widgets/filter_button.dart';

class ClothesPage extends GetView<ClothesController> {
  const ClothesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ClothesAppbar(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleAndButtonFilter(),
              if (controller.listClothes.isEmpty ||
                  controller.filteredClothes.isEmpty)
                Stack(
                  children: [
                    Container(
                      height: Get.height * 0.8,
                      child: const Center(
                        child: TextWidget(
                          text: 'Không có sản phẩm nào',
                          color: AppColors.black,
                          size: AppDimens.textSize16,
                        ),
                      ),
                    ),
                    Obx(
                      () => controller.isFilterMenuOpen.value
                          ? Positioned(
                              top: 0,
                              right: 0,
                              child: buildFilterMenu(),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                )
              else
                listClothes(),
            ],
          ),
        );
      }),
    );
  }

  Padding titleAndButtonFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Text(
                'Gần đây',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: AppDimens.textSize18,
                  color: AppColors.black,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh, color: AppColors.grey1),
                onPressed: () {
                  // Gọi hàm tải lại dữ liệu
                  controller.getAllClothes();
                },
              ),
            ],
          ),
          FilterButton(
            onTap: controller.toggleFilterMenu,
          ),
        ],
      ),
    );
  }

  Widget listClothes() {
    return Stack(
      children: [
        Column(
          children: [
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(3.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 3.0,
                mainAxisSpacing: 3.0,
                childAspectRatio: 0.6,
              ),
              itemCount: controller.filteredClothes.length,
              itemBuilder: (context, index) {
                final item = controller.filteredClothes[index];
                return ClothesCard(
                  clothes: item,
                );
              },
            ),
            if (controller.filteredClothes.length <= 2)
              const SizedBox(height: 60),
          ],
        ),
        Obx(
          () => controller.isFilterMenuOpen.value
              ? Positioned(
                  top: 0,
                  right: 0,
                  child: buildFilterMenu(),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Container buildFilterMenu() {
    return Container(
      width: Get.width * 0.6,
      height: Get.height * 0.5,
      color: AppColors.primary2.withOpacity(0.9),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bộ lọc giới tính
              ListTile(
                title: const TextWidget(text: 'Giới tính'),
                trailing: Obx(() => Icon(
                      controller.isGenderFilterOpen.value
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down,
                      color: AppColors.primary,
                    )),
                onTap: () {
                  controller.isGenderFilterOpen.value =
                      !controller.isGenderFilterOpen.value;
                },
              ),
              Obx(() {
                if (controller.isGenderFilterOpen.value) {
                  return buildFilterSection<Gender>(
                    Gender.values,
                    controller.selectedGenders,
                  );
                }
                return const SizedBox.shrink();
              }),

              const Divider(color: AppColors.primary, thickness: 0.5),

              // Bộ lọc màu sắc
              ListTile(
                title: const Text('Màu sắc'),
                trailing: Obx(() => Icon(
                      controller.isColorFilterOpen.value
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down,
                      color: AppColors.primary,
                    )),
                onTap: () {
                  controller.isColorFilterOpen.value =
                      !controller.isColorFilterOpen.value;
                },
              ),
              Obx(() {
                if (controller.isColorFilterOpen.value) {
                  return buildFilterSection<Color>(
                    Color.values,
                    controller.selectedColors,
                  );
                }
                return const SizedBox.shrink();
              }),

              const Divider(color: AppColors.primary, thickness: 0.5),

              // Bộ lọc kiểu dáng
              ListTile(
                title: const Text('Kiểu dáng'),
                trailing: Obx(() => Icon(
                      controller.isStyleFilterOpen.value
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down,
                      color: AppColors.primary,
                    )),
                onTap: () {
                  controller.isStyleFilterOpen.value =
                      !controller.isStyleFilterOpen.value;
                },
              ),
              Obx(() {
                if (controller.isStyleFilterOpen.value) {
                  return buildFilterSection<Style>(
                    Style.values,
                    controller.selectedStyles,
                  );
                }
                return const SizedBox.shrink();
              }),

              const Divider(color: AppColors.primary, thickness: 0.5),

              // Bộ lọc giá tiền
              ListTile(
                title: const Text('Giá tiền'),
                trailing: Obx(() => Icon(
                      controller.isPriceFilterOpen.value
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down,
                      color: AppColors.primary,
                    )),
                onTap: () {
                  controller.isPriceFilterOpen.value =
                      !controller.isPriceFilterOpen.value;
                },
              ),
              Obx(() {
                if (controller.isPriceFilterOpen.value) {
                  return buildPriceFilter();
                }
                return const SizedBox.shrink();
              }),

              const SizedBox(height: 10),

              // Nút Thiết lập lại và Áp dụng
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ButtonWidget(
                    width: 100,
                    height: 40,
                    ontap: () {
                      controller.resetFilters();
                    },
                    backgroundColor: AppColors.white,
                    text: 'Thiết lập lại',
                    textColor: AppColors.black,
                    borderRadius: 5,
                  ),
                  const Spacer(),
                  ButtonWidget(
                    width: 100,
                    height: 40,
                    ontap: () {
                      controller.applyFilters();
                    },
                    backgroundColor: AppColors.primary,
                    text: 'Áp dụng',
                    textColor: AppColors.white,
                    borderRadius: 5,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFilterSection<T>(List<T> options, RxList<T> selectedOptions) {
    return Wrap(
      spacing: 4.0, 
      runSpacing: 2.0, 
      children: options.map((option) {
        return ChoiceChip(
          label: Text(
            getText(option), 
            style: TextStyle(
              color: selectedOptions.contains(option)
                  ? Colors.white
                  : Colors.black,
            ),
          ),
          selected: selectedOptions.contains(option),
          onSelected: (isSelected) {
            if (isSelected) {
              selectedOptions.add(option);
            } else {
              selectedOptions.remove(option);
            }
          },
          selectedColor: AppColors.primary, 
          backgroundColor: AppColors.grey2, 
          padding: const EdgeInsets.symmetric(
              horizontal: 2.0,
              vertical: 4.0), 
        );
      }).toList(),
    );
  }

 Widget buildPriceFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(6, (index) {
              final priceMark = index * 100000;
              return Text(
                '${priceMark ~/ 1000}K',
                style: const TextStyle(fontSize: 12, color: AppColors.black),
              );
            }),
          ),
        ),
        // RangeSlider với chiều rộng mở rộng
        Container(
          width: double.infinity, 
          child: RangeSlider(
            values: RangeValues(
              controller.minPrice.value,
              controller.maxPrice.value,
            ),
            min: 0,
            max: 500000,
            divisions: 10, // Chia đoạn 50K
            labels: RangeLabels(
              '${controller.minPrice.value.toInt()} vnđ',
              '${controller.maxPrice.value.toInt()} vnđ',
            ),
            activeColor: AppColors.primary, // Màu thanh đã chọn
            inactiveColor: AppColors.grey2, // Màu thanh chưa chọn
            onChanged: (RangeValues values) {
              controller.minPrice.value = values.start;
              controller.maxPrice.value = values.end;
            },
          ),
        ),
      ],
    );
  }




 String getText(dynamic option) {
    switch (option) {
      // Gender
      case Gender.male:
        return 'Nam';
      case Gender.female:
        return 'Nữ';
      case Gender.unisex:
        return 'Unisex';
      case Gender.other:
        return 'Khác';

      // Color
      case Color.red:
        return 'Đỏ';
      case Color.blue:
        return 'Xanh dương';
      case Color.green:
        return 'Xanh lá';
      case Color.yellow:
        return 'Vàng';
      case Color.black:
        return 'Đen';
      case Color.white:
        return 'Trắng';
      case Color.pink:
        return 'Hồng';
      case Color.purple:
        return 'Tím';
      case Color.orange:
        return 'Cam';
      case Color.brown:
        return 'Nâu';
      case Color.gray:
        return 'Xám';
      case Color.beige:
        return 'Be';
      case Color.colorfull:
        return 'Nhiều màu';

      // Style
      case Style.ao_dai:
        return 'Áo dài';
      case Style.tu_than:
        return 'Tứ thân';
      case Style.co_phuc:
        return 'Cổ phục';
      case Style.ao_ba_ba:
        return 'Áo bà ba';
      case Style.da_hoi:
        return 'Dạ hội';
      case Style.nang_tho:
        return 'Nàng thơ';
      case Style.hoc_duong:
        return 'Học đường';
      case Style.vintage:
        return 'Vintage';
      case Style.ca_tinh:
        return 'Cá tính';
      case Style.sexy:
        return 'Sexy';
      case Style.cong_so:
        return 'Công sở';
      case Style.dan_toc:
        return 'Dân tộc';
      case Style.do_doi:
        return 'Đồ đôi';
      case Style.hoa_trang:
        return 'Hoá trang';
      case Style.cac_nuoc:
        return 'Các nước';
      default:
        return option.toString().split('.').last;
    }
  }

}
