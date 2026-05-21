import 'package:epkk_nganjuk/common/colors.dart';
import 'package:epkk_nganjuk/common/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ButtonFill extends StatelessWidget {
  final String text;
  final Color textColor;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double fontSize;

  const ButtonFill({
    Key? key,
    required this.text,
    required this.textColor,
    this.fontSize = 16,
    this.onPressed,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52.h, // 🔥 tinggi fix biar konsisten
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 2, // 🔥 shadow halus
          backgroundColor: isLoading
              ? TextColors.grey400
              : BrandColors.brandPrimary25,
          disabledBackgroundColor: TextColors.grey400,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.r),
          ),
        ),
        child: isLoading
            ? _rowLoading()
            : TypographyStyles.button(
                text,
                color: textColor,
              ),
      ),
    );
  }

  Widget _rowLoading() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TypographyStyles.button(
          'Loading...',
          color: Colors.white,
        ),
        SizedBox(width: 10.w),
        SizedBox(
          width: 18.w,
          height: 18.h,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
        ),
      ],
    );
  }
}