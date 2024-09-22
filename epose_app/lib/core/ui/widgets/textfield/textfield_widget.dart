import 'package:flutter/material.dart';

import '../../../configs/app_colors.dart';
import '../../../configs/app_dimens.dart';

enum InputDecorationType { box, underline }

class TextFieldWidget extends StatelessWidget {
  final double height;
  final Color? hintColor;
  final String? hintText;
  final bool? obscureText;
  final Color? backgroundColor;
  final Color? focusedColor;
  final double? focusedWidth;
  final Color? enableColor;
  final double? enableWidth;
  final IconButton? suffixIcon;
  final IconButton? prefixIcon;
  final Function? onChanged;
  final Function? onCompleted;
  final Color? textColor;
  final Function()? onTap;
  final FocusNode? focusNode;
  final String? labelText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final double? borderRadius;
  final InputDecorationType decorationType;

  const TextFieldWidget(
      {super.key,
      this.height = 55.0,
      this.onChanged,
      this.suffixIcon,
      this.prefixIcon,
      this.obscureText = false,
      this.backgroundColor,
      this.focusedWidth = 0,
      this.enableWidth = 0,
      this.controller,
      this.hintText,
      this.hintColor,
      this.focusedColor = AppColors.grey,
      this.enableColor = AppColors.grey,
      this.onTap,
      this.focusNode,
      this.labelText,
      this.textColor,
      this.keyboardType = TextInputType.text,
      this.borderRadius = 10.0,
      this.onCompleted,
      this.decorationType = InputDecorationType.box,
  });

   @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TextField(
        controller: controller,
        onChanged: (String valueOnChanged) {
          if (onChanged != null) onChanged!(valueOnChanged);
        },
        onSubmitted: (String value) {
          if (onCompleted != null) onCompleted!(value);
        },
        obscureText: obscureText!,
        focusNode: focusNode,
        enabled: true,
        cursorColor: AppColors.primary,
        keyboardType: keyboardType,
        decoration: _getInputDecoration(),
      ),
    );
  }

  InputDecoration _getInputDecoration() {
    switch (decorationType) {
      case InputDecorationType.underline:
        return InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(color: hintColor ?? AppColors.primary),
          hintText: hintText,
          hintStyle: TextStyle(
              fontSize: AppDimens.textSize16,
              color: hintColor ?? AppColors.primary),
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          enabledBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(width: enableWidth ?? 1, color: enableColor!),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(width: focusedWidth ?? 1, color: focusedColor!),
          ),
        );
      case InputDecorationType.box:
      default:
        return InputDecoration(
          fillColor: backgroundColor ?? AppColors.primary.withOpacity(0.1),
          filled: true,
          contentPadding: const EdgeInsets.only(
            left: 15.0,
          ),
          labelText: labelText,
          labelStyle: const TextStyle(
              color: AppColors.black, fontSize: AppDimens.textSize16),
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          hintText: hintText,
          hintStyle: TextStyle(
              fontSize: AppDimens.textSize16,
              color: hintColor ?? AppColors.primary),
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(width: enableWidth ?? 1, color: enableColor!),
            borderRadius: BorderRadius.circular(borderRadius!),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(width: focusedWidth ?? 1, color: focusedColor!),
            borderRadius: BorderRadius.circular(borderRadius!),
          ),
        );
    }
  }
}
