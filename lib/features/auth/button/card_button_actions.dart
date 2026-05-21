import 'package:epkk_nganjuk/common/colors.dart';
import 'package:epkk_nganjuk/common/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CardButtonActions extends StatefulWidget {
  final String titleText;
  final String subTitle;
  final VoidCallback onTab;
  final String imageAssets;
  final String? svgIcon;
  final Color backroundColor;
  final Color strokeColor;

  const CardButtonActions({
    super.key,
    required this.titleText,
    required this.subTitle,
    required this.onTab,
    required this.imageAssets,
    this.svgIcon,
    required this.backroundColor,
    required this.strokeColor,
  });

  @override
  State<CardButtonActions> createState() => _CardButtonActionsState();
}

class _CardButtonActionsState extends State<CardButtonActions> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => isPressed = true),
      onTapUp: (_) => setState(() => isPressed = false),
      onTapCancel: () => setState(() => isPressed = false),
      onTap: widget.onTab,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        transform: isPressed
            ? Matrix4.translationValues(0, 2, 0)
            : Matrix4.identity(),
        decoration: BoxDecoration(
          color: widget.backroundColor,
          border: Border.all(
            color: widget.strokeColor,
            width: 1.w,
          ),
          borderRadius: BorderRadius.circular(10.r),

          //  INI INTINYA (shadow ikut warna card)
          boxShadow: [
            BoxShadow(
              color: isPressed
                  ? widget.backroundColor.withOpacity(0.5)
                  : Colors.black.withOpacity(0.08),
              blurRadius: isPressed ? 20 : 6,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Image.asset(
              widget.imageAssets,
              width: 43.w,
              height: 43.w,
            ),
            title: TypographyStyles.bodyCaptionSemiBold(
              widget.titleText,
              color: TextColors.grey700,
              overflow: TextOverflow.ellipsis,
              maxlines: 1,
            ),
            subtitle: TypographyStyles.bodyCaptionSmallReguler(
              widget.subTitle,
              color: TextColors.grey600,
              overflow: TextOverflow.ellipsis,
              maxlines: 1,
            ),
            trailing: widget.svgIcon != null
                ? SvgPicture.asset(
                    widget.svgIcon!,
                    width: 24.w,
                    height: 24.h,
                    color: TextColors.grey700,
                  )
                : SvgPicture.asset(
                    'assets/icons/ic_arrow_right.svg',
                    width: 24.w,
                    height: 24.h,
                    color: TextColors.grey700,
                  ),
          ),
        ),
      ),
    );
  }
}