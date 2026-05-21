import 'package:epkk_nganjuk/common/colors.dart';
import 'package:epkk_nganjuk/common/typography.dart';
import 'package:epkk_nganjuk/features/auth/component/icon_button_back.dart';
import 'package:flutter/material.dart';

class CustomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;
  final VoidCallback? onTab2;
  final Color? backgroundColor;
  final double? elevation;
  final bool showBottomBorder;
  final int? currentStep;
  final int? totalSteps;
  final bool centerTitle;

  const CustomeAppBar({
    Key? key,
    required this.title,
    this.onBack,
    this.onTab2,
    this.backgroundColor = Colors.transparent,
    this.elevation,
    this.showBottomBorder = false,
    this.centerTitle = true,
    this.currentStep,
    this.totalSteps,
  }) : super(key: key);

  @override
  Size get preferredSize {
    double height = kToolbarHeight;

    if (currentStep != null && totalSteps != null) {
      height += 20; // progress bar
    } else if (showBottomBorder) {
      height += 15; // garis tipis
    }

    return Size.fromHeight(height);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: elevation ?? 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      centerTitle: centerTitle,

      titleSpacing: 0,

      /// 🔙 BACK BUTTON
      leading: onBack != null
          ? Center(
              child: IconButtonBack(onTab: onBack!),
            )
          : null,

      ///  TITLE
      title: Padding(
        padding: const EdgeInsets.only(top: 4, left: 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment:
              centerTitle ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          children: [
            TypographyStyles.bodySmallBold(
              title,
              textAlign:
                  centerTitle ? TextAlign.center : TextAlign.left,
              color: TextColors.grey700,
            ),
            if (currentStep != null && totalSteps != null)
              TypographyStyles.captionReguler(
                'Langkah $currentStep dari $totalSteps',
                textAlign:
                    centerTitle ? TextAlign.center : TextAlign.left,
                color: TextColors.grey500,
              ),
          ],
        ),
      ),

      ///  BOTTOM (SMART SWITCH)
      bottom: currentStep != null && totalSteps != null
          ? PreferredSize(
              preferredSize: const Size.fromHeight(20),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: List.generate(totalSteps!, (index) {
                    bool isActive = index < currentStep!;
                    return Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        height: 6,
                        decoration: BoxDecoration(
                          color: isActive
                              ? const Color(0xFF2AA4D6) // biru soft
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            )
          : showBottomBorder
              ? PreferredSize(
                  preferredSize: const Size.fromHeight(6),
                  child: Container(
                    height: 1,
                    color: Colors.grey.shade300,
                  ),
                )
              : null,

      /// 🔧 ACTION
      actions: onTab2 != null
          ? [
              IconButton(
                onPressed: onTab2,
                icon: Icon(
                  Icons.filter_alt_rounded,
                  size: 24,
                  color: TextColors.grey700,
                ),
              ),
            ]
          : null,
    );
  }
}

class AppBarPrimary extends CustomeAppBar {
  AppBarPrimary({
    required String title,
    VoidCallback? onBack,
    VoidCallback? onTab2,
    Color? backgroundColor,
    double? elevation,
    int? currentStep,
    int? totalSteps,
  }) : super(
          title: title,
          onBack: onBack,
          onTab2: onTab2,
          backgroundColor: backgroundColor,
          elevation: elevation,
          currentStep: currentStep,
          totalSteps: totalSteps,
          showBottomBorder: false,
          centerTitle: true,
        );
}

class AppBarSecondary extends CustomeAppBar {
  AppBarSecondary({
    required String title,
    VoidCallback? onBack,
    VoidCallback? onTab2,
    Color? backgroundColor,
    double? elevation,
    int? currentStep,
    int? totalSteps,
  }) : super(
          title: title,
          onBack: onBack,
          onTab2: onTab2,
          backgroundColor: backgroundColor,
          elevation: 0,
          currentStep: currentStep,
          totalSteps: totalSteps,
          showBottomBorder: true,
          centerTitle: true,
        );
}