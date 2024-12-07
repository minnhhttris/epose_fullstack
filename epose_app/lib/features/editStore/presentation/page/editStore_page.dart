import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:image_picker/image_picker.dart';
import '../../../../core/configs/app_dimens.dart';
import '../../../../core/configs/app_colors.dart';
import '../controller/editStore_controller.dart';
import 'package:epose_app/core/ui/widgets/button/button_widget.dart';

class EditStorePage extends GetView<EditStoreController> {
  EditStorePage({super.key});

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cửa hàng của bạn"),
        centerTitle: true,
      ),
      body: Obx(
        () {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  _buildLogoUpload(),
                  const SizedBox(height: AppDimens.spacing5),
                  Text(
                    "Logo cửa hàng",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: AppDimens.spacing20),
                  // Store Name
                  _buildTextField(
                    label: "Tên cửa hàng",
                    initialValue: controller.nameStore.value,
                    onChanged: (value) => controller.nameStore.value = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập tên cửa hàng';
                      }
                      if (value.length < 3 || value.length > 100) {
                        return 'Tên cửa hàng phải có ít nhất 3 ký tự và tối đa 100 ký tự';
                      }
                      if (!RegExp(r'^[a-zA-Z0-9\s]+$').hasMatch(value)) {
                        return 'Tên cửa hàng không được chứa ký tự đặc biệt';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppDimens.spacing10),
                  // License
                  _buildTextField(
                    label: "Giấy phép kinh doanh",
                    initialValue: controller.license.value,
                    onChanged: (value) => controller.license.value = value,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Vui lòng nhập giấy phép kinh doanh';
                      }
                      if (!RegExp(r'^\d{10,15}$').hasMatch(value)) {
                        return 'Giấy phép kinh doanh phải là dãy số từ 10 đến 15 ký tự';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppDimens.spacing10),
                  // Tax Code
                  _buildTextField(
                    label: "Mã số thuế",
                    initialValue: controller.taxCode.value,
                    onChanged: (value) => controller.taxCode.value = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập mã số thuế';
                      }
                      if (!RegExp(r'^\d{10,15}$').hasMatch(value)) {
                        return 'Mã số thuế phải là dãy số từ 10 đến 15 ký tự';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppDimens.spacing20),
                  _buildFullAddressDisplay(),
                  const SizedBox(height: AppDimens.spacing30),
                  // Address Selection
                  _buildAddressDropdown(
                    label: "Tỉnh/Thành phố",
                    selectedValue: controller.selectedProvince,
                    items: controller.provinces,
                    onChanged: (value) {
                      controller.selectedProvince.value = value!;
                      controller.selectedDistrict.value = '';
                      controller.selectedWard.value = '';
                      controller.fetchDistricts(controller.getCodeFromName(
                          controller.provinces, value));
                    },
                  ),
                  _buildAddressDropdown(
                    label: "Quận/Huyện",
                    selectedValue: controller.selectedDistrict,
                    items: controller.districts,
                    onChanged: (value) {
                      controller.selectedDistrict.value = value!;
                      controller.selectedWard.value = '';
                      controller.fetchWards(controller.getCodeFromName(
                          controller.districts, value));
                    },
                  ),
                  _buildAddressDropdown(
                    label: "Xã/Phường",
                    selectedValue: controller.selectedWard,
                    items: controller.wards,
                    onChanged: (value) {
                      controller.selectedWard.value = value!;
                    },
                  ),
                  const SizedBox(height: AppDimens.spacing10),
                  // Address Details
                  TextField(
                    controller: controller.addressDetailController,
                    decoration: InputDecoration(
                      labelText: "Đường, số nhà, Ấp/Khu vực",
                      labelStyle: TextStyle(color: AppColors.primary),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.primary),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimens.spacing30),
                  // Submit Button
                  ButtonWidget(
                    ontap: () {
                      if (formKey.currentState?.validate() ?? false) {
                        controller.updateStore();
                      }
                    },
                    text: "Cập nhật thông tin cửa hàng",
                    height: 52,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Hiển thị địa chỉ đầy đủ
  Widget _buildFullAddressDisplay() {
    return Obx(() {
      String fullAddress =
          "${controller.addressDetailController.text} ${controller.selectedWard.value} ${controller.selectedDistrict.value} ${controller.selectedProvince.value}";
      return TextFormField(
        controller: TextEditingController(text: fullAddress),
        enabled: false,
        decoration: InputDecoration(
          labelText: "Địa chỉ cửa hàng",
          labelStyle: TextStyle(color: AppColors.primary),
          border: OutlineInputBorder(),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.grey),
          ),
        ),
      );
    });
  }

  // Hiển thị ô tròn cho logo hoặc ảnh đã chọn
  Widget _buildLogoUpload() {
    return Obx(() {
      return controller.logoFile.value == null
          ? GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 80,
                backgroundColor: AppColors.grey.withOpacity(0.1),
                child: Icon(Icons.image, color: AppColors.grey, size: 60),
              ),
            )
          : Stack(
              alignment: Alignment.center,
              children: [
                // Kiểm tra nếu logo là URL hay File
                CircleAvatar(
                  radius: 80,
                  backgroundImage: controller.logoFile.value is String
                      ? NetworkImage(controller.logoFile.value) // Nếu là URL
                      : FileImage(controller.logoFile.value), // Nếu là File
                ),
                Positioned(
                  top: -8,
                  right: -5,
                  child: Container(
                    height: 30,
                    width: 30,
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.grey.withOpacity(0.4),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.close, color: AppColors.white),
                      onPressed: _removeImage,
                      iconSize: 17,
                    ),
                  ),
                ),
              ],
            );
    });
  }


  // Xử lý chọn ảnh
  void _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      controller.logoFile.value = File(pickedFile.path);
    }
  }

  // Xử lý xóa ảnh
  void _removeImage() {
    controller.logoFile.value = null;
  }

  // Trường TextField cơ bản
  Widget _buildTextField({
    required String label,
    required ValueChanged<String> onChanged,
    required String? Function(String?) validator,
    required String initialValue,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: AppColors.primary),
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary),
        ),
      ),
      onChanged: onChanged,
      validator: validator,
      initialValue: initialValue,
    );
  }

  // Dropdown cho địa chỉ
  Widget _buildAddressDropdown({
    required String label,
    required RxString selectedValue,
    required List<Map<String, String>> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Obx(() {
        return DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: AppColors.primary),
            border: OutlineInputBorder(),
          ),
          value: selectedValue.isEmpty ? null : selectedValue.value,
          items: items
              .map((item) => DropdownMenuItem<String>(
                    value: item['name'],
                    child: Text(item['name'] ?? ''),
                  ))
              .toList(),
          onChanged: onChanged,
          validator: (value) => value == null ? 'Vui lòng chọn $label' : null,
        );
      }),
    );
  }
}
