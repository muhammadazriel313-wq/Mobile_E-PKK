import 'package:epkk_nganjuk/common/colors.dart';
import 'package:epkk_nganjuk/common/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';



class HeaderText extends StatelessWidget {
  final String firstText;

  final String bodyText;

  const HeaderText({
    super.key,
    required this.firstText,
    required this.bodyText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TypographyStyles.h1(
          firstText,
          color: TextColors.grey700,
          maxlines: 2,
        ),
        SizedBox(
          height: 20.h,
        ),
        TypographyStyles.bodyCaptionReguler(
          bodyText,
          maxlines: 10,
          color: TextColors.grey600,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
