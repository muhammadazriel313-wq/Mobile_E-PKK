import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class CardButtonRow extends StatelessWidget {
  final IconData leadingIcon;
  final String titleText;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color strokeColor;
  final Color iconColor;
  final TextStyle? textStyle;

  const CardButtonRow({
    super.key,
    required this.leadingIcon,
    required this.titleText,
    required this.onTap,
    this.backgroundColor = Colors.white,
    this.strokeColor = Colors.grey,
    this.iconColor = Colors.black,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return ZoomTapAnimation(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: strokeColor, width: 1.w),
          borderRadius: BorderRadius.circular(10.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        child: Row(
          children: [
            Icon(leadingIcon, color: iconColor, size: 24.w),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                titleText,
                style: textStyle ??
                    TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16.w, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
