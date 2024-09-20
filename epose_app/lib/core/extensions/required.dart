

// // ignore: must_be_immutable
// import 'package:epose_app/core/configs/app_colors.dart';
// import 'package:epose_app/core/configs/app_dimens.dart';
// import 'package:epose_app/core/configs/app_images_string.dart';
// import 'package:epose_app/core/extensions/helper.dart';
// import 'package:epose_app/core/ui/widgets/button/button_widget.dart';
// import 'package:epose_app/core/ui/widgets/text/text_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class RequiredLocation extends StatelessWidget {
//   const RequiredLocation({
//     super.key,
//     required this.controller,
//   });

//   // ignore: prefer_typing_uninitialized_variables
//   final controller;

//   @override
//   Widget build(BuildContext context) {
//     return Visibility(
//       visible: true,
//       child: Container(
//         decoration: BoxDecoration(
//           color: AppColors.white.withOpacity(.4),
//         ),
//         child: Center(
//           child: Container(
//             decoration: BoxDecoration(
//                 color: AppColors.white,
//                 boxShadow: CustomShadow.cardShadow,
//                 borderRadius: BorderRadius.circular(AppDimens.radius2)),
//             padding: const EdgeInsets.all(10),
//             constraints: BoxConstraints(
//                 maxHeight: Get.width * 0.7, maxWidth: Get.width * 0.6),
//             child: Column(
//               children: [
//                 Image.asset(AppImagesString.iFindLocation),
//                 const Padding(
//                   padding: EdgeInsets.symmetric(vertical: 10),
//                   child: TextWidget(
//                     text: "Turn on location for the best app experience!",
//                     size: AppDimens.textSize14,
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//                 const Spacer(),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     SizedBox(
//                       width: Get.width * 0.25,
//                       child: ButtonWidget(
//                         ontap: () async {
//                           bool? result = await showDialog(
//                             context: context,
//                             builder: (BuildContext context) {
//                               return AlertDialog(
//                                 title: const Text("Confirmation"),
//                                 content: const Text(
//                                     "Do you want to proceed without enabling location?"),
//                                 actions: [
//                                   TextButton(
//                                     onPressed: () {
//                                       Navigator.of(context).pop(false);
//                                     },
//                                     child: const Text("No"),
//                                   ),
//                                   TextButton(
//                                     onPressed: () async {
//                                       Navigator.of(context).pop(false);
//                                       await controller
//                                           .CloseRequiredLocationBox();
//                                     },
//                                     child: const Text("Okay"),
//                                   ),
//                                 ],
//                               );
//                             },
//                           );

//                           if (result == true) {
//                             Navigator.of(context).pop();
//                           }
//                         },
//                         text: "Cancel",
//                       ),
//                     ),
//                     SizedBox(
//                       width: Get.width * 0.25,
//                       child: ButtonWidget(
//                         ontap: () async {
//                           await controller.checkLocationService();
//                           try {
//                             if (controller.isLocationServiceEnabled.value ==
//                                 true) {
//                               await controller.initializeLocation();
//                             } else {
//                               Fluttertoast.showToast(
//                                   msg: "Please turn on location in device!");
//                             }
//                           } catch (e) {
//                             Fluttertoast.showToast(
//                                 msg: "Please turn on location in device!");
//                           }
//                         },
//                         text: "Get",
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
