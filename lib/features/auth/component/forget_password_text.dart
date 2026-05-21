import 'package:epkk_nganjuk/common/colors.dart';
import 'package:epkk_nganjuk/common/typography.dart';
import 'package:flutter/material.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';


class ForgetPasswordText extends StatelessWidget {
  final VoidCallback onTab;

  const ForgetPasswordText({super.key, required this.onTab});

  @override
  Widget build(BuildContext context) {
    return ZoomTapAnimation(
      onTap: onTab,
      child: Align(
        alignment: Alignment.centerRight,
        child: TypographyStyles.bodyCaptionSemiBold(
          'Lupa password?',
          color: TextColors.grey700,
        ),
      ),
    );
  }
}
