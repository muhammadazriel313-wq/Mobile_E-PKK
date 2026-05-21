import 'package:epkk_nganjuk/common/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InputForm extends StatefulWidget {
  final String hintText;
  final String svgIconPath;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  const InputForm({
    Key? key,
    required this.hintText,
    required this.svgIconPath,
    this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
  }) : super(key: key);

  @override
  State<InputForm> createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: TextColors.grey50,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: TextFormField(
        controller: widget.controller,
        validator: widget.validator,
        keyboardType: widget.keyboardType,
        inputFormatters: widget.inputFormatters ??
            <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(14),
            ],
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(
            fontFamily: 'DMSans',
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: TextColors.grey500,
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 14.h,
              horizontal: 13,
            ),
            child: SvgPicture.asset(
              widget.svgIconPath,
              color: TextColors.grey500,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(
              width: 1.w,
              color: TextColors.grey300,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(
              width: 1.w,
              color: TextColors.grey300,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(
              width: 1.w,
              color: TextColors.grey300,
            ),
          ),
        ),
      ),
    );
  }
}
