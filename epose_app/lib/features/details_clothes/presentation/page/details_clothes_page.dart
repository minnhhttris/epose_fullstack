import 'package:epose_app/core/ui/widgets/button/button_widget.dart';
import 'package:epose_app/core/ui/widgets/text/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/configs/app_colors.dart';
import '../../../../core/configs/app_images_string.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/services/model/bill_model.dart';
import '../../../../core/services/model/clothes_model.dart';
import '../controller/details_clothes_controller.dart';


class DetailsClothesPage extends GetView<DetailsClothesController> {
  const DetailsClothesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: detailsClothesAppBar(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.clothes == null) {
          return const Center(child: Text("Không có dữ liệu"));
        }

        final clothes = controller.clothes!;
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hiển thị carousel hình ảnh
                SizedBox(
                  height: 400,
                  child: PageView.builder(
                    itemCount: clothes.listPicture.length,
                    onPageChanged: (index) {
                      controller.currentImageIndex.value = index;
                    },
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          _showFullScreenImage(
                              context, clothes.listPicture, index);
                        },
                        child: Hero(
                          tag: clothes
                              .listPicture[index], 
                          child: Image.network(
                            clothes.listPicture[index],
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),

                Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:
                          List.generate(clothes.listPicture.length, (index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: controller.currentImageIndex.value == index
                              ? 10
                              : 8,
                          height: controller.currentImageIndex.value == index
                              ? 10
                              : 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: controller.currentImageIndex.value == index
                                ? Colors.blue
                                : Colors.grey,
                          ),
                        );
                      }),
                    )),

                const SizedBox(height: 20),

                TextWidget(
                  text: "Tên sản phẩm: "+clothes.nameItem,
                  size: 20,
                ),

                const SizedBox(height: 5),

                // Giá sản phẩm
                TextWidget(
                  text: 'Giá thuê: ${clothes.price.toStringAsFixed(0)} VND / ngày',
                  size: 20, 
                  color: Colors.red
                ),

                const SizedBox(height: 20),

                // Mô tả sản phẩm
                TextWidget(
                  text: 'Mô tả chi tiết:',
                  size: 18, 
                  fontWeight: FontWeight.bold
                ),
                TextWidget(
                  text: clothes.description,
                  size: 16,
                ),
                TextWidget(
                  text: 'Màu sắc: ${_getColorName(clothes.color)}',
                  size: 16,
                ),
                TextWidget(
                  text: 'Kiểu dáng: ${_getStyleName(clothes.style)}',
                  size: 16
                ),
                TextWidget(
                  text: 'Giới tính: ${_getGenderName(clothes.gender)}',
                  size: 16,
                ),

                const SizedBox(height: 10),

                TextWidget(
                  text: 'Kích cỡ và số lượng:',
                  size: 18, 
                  fontWeight: FontWeight.bold,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: clothes.itemSizes.map((size) {
                    return Text(
                      'Size: ${_getSizeName(size.size)}, Số lượng: ${size.quantity}',
                      style: const TextStyle(fontSize: 16),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 16),

                Divider(
                  color: AppColors.grey3,
                  thickness: 0.5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < clothes.rate.round()
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                        );
                      }),
                    ),
                    
                  ],
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: ButtonWidget(
                        ontap: () {
                          _showRentDialog(context, clothes);
                        },
                        text: 'Thuê ngay',
                      ),
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      icon: SvgPicture.asset(
                        AppImagesString.eBagShopping,
                        color: AppColors.primary,
                        width: 40,
                      ), 
                      onPressed: () { 
                        _showAddShoppingBagDialog(context, clothes);
                     },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

   AppBar detailsClothesAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      leading: Obx(() {
        return controller.isLoading.value
            ? const CircularProgressIndicator()
            : controller.clothes == null
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundImage:
                          NetworkImage(controller.clothes!.store!.logo),
                    ),
                  );
      }),
      title: Obx(() {
        return controller.isLoading.value
            ? const Text('Loading...')
            : controller.clothes == null
                ? const Text('No clothes found')
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                        text: controller.clothes!.store!.nameStore,
                        size: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      Text(
                        DateFormat('dd/MM/yyyy')
                            .format(controller.clothes!.createdAt),
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.grey),
                      ),
                    ],
                  );
      }),
      actions: [
        Obx(() {
          if (controller.isLoading.value ||
              controller.clothes == null ||
              controller.clothes!.idStore != controller.store?.idStore) {
            return const SizedBox(); 
          }
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  Get.toNamed(Routes.editClothes,
                      arguments: controller.clothes!.idItem); 
                } else if (value == 'delete') {
                  controller.deleteClothes(controller.clothes!.idItem);
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem<String>(
                    value: 'edit',
                    child: Text('Chỉnh sửa'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'delete',
                    child: Text('Xóa'),
                  ),
                ];
              },
              icon: const Icon(
                Icons.more_vert,
                color: AppColors.black,
              ),
            ),
          );
        }),
      ],
    );
  }

  void _showFullScreenImage(
      BuildContext context, List<String> imageUrls, int initialIndex) {
    PageController pageController = PageController(initialPage: initialIndex);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Scaffold(
          backgroundColor: Colors.black, 
          body: Stack(
            children: [
              PageView.builder(
                controller: pageController,
                itemCount: imageUrls.length,
                itemBuilder: (context, index) {
                  return Hero(
                    tag:
                        imageUrls[index], 
                    child: Center(
                      child: Image.network(
                        imageUrls[index],
                        fit:
                            BoxFit.contain, 
                      ),
                    ),
                  );
                },
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () {
                    Navigator.pop(context); 
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }



  void _showRentDialog(BuildContext context, ClothesModel clothes) {
    final selectedSize = ''.obs;
    final selectedQuantity = 1.obs;
    final startDate = Rxn<DateTime>();
    final endDate = Rxn<DateTime>();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TextWidget(
                text: 'Thông tin thuê',
                size: 18, fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Obx(() => DropdownButtonFormField<String>(
                          decoration:
                              const InputDecoration(labelText: 'Kích cỡ'),
                          items: clothes.itemSizes.map((itemSize) {
                            return DropdownMenuItem(
                              value: itemSize.size.toString(),
                              child: Text(_getSizeName(itemSize.size)),
                            );
                          }).toList(),
                          onChanged: (value) {
                            selectedSize.value = value!;
                            selectedQuantity.value =
                                1; 
                          },
                          value: selectedSize.value.isEmpty
                              ? null
                              : selectedSize.value,
                        )),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: Obx(() {
                      int maxQuantity = 0;
                      final selectedItemSize = clothes.itemSizes
                          .where((item) =>
                              item.size.toString() == selectedSize.value)
                          .toList();

                      if (selectedItemSize.isNotEmpty) {
                        maxQuantity = selectedItemSize.first.quantity;
                      }

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              if (selectedQuantity.value > 1) {
                                selectedQuantity.value--;
                              }
                            },
                            icon: const Icon(Icons.remove),
                            color: Colors.grey,
                            iconSize: 20,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: Text(
                              '${selectedQuantity.value}',
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                          // Nút tăng số lượng
                          IconButton(
                            onPressed: () {
                              if (selectedQuantity.value < maxQuantity) {
                                selectedQuantity.value++;
                              } else {
                                Get.snackbar("Thông báo",
                                    "Số lượng không được vượt quá $maxQuantity");
                              }
                            },
                            icon: const Icon(Icons.add),
                            color: Colors.grey,
                            iconSize: 20,
                          ),
                        ],
                      );
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        backgroundColor: AppColors.primary1,

                      ),
                      onPressed: () async {
                        DateTime minStartDate =
                            DateTime.now().add(const Duration(days: 2));
                        startDate.value = await showDatePicker(
                          context: context,
                          initialDate: minStartDate,
                          firstDate: minStartDate,
                          lastDate: DateTime(2100),
                          builder: (context, child) {
                            return Theme(
                              data: ThemeData.light().copyWith(
                                colorScheme: ColorScheme.light(
                                  primary: AppColors.primary, 
                                  onPrimary:AppColors.white, 
                                  surface: AppColors.primary2, 
                                  onSurface: Colors.black, 
                                ),
                                buttonTheme: ButtonThemeData(
                                  textTheme: ButtonTextTheme
                                      .primary, 
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                      },
                      child: Obx(() => Text(
                        style: const TextStyle(color: AppColors.primary),
                        startDate.value != null
                          ? 'Từ: ${DateFormat('dd/MM/yyyy').format(startDate.value!)}'
                          : 'Chọn ngày thuê')),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        backgroundColor: AppColors.primary1,
                      ),
                      onPressed: () async {
                        if (startDate.value == null) {
                          Get.snackbar(
                              'Lỗi', 'Vui lòng chọn ngày thuê trước');
                          return;
                        }
                        endDate.value = await showDatePicker(
                          context: context,
                          initialDate: startDate.value ?? DateTime.now(),
                          firstDate: startDate.value ?? DateTime.now(),
                          lastDate: DateTime(2100),
                          builder: (context, child) {
                            return Theme(
                              data: ThemeData.light().copyWith(
                                colorScheme: ColorScheme.light(
                                  primary: AppColors.primary, 
                                  onPrimary: AppColors.white, 
                                  surface: AppColors.primary2,
                                  onSurface: Colors.black, 
                                ),
                                buttonTheme: ButtonThemeData(
                                  textTheme: ButtonTextTheme
                                      .primary, 
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                      },
                      child: Obx(() => Text(
                        style: const TextStyle(color: AppColors.primary),
                        endDate.value != null
                          ? 'Đến: ${DateFormat('dd/MM/yyyy').format(endDate.value!)}'
                          : 'Chọn ngày trả')),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              ButtonWidget(
                ontap: () {
                  if (selectedSize.value.isNotEmpty &&
                      selectedQuantity.value > 0 &&
                      startDate.value != null &&
                      endDate.value != null) {
                    // Get.snackbar('Thuê thành công',
                    //     'Kích cỡ: ${selectedSize.value}, Số lượng: ${selectedQuantity.value}, Ngày thuê: ${DateFormat('dd/MM/yyyy').format(startDate.value!)} - ${DateFormat('dd/MM/yyyy').format(endDate.value!)}');
                    final billItem = BillItemModel(
                      idBill: '', 
                      idItem: clothes.idItem,
                      size: selectedSize.value,
                      quantity: selectedQuantity.value,
                      clothes: clothes, 
                    );

                    Get.toNamed(
                      Routes.lendDetails,
                      arguments: {
                        'billItems': [billItem],
                        'startDate': startDate.value,
                        'endDate': endDate.value,
                      },
                    );
                  } else {
                    Get.snackbar('Lỗi', 'Vui lòng chọn đầy đủ thông tin');
                  }
                },
                text: 'Thuê ngay',
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddShoppingBagDialog(BuildContext context, ClothesModel clothes) {
    final selectedSize = ''.obs;
    final selectedQuantity = 1.obs;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TextWidget(
                text: 'Thêm vào giỏ hàng',
                size: 18,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Obx(() => DropdownButtonFormField<String>(
                          decoration:
                              const InputDecoration(labelText: 'Kích cỡ'),
                          items: clothes.itemSizes.map((itemSize) {
                            return DropdownMenuItem(
                              value: itemSize.size.toString(),
                              child: Text(_getSizeName(itemSize.size)),
                            );
                          }).toList(),
                          onChanged: (value) {
                            selectedSize.value = value!;
                            selectedQuantity.value = 1;
                          },
                          value: selectedSize.value.isEmpty
                              ? null
                              : selectedSize.value,
                        )),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: Obx(() {
                      int maxQuantity = 0;
                      final selectedItemSize = clothes.itemSizes
                          .where((item) =>
                              item.size.toString() == selectedSize.value)
                          .toList();

                      if (selectedItemSize.isNotEmpty) {
                        maxQuantity = selectedItemSize.first.quantity;
                      }

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              if (selectedQuantity.value > 1) {
                                selectedQuantity.value--;
                              }
                            },
                            icon: const Icon(Icons.remove),
                            color: Colors.grey,
                            iconSize: 20,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: Text(
                              '${selectedQuantity.value}',
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                          // Nút tăng số lượng
                          IconButton(
                            onPressed: () {
                              if (selectedQuantity.value < maxQuantity) {
                                selectedQuantity.value++;
                              } else {
                                Get.snackbar("Thông báo",
                                    "Số lượng không được vượt quá $maxQuantity");
                              }
                            },
                            icon: const Icon(Icons.add),
                            color: Colors.grey,
                            iconSize: 20,
                          ),
                        ],
                      );
                    }),
                  ),
                ],
              ),
              SizedBox(height: 10),
              ButtonWidget(
                ontap: () {
                  if (selectedSize.value.isNotEmpty &&
                      selectedQuantity.value > 0
                    ) {
                    controller.addItemToBag(
                        clothes.store!.idStore,
                        clothes.idItem,
                        selectedSize.value,
                        selectedQuantity.value
                    );
                    Navigator.pop(context);
                  } else {
                    Get.snackbar('Lỗi', 'Vui lòng chọn đầy đủ thông tin');
                  }
                },
                text: 'Thêm vào giỏ hàng',
              ),
            ],
          ),
        );
      },
    );
  }

  String _getColorName(Color color) {
    switch (color) {
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
        return 'Đa sắc';
      default:
        return 'Không xác định';
    }
  }

  String _getStyleName(Style style) {
    switch (style) {
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
        return 'Hóa trang';
      case Style.cac_nuoc:
        return 'Các nước';
      default:
        return 'Không xác định';
    }
  }

  // Chuyển enum Giới tính sang tiếng Việt
  String _getGenderName(Gender gender) {
    switch (gender) {
      case Gender.male:
        return 'Nam';
      case Gender.female:
        return 'Nữ';
      case Gender.unisex:
        return 'Không phân biệt';
      case Gender.other:
        return 'Khác';
      default:
        return 'Không xác định';
    }
  }

  // Chuyển enum Kích cỡ sang tiếng Việt
  String _getSizeName(SizeEnum size) {
    switch (size) {
      case SizeEnum.S:
        return 'S';
      case SizeEnum.M:
        return 'M';
      case SizeEnum.L:
        return 'L';
      case SizeEnum.XL:
        return 'XL';
      default:
        return 'Không xác định';
    }
  }
}
