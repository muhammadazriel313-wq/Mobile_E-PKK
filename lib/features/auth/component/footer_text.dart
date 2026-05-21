import 'package:epkk_nganjuk/common/colors.dart';
import 'package:epkk_nganjuk/common/typography.dart';
import 'package:flutter/material.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class FooterText extends StatelessWidget {
  final String firstText;
  final String secondText;
  final VoidCallback onTab;

  const FooterText({
    super.key,
    required this.firstText,
    required this.secondText,
    required this.onTab,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TypographyStyles.bodyCaptionReguler(
          firstText,
          color: TextColors.grey500,
        ),
        SizedBox(
          width: 6,
        ),
        InkWell(
          onTap: onTab,
          child: ZoomTapAnimation(
            child: TypographyStyles.bodyCaptionSemiBold(
              secondText,
              color: BrandColors.brandPrimary500,
            ),
          ),
        )
      ],
    );
  }
}
