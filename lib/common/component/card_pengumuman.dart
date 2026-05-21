import 'package:epkk_nganjuk/common/colors.dart';
import 'package:epkk_nganjuk/common/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class CardPengumuman extends StatelessWidget {
  final String title;
  final String subTitle;
  final String dateText;
  final VoidCallback onTab;

  const CardPengumuman({
    super.key,
    required this.title,
    required this.subTitle,
    required this.dateText,
    required this.onTab,
  });

  @override
  Widget build(BuildContext context) {
    return ZoomTapAnimation(
      onTap: onTab,

      child: Container(
        width: double.infinity,

        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),

          borderRadius: BorderRadius.circular(18.r),

          border: Border.all(color: const Color(0xFFE7EDF3), width: 1.w),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),

        child: Padding(
          padding: EdgeInsets.all(14.w),

          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              /// ICON
              Container(
                padding: EdgeInsets.all(12.w),

                decoration: BoxDecoration(
                  color: BrandColors.brandPrimary500.withOpacity(0.10),

                  borderRadius: BorderRadius.circular(14.r),
                ),

                child: Icon(
                  Icons.campaign_rounded,

                  size: 24.sp,

                  color: BrandColors.brandPrimary500,
                ),
              ),

              SizedBox(width: 14.w),

              /// CONTENT
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    /// TITLE
                    Text(
                      title,

                      maxLines: 2,

                      overflow: TextOverflow.ellipsis,

                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: TextColors.grey700,
                        height: 1.4,
                      ),
                    ),

                    SizedBox(height: 8.h),

                    /// LOKASI
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Icon(
                          Icons.location_on_outlined,

                          size: 16.sp,

                          color: TextColors.grey500,
                        ),

                        SizedBox(width: 4.w),

                        Expanded(
                          child: Text(
                            subTitle,

                            maxLines: 2,

                            overflow: TextOverflow.ellipsis,

                            style: TextStyle(
                              fontSize: 12.sp,
                              color: TextColors.grey600,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 10.h),

                    /// DATE
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 5.h,
                      ),

                      decoration: BoxDecoration(
                        color: BrandColors.brandPrimary500.withOpacity(0.08),

                        borderRadius: BorderRadius.circular(100.r),
                      ),

                      child: Text(
                        dateText,

                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: BrandColors.brandPrimary500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
