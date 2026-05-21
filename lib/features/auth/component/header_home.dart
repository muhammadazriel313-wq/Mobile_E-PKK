import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class HeaderHome extends StatelessWidget {
  final String textUser;

  HeaderHome({
    super.key,
    required this.textUser,
  });

  @override
  Widget build(BuildContext context) {
    String greetingMessage() {
      final hour = DateTime.now().hour;

      if (hour >= 5 && hour < 11) {
        return 'Selamat pagi';
      } else if (hour >= 11 && hour < 15) {
        return 'Selamat siang';
      } else if (hour >= 15 && hour < 18) {
        return 'Selamat sore';
      } else {
        return 'Selamat malam';
      }
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        left: 18.w,
        right: 18.w,
        top: 28.h,
        bottom: 14.h,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// LOGO
          Image.asset(
            'assets/images/logo_pkk.png',
            width: 58.w,
            height: 58.w,
            fit: BoxFit.contain,
          ),

          SizedBox(width: 5.w),

          /// TEXT
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${greetingMessage()}, ',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF374151),
                          fontFamily: 'DMSans',
                          height: 1.1,
                        ),
                      ),

                      TextSpan(
                        text: textUser,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF3F8FC1),
                          fontFamily: 'DMSans',
                          height: 1.1,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 2.h),

                Text(
                  DateFormat(
                    'EEEE, dd-MM-yyyy',
                    'id_ID',
                  ).format(DateTime.now()),
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: const Color(0xFF6B7280),
                    fontFamily: 'DMSans',
                    fontWeight: FontWeight.w500,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}