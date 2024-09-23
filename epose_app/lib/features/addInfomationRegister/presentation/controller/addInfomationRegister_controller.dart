import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddInfomationRegisterController extends GetxController {

  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final genderController = TextEditingController();

  var selectedGender = 'Nam'.obs; 


}
