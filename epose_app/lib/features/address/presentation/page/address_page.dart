import 'package:epose_app/core/ui/widgets/button/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/configs/app_colors.dart';
import '../../../../core/configs/app_dimens.dart';
import '../controller/address_controller.dart';
import '../widgets/address_appbar.dart';

class AddressPage extends GetView<AddressController> {
  const AddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AddressAppbar(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }
        return addressBody(context);
      }),
    );
  }

  Widget addressBody(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimens.spacing20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: AppDimens.spacing10),
          Text("Địa chỉ:",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
          )),
          userAddressBox(),
          const SizedBox(height: AppDimens.spacing20),
          addressDropdown(
            label: "Tỉnh/Thành phố",
            selectedValue: controller.selectedProvince,
            items: controller.provinces,
            onChanged: (value) {
              controller.selectedProvince.value = value!;
              controller.selectedDistrict.value = '';
              controller.selectedWard.value = '';
              controller.fetchDistricts(
                  controller.getCodeFromName(controller.provinces, value));
            },
          ),
          const SizedBox(height: AppDimens.spacing10),
          addressDropdown(
            label: "Quận/Huyện",
            selectedValue: controller.selectedDistrict,
            items: controller.districts,
            onChanged: (value) {
              controller.selectedDistrict.value = value!;
              controller.selectedWard.value = '';
              controller.fetchWards(
                  controller.getCodeFromName(controller.districts, value));
            },
          ),
          const SizedBox(height: AppDimens.spacing10),
          addressDropdown(
            label: "Xã/Phường",
            selectedValue: controller.selectedWard,
            items: controller.wards,
            onChanged: (value) {
              controller.selectedWard.value = value!;
            },
          ),
          const SizedBox(height: AppDimens.spacing10),
          TextField(
            controller: controller.addressDetailController,
            decoration: InputDecoration(
              labelText: "Đường, số nhà, Ấp/Khu vực",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: AppDimens.spacing30),
          ButtonWidget(
            ontap: controller.updateInformation,
            text: 'Lưu thông tin',
          ),
        ],
      ),
    );
  }

  Widget userAddressBox() {
    return Obx(() => Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(AppDimens.spacing10),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primary),
            borderRadius: BorderRadius.circular(AppDimens.spacing10),
          ),
          child: Text(
            "${controller.userAddress.value}",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ));
  }

  Widget addressDropdown({
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
