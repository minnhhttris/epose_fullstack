// import 'package:epose_app/core/configs/app_colors.dart';
// import 'package:epose_app/core/configs/app_dimens.dart';
// import 'package:epose_app/core/configs/app_images_string.dart';
// import 'package:epose_app/core/ui/widgets/avatar/avatar.dart';
// import 'package:epose_app/core/ui/widgets/icons/rating.dart';
// import 'package:epose_app/core/ui/widgets/text/text_widget.dart';
// import 'package:expandable_text/expandable_text.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';

// class CommentsCard extends StatelessWidget {
//   final String idComment;
//   final int favorite;
//   final String comment;
//   final String authorAvatar;
//   final String authorName;
//   final double? star;
//   final String idPost;
//   final String createdAt;
//   final VoidCallback toggleActive;
//   final bool active;
//   final CommentModel commentModel;

//   const CommentsCard({
//     super.key,
//     this.idComment = "",
//     this.favorite = 0,
//     this.comment = "",
//     this.authorAvatar = AppImagesString.iUserDefault,
//     this.authorName = "User Name",
//     this.star = 0.0,
//     this.idPost = "",
//     this.createdAt = "",
//     required this.toggleActive,
//     required this.active,
//     required this.commentModel,
//   });
//   String calculateTime(String? createdAt) {
//     if (createdAt == null || createdAt.isEmpty) {
//       return "";
//     }

//     try {
//       DateTime postCreationTime =
//           DateFormat("yyyy-MM-dd HH:mm:ss.SSSSSS").parse(createdAt);
//       DateTime currentTime = DateTime.now();
//       Duration difference = currentTime.difference(postCreationTime);
//       if (difference.isNegative) {
//         return "Vừa xong";
//       }

//       return _formatDuration(difference);
//     } catch (e) {
//       print("Error parsing createdAt: $e");
//       return "";
//     }
//   }

//   String _truncateName(String name) {
//     const maxLength = 20;
//     return name.length > maxLength
//         ? '${name.substring(0, maxLength)}...'
//         : name;
//   }

//   String _formatDuration(Duration duration) {
//     if (duration.inDays > 0) {
//       return '${duration.inDays}d ago';
//     } else if (duration.inHours > 0) {
//       return '${duration.inHours}h ago';
//     } else if (duration.inMinutes > 0) {
//       return '${duration.inMinutes}m ago';
//     } else {
//       return '${duration.inSeconds}s ago';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     double avatarWithLeft = 15.0;
//     double avatarWithTop = 15.0;
//     double spaceSideLeft = 55.0;
//     double minHeightCommentCard = Get.height * 0.14;
//     bool hiddenStar = star == 0.0;
//     String calculatedTime = calculateTime(commentModel.createdAt);

//     return SingleChildScrollView(
//       child: Stack(
//         children: [
//           Container(
//             constraints: BoxConstraints(minHeight: minHeightCommentCard),
//             margin: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               color: AppColors.white,
//               boxShadow: [
//                 BoxShadow(
//                   color: AppColors.black.withOpacity(.09),
//                   spreadRadius: 1,
//                   blurRadius: 1,
//                 ),
//               ],
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(30),
//                 bottomRight: Radius.circular(10),
//                 topRight: Radius.circular(10),
//               ),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 if (!hiddenStar)
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Container(
//                         padding: EdgeInsets.only(
//                             top: 5, bottom: 5, left: avatarWithLeft + 20),
//                         width: (Get.width * 0.45) + avatarWithLeft,
//                         decoration: const BoxDecoration(
//                           color: AppColors.gray2,
//                           borderRadius: BorderRadius.only(
//                             bottomRight: Radius.circular(50),
//                             topLeft: Radius.circular(50),
//                           ),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [...Rating.RenderStar(star: star!)],
//                         ),
//                       ),
//                       Container(
//                         margin: const EdgeInsets.only(right: 20),
//                         child: Column(
//                           children: [
//                             InkWell(
//                               onTap: toggleActive,
//                               child: Icon(
//                                 active ? Icons.favorite : Icons.favorite_border,
//                                 size: AppDimens.textSize18,
//                                 color: active ? AppColors.red : null,
//                               ),
//                             ),
//                             TextWidget(
//                               text: favorite.toString(),
//                               size: AppDimens.textSize15,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 Row(
//                   children: [
//                     SizedBox(width: spaceSideLeft),
//                     Expanded(
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 15, vertical: 10),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Expanded(
//                                   child: Text(
//                                     _truncateName(
//                                         commentModel.author.displayName ??
//                                             commentModel.author.email),
//                                     style: TextStyle(
//                                       fontSize: AppDimens.textSize16,
//                                       fontWeight: FontWeight.w500,
//                                       color: AppColors.black.withOpacity(.7),
//                                     ),
//                                   ),
//                                 ),
//                                 if (hiddenStar)
//                                   Container(
//                                     margin: const EdgeInsets.only(right: 20),
//                                     child: Column(
//                                       children: [
//                                         InkWell(
//                                           onTap: toggleActive,
//                                           child: Icon(
//                                             !active
//                                                 ? Icons.favorite_outline
//                                                 : Icons.favorite_outlined,
//                                             size: AppDimens.textSize16,
//                                             color:
//                                                 active ? AppColors.red : null,
//                                           ),
//                                         ),
//                                         TextWidget(
//                                           text: favorite.toString(),
//                                           size: AppDimens.textSize15,
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                               ],
//                             ),
//                             const SizedBox(height: 5),
//                             ExpandableText(
//                               comment,
//                               style: TextStyle(
//                                 fontSize: AppDimens.textSize14,
//                                 color: AppColors.black.withOpacity(.7),
//                               ),
//                               maxLines: 2,
//                               expandText: 'Xem thêm',
//                               collapseText: 'Thu gọn',
//                               linkColor: AppColors.primary,
//                             ),
//                             const SizedBox(height: 10),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           Positioned(
//             left: avatarWithLeft,
//             top: avatarWithTop,
//             child: Column(children: [
//               Avatar(
//                 radius: 50,
//                 authorImg: commentModel.author.avatarUrl ??
//                     AppImagesString.iUserDefault,
//               ),
//               const SizedBox(height: 15),
//               TextWidget(
//                 text: '$calculatedTime',
//                 size: AppDimens.textSize10,
//                 color: AppColors.primary.withOpacity(.5),
//               ),
//             ]),
//           ),
//         ],
//       ),
//     );
//   }
// }

