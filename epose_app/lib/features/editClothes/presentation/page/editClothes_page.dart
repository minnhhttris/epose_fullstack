import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../../../core/ui/widgets/textfield/custom_textfield_widget.dart';
import '../controller/editClothes_controller.dart';
import '../../../../core/configs/app_colors.dart';
import '../../../../core/configs/app_dimens.dart';
import '../../../../core/services/model/clothes_model.dart';
import '../../../../core/ui/widgets/button/button_widget.dart';
import '../../../../core/ui/widgets/text/text_widget.dart';


class EditClothesPage extends GetView<EditClothesController> {

  EditClothesPage({super.key,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back(result: true);
          },
        ),
        title: const Text('Cập Nhật Quần Áo Cho Thuê'),
        centerTitle: true,
      ),
      body: Obx(
        () {
          return controller.isLoading.value
              ? Center(child: CircularProgressIndicator()) // Hiển thị loading
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Form(
                          key: controller.formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextWidget(
                                textAlign: TextAlign.left,
                                text: 'Tên sản phẩm',
                                size: AppDimens.textSize16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                              clothesName(),
                              const SizedBox(height: 30),
                              TextWidget(
                                textAlign: TextAlign.left,
                                text: 'Giá thuê theo ngày',
                                size: AppDimens.textSize16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                              priceClothes(),
                              const SizedBox(height: 30),
                              TextWidget(
                                textAlign: TextAlign.left,
                                text: 'Hình ảnh sản phẩm',
                                size: AppDimens.textSize16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                              const SizedBox(height: 10),
                              imagesBoxClothes(),
                              const SizedBox(height: 30),
                              TextWidget(
                                textAlign: TextAlign.left,
                                text: 'Thông tin chi tiết',
                                size: AppDimens.textSize16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                              descriptionClothes(),
                              const SizedBox(height: 20),
                              TextWidget(
                                textAlign: TextAlign.left,
                                text: 'Màu sắc',
                                size: AppDimens.textSize16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                              colorsClothes(context),
                              const SizedBox(height: 30),
                              TextWidget(
                                textAlign: TextAlign.left,
                                text: 'Kiểu dáng',
                                size: AppDimens.textSize16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                              styleClothes(context),
                              const SizedBox(height: 30),
                              TextWidget(
                                textAlign: TextAlign.left,
                                text: 'Giới tính',
                                size: AppDimens.textSize16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                              genderClothes(context),
                              const SizedBox(height: 30),
                              TextWidget(
                                textAlign: TextAlign.left,
                                text: 'Kích cỡ',
                                size: AppDimens.textSize16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                              sizeClothes(context),
                              const SizedBox(height: 30),
                              ButtonWidget(
                                ontap: () {
                                  if (controller.formKey.currentState!.validate() &&
                                      controller.validateForm()) {
                                    controller.updateClothes(controller.clothes!.idItem);
                                  } else {
                                    Get.snackbar('Lỗi',
                                        'Vui lòng điền đầy đủ thông tin');
                                  }
                                },
                                text: 'Cập nhật quần áo',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }

  ListTile colorsClothes(BuildContext context) {
    return ListTile(
      title: Obx(() => Text(
            controller.colorController.value.isEmpty
                ? 'Chọn màu sắc'
                : colorMapping[Color.values.firstWhere((color) =>
                        color.name == controller.colorController.value)] ??
                    'Chọn màu sắc',
          )),
      trailing: const Icon(Icons.arrow_drop_down),
      onTap: () {
        _showEnumSelection(context, Color.values, 'Chọn màu sắc',
            (selectedColor) {
          controller.colorController.value = selectedColor.name;
          Get.back(); 
        }, colorMapping);
      },
    );
  }

  ListTile styleClothes(BuildContext context) {
    return ListTile(
      title: Obx(() => Text(
            controller.styleController.value.isEmpty
                ? 'Chọn kiểu dáng'
                : styleMapping[Style.values.firstWhere((style) =>
                        style.name == controller.styleController.value)] ??
                    'Chọn kiểu dáng',
          )),
      trailing: const Icon(Icons.arrow_drop_down),
      onTap: () {
        _showEnumSelection(context, Style.values, 'Chọn kiểu dáng',
            (selectedStyle) {
          controller.styleController.value = selectedStyle.name;
          Get.back(); // Đóng modal sau khi chọn
        }, styleMapping);
      },
    );
  }

  ListTile genderClothes(BuildContext context) {
    return ListTile(
      title: Obx(() => Text(
            controller.genderController.value.isEmpty
                ? 'Chọn giới tính'
                : genderMapping[Gender.values.firstWhere((gender) =>
                        gender.name == controller.genderController.value)] ??
                    'Chọn giới tính',
          )),
      trailing: const Icon(Icons.arrow_drop_down),
      onTap: () {
        _showEnumSelection(context, Gender.values, 'Chọn giới tính',
            (selectedGender) {
          controller.genderController.value = selectedGender.name;
          Get.back(); // Đóng modal sau khi chọn
        }, genderMapping);
      },
    );
  }

  Obx sizeClothes(BuildContext context) {
    return Obx(() {
      return Column(
        children: [
          // Hiển thị danh sách kích cỡ đã thêm
          ListView.builder(
            shrinkWrap: true,
            itemCount: controller.itemSizes.length,
            itemBuilder: (context, index) {
              final size = controller.itemSizes[index];
              final sizeController =
                  TextEditingController(text: size["quantity"].toString());

              return ListTile(
                title: Text(
                  'Size: ${size["size"]}, Số lượng: ${size["quantity"]}',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Sửa số lượng
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        // Cập nhật số lượng
                        _showEditQuantityDialog(context, index, sizeController);
                      },
                    ),
                    // Xóa kích cỡ
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        controller.itemSizes.removeAt(index);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          // Form nhập size và số lượng mới
          Row(
            children: [
              Expanded(
                child: ListTile(
                  title: Obx(() => Text(
                        controller.selectedSize.value.isEmpty
                            ? 'Chọn size'
                            : sizeMapping[SizeEnum.values.firstWhere((size) =>
                                    size.name ==
                                    controller.selectedSize.value)] ??
                                'Chọn size',
                      )),
                  trailing: const Icon(Icons.arrow_drop_down),
                  onTap: () {
                    _showEnumSelection(
                      context,
                      SizeEnum.values,
                      'Chọn size',
                      (selectedSize) {
                        controller.selectedSize.value = selectedSize.name;
                        Get.back();
                      },
                      sizeMapping,
                    );
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: CustomTextFieldWidget(
                  height: 40.0,
                  decorationType: InputDecorationType.box,
                  controller: TextEditingController(),
                  hintText: 'Số lượng',
                  keyboardType: TextInputType.number,
                  obscureText: false,
                  onChanged: (value) {
                    controller.selectedQuantity.value = value;
                  },
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 30,
                height: 42,
                child: ButtonWidget(
                  ontap: () {
                    if (controller.selectedSize.value.isNotEmpty &&
                        controller.selectedQuantity.value.isNotEmpty) {
                      controller.addSize(controller.selectedSize.value,
                          controller.selectedQuantity.value);
                      controller.selectedSize.value = ''; 
                      controller.selectedQuantity.value = ''; 
                    }
                  },
                  text: '+',
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ],
      );
    });
  }

// Hàm để hiển thị dialog chỉnh sửa số lượng
  void _showEditQuantityDialog(
      BuildContext context, int index, TextEditingController controller) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Chỉnh sửa số lượng"),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: "Nhập số lượng mới",
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Cập nhật số lượng sau khi chỉnh sửa
                String newQuantity = controller.text;
                if (newQuantity.isNotEmpty) {
                  this.controller.updateSize(index, newQuantity);
                  Navigator.of(context).pop();
                } else {
                  Get.snackbar("Error", "Số lượng không thể trống");
                }
              },
              child: const Text("Cập nhật"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Hủy"),
            ),
          ],
        );
      },
    );
  }


  Widget descriptionClothes() {
    return CustomTextFieldWidget(
      maxLines: 10,
      minLines: 1,
      height: 30.0,
      decorationType: InputDecorationType.box,
      controller: controller.descriptionController,
      hintText: 'Nhập mô tả sản phẩm',
      hintColor: AppColors.grey3,
      obscureText: false,
      validator: (value) {
        if (value == null || value.trim().isEmpty || value.trim().length < 20) {
          return 'Mô tả sản phẩm phải có ít nhất 20 ký tự';
        }
        return null;
      },
    );
  }

  CustomTextFieldWidget priceClothes() {
    return CustomTextFieldWidget(
      height: 30.0,
      decorationType: InputDecorationType.underline,
      controller: controller.priceController,
      hintText: 'Nhập giá thuê theo ngày',
      hintColor: AppColors.grey3,
      keyboardType: TextInputType.number,
      obscureText: false,
      validator: (value) {
        if (value == null ||
            value.isEmpty ||
            double.tryParse(controller.priceController.text)! <= 10000) {
          return 'Giá phải lớn hơn 10000';
        }
        return null;
      },
    );
  }

  CustomTextFieldWidget clothesName() {
    return CustomTextFieldWidget(
      height: 30.0,
      decorationType: InputDecorationType.underline,
      controller: controller.nameItemController,
      hintColor: AppColors.grey3,
      hintText: 'Nhập tên sản phẩm',
      obscureText: false,
      validator: (value) {
        if (value == null || value.trim().isEmpty || value.trim().length < 10) {
          return "Tên sản phẩm phải có ít nhất 10 ký tự";
        }

        return null;
      },
    );
  }

  Column imagesBoxClothes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          return Wrap(
            spacing: 15,
            runSpacing: 15,
            children: controller.combinedPictures.map((image) {
              return Stack(
                children: [
                  // Kiểm tra nếu là URL thì dùng Image.network, nếu là File thì dùng Image.file
                  image is String
                      ? Image.network(
                          image, // Nếu là URL
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          image, // Nếu là File
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () => controller.removeImage(image),
                      child: Container(
                        color: Colors.red,
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          );
        }),
        GestureDetector(
          onTap: () {
            controller.pickImages();
          },
          child: Obx(
            () => Container(
              width: double.infinity,
              margin: controller.combinedPictures.isNotEmpty
                  ? const EdgeInsets.only(top: 10)
                  : null,
              height: controller.combinedPictures.isEmpty ? 180 : 40,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.gray.withOpacity(0.1),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(10),
                color: AppColors.gray.withOpacity(0.0),
              ),
              child: controller.combinedPictures.isEmpty
                  ? const Icon(
                      Icons.add_photo_alternate,
                      size: 120,
                    )
                  : const Icon(
                      Icons.add,
                      size: 30,
                      color: AppColors.primary,
                    ),
            ),
          ),
        ),
      ],
    );
  }


  // Function to show enum options with localized labels
  void _showEnumSelection<T>(
    BuildContext context,
    List<T> enumValues,
    String title,
    Function(T) onSelect,
    Map<T, String> localizedLabels,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: enumValues.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(localizedLabels[enumValues[index]] ??
                  enumValues[index].toString().split('.').last),
              onTap: () {
                onSelect(enumValues[index]);
              },
            );
          },
        );
      },
    );
  }

  final Map<Color, String> colorMapping = {
    Color.red: 'Đỏ',
    Color.blue: 'Xanh dương',
    Color.green: 'Xanh lá',
    Color.yellow: 'Vàng',
    Color.black: 'Đen',
    Color.white: 'Trắng',
    Color.pink: 'Hồng',
    Color.purple: 'Tím',
    Color.orange: 'Cam',
    Color.brown: 'Nâu',
    Color.gray: 'Xám',
    Color.beige: 'Be',
    Color.colorfull: 'Đa sắc',
  };

  final Map<Style, String> styleMapping = {
    Style.ao_dai: 'Áo dài',
    Style.tu_than: 'Tứ thân',
    Style.co_phuc: 'Cổ phục',
    Style.ao_ba_ba: 'Áo bà ba',
    Style.da_hoi: 'Dạ hội',
    Style.nang_tho: 'Nàng thơ',
    Style.hoc_duong: 'Học đường',
    Style.vintage: 'Vintage',
    Style.ca_tinh: 'Cá tính',
    Style.sexy: 'Sexy',
    Style.cong_so: 'Công sở',
    Style.dan_toc: 'Dân tộc',
    Style.do_doi: 'Đồ đôi',
    Style.hoa_trang: 'Hóa trang',
    Style.cac_nuoc: 'Các nước',
  };

  final Map<Gender, String> genderMapping = {
    Gender.male: 'Nam',
    Gender.female: 'Nữ',
    Gender.unisex: 'Không phân biệt',
    Gender.other: 'Khác',
  };

  final Map<SizeEnum, String> sizeMapping = {
    SizeEnum.S: 'S',
    SizeEnum.M: 'M',
    SizeEnum.L: 'L',
    SizeEnum.XL: 'XL',
  };
}
