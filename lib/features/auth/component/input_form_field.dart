import 'package:epkk_nganjuk/common/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InputFormField extends StatelessWidget {
  final String hintText;
  final String label;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final int minLines;
  final int maxLines;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool readOnly;
  final Function(String)? onChanged;
  final TextInputAction? textInputAction;

  // TAMBAHAN
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  const InputFormField({
    Key? key,
    required this.hintText,
    required this.label,
    this.suffixIcon,
    this.prefixIcon,
    this.minLines = 1,
    this.maxLines = 1,
    this.controller,
    this.validator,
    this.readOnly = false,
    this.onChanged,
    this.textInputAction,

    // TAMBAHAN
    this.keyboardType,
    this.inputFormatters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: TextFormField(
        controller: controller,
        validator: validator,
        minLines: minLines,
        maxLines: maxLines,
        readOnly: readOnly,

        // TAMBAHAN
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        onChanged: onChanged,

        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            fontSize: 18.sp,
            fontFamily: 'DMSans',
            color: TextColors.grey500,
            fontWeight: FontWeight.w400,
          ),
          alignLabelWithHint: true,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: hintText,
          hintStyle: TextStyle(
            color: TextColors.grey600,
            fontWeight: FontWeight.w400,
            fontSize: 16.sp,
            fontFamily: 'DMSans',
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6.r),
            borderSide: BorderSide(
              width: 1.w,
              color: TextColors.grey200,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6.r),
            borderSide: BorderSide(
              width: 1.w,
              color: TextColors.grey200,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6.r),
            borderSide: BorderSide(
              width: 1.w,
              color: TextColors.grey200,
            ),
          ),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}