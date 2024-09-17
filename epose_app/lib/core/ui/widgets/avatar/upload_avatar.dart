// import 'package:epose_app/core/configs/app_colors.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class getAvatar extends GetView<RestaurantController> {
//   getAvatar({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<RestaurantController>(
//       id: "updateAvatar",
//       builder: (id) {
//         return GestureDetector(
//           onTap: () => controller.selectImageAvatarGallery(),
//           child: Stack(
//             clipBehavior: Clip.none,
//             children: [
//               CircleAvatar(
//                 backgroundColor: AppColors.white,
//                 radius: 75,
//                 child: CircleAvatar(
//                   radius: 70,
//                   backgroundImage: controller.imgAvatar == null
//                       ? AssetImage('assets/images/avatar.jpg')
//                       : FileImage(controller.imgAvatar!) as ImageProvider,
//                 ),
//               ),
//               Positioned(
//                 bottom: 0,
//                 child: Container(
//                   clipBehavior: Clip.none,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     boxShadow: [
//                       BoxShadow(
//                         color: AppColors.black.withOpacity(.2),
//                         spreadRadius: 1,
//                         blurRadius: 2,
//                       )
//                     ],
//                     color: Color.fromARGB(157, 255, 255, 255),
//                   ),
//                   child: IconButton(
//                     iconSize: 30,
//                     icon: Icon(Icons.edit),
//                     onPressed: () {
//                       controller.selectImageAvatarGallery();
//                     },
//                   ),
//                 ),
//               )
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
