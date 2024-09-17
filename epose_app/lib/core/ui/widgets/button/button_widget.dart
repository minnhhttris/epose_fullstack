import 'package:epose_app/core/configs/app_colors.dart';
import 'package:epose_app/core/ui/widgets/text/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

// ignore: must_be_immutable
class ButtonWidget extends StatelessWidget {
  final VoidCallback ontap;
  final String text;
  final double? height;
  final double? width;
  late Color? backgroundColor;
  final Color textColor;
  final FontWeight? fontWeight;
  final bool? isBorder;
  late Color? borderColor;
  final SvgPicture? leadingIcon;
  final double? borderRadius;
  final Widget? child;
  ButtonWidget({
    Key? key,
    this.fontWeight = FontWeight.w600,
    required this.ontap,
    required this.text,
    this.height = 48.0,
    this.width = double.infinity,
    this.isBorder = false,
    this.borderColor,
    this.textColor = AppColors.white,
    this.backgroundColor = AppColors.primary,
    this.leadingIcon,
    this.child,
    this.borderRadius = 15.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
        width: width,
        height: height,
        decoration: BoxDecoration(
          border: isBorder == true
              ? Border.all(
                  width: 1,
                  color: borderColor!,
                )
              : null,
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius!),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (leadingIcon != null) leadingIcon!,
              if (leadingIcon != null) const SizedBox(width: 10.0),
              child ??
                  TextWidget(
                    text: text,
                    fontWeight: fontWeight,
                    textAlign: TextAlign.center,
                    color: textColor,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
