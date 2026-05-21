import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TypographyStyles extends StatelessWidget {
  static const String fontFamily = 'DMSans';

  final String text;
  final TextStyle style;
  final TextAlign textAlign;
  final TextOverflow overflow;
  final int? maxlines;
  final Color? color;

  TypographyStyles.h1(
    this.text, {
    super.key,
    this.textAlign = TextAlign.start,
    this.overflow = TextOverflow.ellipsis,
    this.maxlines,
    this.color,
  }) : style = TextStyle(
         fontFamily: fontFamily,
         fontSize: 26.sp,
         fontWeight: FontWeight.w600,
         color: color,
       );

  TypographyStyles.button(
    this.text, {
    super.key,
    this.textAlign = TextAlign.start,
    this.overflow = TextOverflow.ellipsis,
    this.maxlines,
    this.color,
  }) : style = TextStyle(
         fontFamily: fontFamily,
         fontSize: 16.sp,
         fontWeight: FontWeight.w600,
         height: 1.2,
         color: color,
       );

  TypographyStyles.bodySmallReguler(
    this.text, {
    super.key,
    this.textAlign = TextAlign.start,
    this.overflow = TextOverflow.ellipsis,
    this.maxlines,
    this.color,
  }) : style = TextStyle(
         fontFamily: fontFamily,
         fontSize: 18.sp,
         fontWeight: FontWeight.w400,
         color: color,
       );

  TypographyStyles.bodySmallMedium(
    this.text, {
    super.key,
    this.textAlign = TextAlign.start,
    this.overflow = TextOverflow.ellipsis,
    this.maxlines,
    this.color,
  }) : style = TextStyle(
         fontFamily: fontFamily,
         fontSize: 18.sp,
         fontWeight: FontWeight.w500,
         color: color,
       );

  TypographyStyles.bodySmallSemiBold(
    this.text, {
    super.key,
    this.textAlign = TextAlign.start,
    this.overflow = TextOverflow.ellipsis,
    this.maxlines,
    this.color,
  }) : style = TextStyle(
         fontFamily: fontFamily,
         fontSize: 18.sp,
         fontWeight: FontWeight.w600,
         color: color,
       );

  TypographyStyles.bodySmallBold(
    this.text, {
    super.key,
    this.textAlign = TextAlign.start,
    this.overflow = TextOverflow.ellipsis,
    this.maxlines,
    this.color,
  }) : style = TextStyle(
         fontFamily: fontFamily,
         fontSize: 18.sp,
         fontWeight: FontWeight.w700,
         color: color,
       );

  TypographyStyles.bodyCaptionReguler(
    this.text, {
    super.key,
    this.textAlign = TextAlign.start,
    this.overflow = TextOverflow.ellipsis,
    this.maxlines,
    this.color,
  }) : style = TextStyle(
         fontFamily: fontFamily,
         fontSize: 16.sp,
         fontWeight: FontWeight.w400,
         color: color,
       );

  TypographyStyles.bodyCaptionMedium(
    this.text, {
    super.key,
    this.textAlign = TextAlign.start,
    this.overflow = TextOverflow.ellipsis,
    this.maxlines,
    this.color,
  }) : style = TextStyle(
         fontFamily: fontFamily,
         fontSize: 16.sp,
         fontWeight: FontWeight.w500,
         color: color,
       );

  TypographyStyles.bodyCaptionSemiBold(
    this.text, {
    super.key,
    this.textAlign = TextAlign.start,
    this.overflow = TextOverflow.ellipsis,
    this.maxlines,
    this.color,
  }) : style = TextStyle(
         fontFamily: fontFamily,
         fontSize: 16.sp,
         fontWeight: FontWeight.w600,
         color: color,
       );

  TypographyStyles.bodyCaptionBold(
    this.text, {
    super.key,
    this.textAlign = TextAlign.start,
    this.overflow = TextOverflow.ellipsis,
    this.maxlines,
    this.color,
  }) : style = TextStyle(
         fontFamily: fontFamily,
         fontSize: 16.sp,
         fontWeight: FontWeight.w700,
         color: color,
       );

  TypographyStyles.bodyCaptionSmallReguler(
    this.text, {
    super.key,
    this.textAlign = TextAlign.start,
    this.overflow = TextOverflow.ellipsis,
    this.maxlines,
    this.color,
  }) : style = TextStyle(
         fontFamily: fontFamily,
         fontSize: 14.sp,
         fontWeight: FontWeight.w400,
         color: color,
       );

  TypographyStyles.bodyCaptionSmallMedium(
    this.text, {
    super.key,
    this.textAlign = TextAlign.start,
    this.overflow = TextOverflow.ellipsis,
    this.maxlines,
    this.color,
  }) : style = TextStyle(
         fontFamily: fontFamily,
         fontSize: 14.sp,
         fontWeight: FontWeight.w500,
         color: color,
       );

  TypographyStyles.bodyCaptionSmallSemiBold(
    this.text, {
    super.key,
    this.textAlign = TextAlign.start,
    this.overflow = TextOverflow.ellipsis,
    this.maxlines,
    this.color,
  }) : style = TextStyle(
         fontFamily: fontFamily,
         fontSize: 14.sp,
         fontWeight: FontWeight.w600,
         color: color,
       );

  TypographyStyles.bodyCaptionSmallBold(
    this.text, {
    super.key,
    this.textAlign = TextAlign.start,
    this.overflow = TextOverflow.ellipsis,
    this.maxlines,
    this.color,
  }) : style = TextStyle(
         fontFamily: fontFamily,
         fontSize: 14.sp,
         fontWeight: FontWeight.w700,
         color: color,
       );

  TypographyStyles.captionReguler(
    this.text, {
    super.key,
    this.textAlign = TextAlign.start,
    this.overflow = TextOverflow.ellipsis,
    this.maxlines,
    this.color,
  }) : style = TextStyle(
         fontFamily: fontFamily,
         fontSize: 12.sp,
         fontWeight: FontWeight.w400,
         color: color,
       );

  TypographyStyles.captionMedium(
    this.text, {
    super.key,
    this.textAlign = TextAlign.start,
    this.overflow = TextOverflow.ellipsis,
    this.maxlines,
    this.color,
  }) : style = TextStyle(
         fontFamily: fontFamily,
         fontSize: 12.sp,
         fontWeight: FontWeight.w500,
         color: color,
       );

  TypographyStyles.captionSemiBold(
    this.text, {
    super.key,
    this.textAlign = TextAlign.start,
    this.overflow = TextOverflow.ellipsis,
    this.maxlines,
    this.color,
  }) : style = TextStyle(
         fontFamily: fontFamily,
         fontSize: 12.sp,
         fontWeight: FontWeight.w600,
         color: color,
       );

  TypographyStyles.captionBold(
    this.text, {
    super.key,
    this.textAlign = TextAlign.start,
    this.overflow = TextOverflow.ellipsis,
    this.maxlines,
    this.color,
  }) : style = TextStyle(
         fontFamily: fontFamily,
         fontSize: 12.sp,
         fontWeight: FontWeight.w700,
         color: color,
       );

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxlines,
    );
  }
}
