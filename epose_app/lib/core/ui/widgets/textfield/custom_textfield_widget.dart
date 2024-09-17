import 'package:epose_app/core/ui/widgets/text/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../configs/app_colors.dart';
import '../../../configs/app_dimens.dart';


// ignore: must_be_immutable
class CustomTextFieldWidget extends StatefulWidget {
  final double height;
  final double borderRadius;
  final Color? hintColor;
  final String? hintText;
  String? errorText;
  final bool obscureText;
  final Color? backgroundColor;
  final Color? focusedColor;
  final double? focusedWidth;
  final Color? enableColor;
  final double? enableWidth;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Function? onChanged;
  final Function? onCompleted;
  final Color? textColor;
  final Function()? onTap;
  final FocusNode? focusNode;
  final String? labelText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool isShowBorder;
  final bool enable;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  CustomTextFieldWidget({
    Key? key,
    this.height = 44.0,
    this.errorText = "Text is empty",
    this.borderRadius = 10.0,
    this.onChanged,
    this.suffixIcon,
    this.prefixIcon,
    required this.obscureText,
    this.backgroundColor,
    this.focusedWidth = 1,
    this.enableWidth = 1,
    this.controller,
    this.hintText,
    this.hintColor,
    this.focusedColor = AppColors.gray,
    this.enableColor = AppColors.gray,
    this.onTap,
    this.focusNode,
    this.labelText,
    this.textColor,
    this.onCompleted,
    this.keyboardType,
    this.isShowBorder = true,
    this.enable = true,
    this.maxLength,
    this.inputFormatters,
  }) : super(key: key);

  @override
  State<CustomTextFieldWidget> createState() => _CustomTextFieldWidgetState();
}

class _CustomTextFieldWidgetState extends State<CustomTextFieldWidget> {
  bool isError = false;
  bool isFormFieldValid = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          enabled: widget.enable,
          maxLength: widget.maxLength,
          keyboardType: widget.keyboardType,
          controller: widget.controller,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onChanged: (String valueOnChanged) {
            if (widget.onChanged != null) widget.onChanged!(valueOnChanged);
            // if (isFormFieldValid && valueOnChanged.isNotEmpty) {
            //   setState(() {
            //     isFormFieldValid = false;
            //   });
            // }
          },
          onFieldSubmitted: (String value) {
            if (widget.onCompleted != null) widget.onCompleted!(value);
          },
          inputFormatters: widget.inputFormatters,
          obscureText: widget.obscureText,
          focusNode: widget.focusNode,
          validator: (text) {
            if (text!.isEmpty) {
              // isFormFieldValid = false; // Form field không hợp lệ
              return widget.errorText;
            } else {
              // isFormFieldValid = true; // Form field hợp lệ
              return null;
            }
          },
          style: TextStyle(
              fontSize: AppDimens.textSize16,
              color: widget.textColor ?? AppColors.black),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(
                  width: widget.enableWidth!, color: widget.enableColor!),
              borderRadius: BorderRadius.circular(10.0),
            ),
            contentPadding: const EdgeInsets.only(left: 15.0),
            labelText: widget.labelText,
            labelStyle: const TextStyle(
                color: AppColors.primary, fontSize: AppDimens.textSize16),
            suffixIcon: widget.suffixIcon,
            prefixIcon: widget.prefixIcon,
            filled: widget.backgroundColor == null ? false : true,
            fillColor: widget.backgroundColor,
            hintText: widget.hintText,
            hintStyle: TextStyle(
                fontSize: AppDimens.textSize16, color: widget.hintColor),
            enabledBorder: widget.isShowBorder
                ? OutlineInputBorder(
                    borderSide: BorderSide(
                        width: widget.enableWidth!, color: widget.enableColor!),
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                  )
                : null,
            focusedBorder: widget.isShowBorder
                ? OutlineInputBorder(
                    borderSide: BorderSide(
                        width: widget.focusedWidth!,
                        color: widget.focusedColor!),
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                  )
                : null,
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  width: widget.focusedWidth!, color: widget.focusedColor!),
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  width: widget.focusedWidth!, color: widget.focusedColor!),
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
          ),
        ),
        isError
            ? TextWidget(
                text: widget.errorText ?? "",
                size: AppDimens.textSize14,
                color: AppColors.error,
              )
            : const SizedBox.shrink()
      ],
    );
  }
}
