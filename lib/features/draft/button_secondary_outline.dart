import 'package:epkk_nganjuk/common/colors.dart';
import 'package:epkk_nganjuk/common/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ButtonSecondaryOutline extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? outlineColor;
  final Color? textColor;
  final double? height;

  const ButtonSecondaryOutline({
    super.key,
    required this.text,
    this.onPressed,
    this.outlineColor,
    this.textColor,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = outlineColor ?? BrandColors.brandPrimary25;
    return SizedBox(
      width: double.infinity,
      height: height ?? 52.h,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: effectiveColor,
            width: 1.5.w,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.r),
          ),
          backgroundColor: Colors.white,
        ),
        child: TypographyStyles.button(
          text,
          color: textColor ?? effectiveColor,
        ),
      ),
    );
  }
}

