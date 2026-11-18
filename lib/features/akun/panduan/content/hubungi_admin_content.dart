import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:epkk_nganjuk/features/akun/bantuan_screen.dart';
import 'package:epkk_nganjuk/features/akun/panduan/admin_contact_helper.dart';

class HubungiAdminContent extends StatelessWidget {
  const HubungiAdminContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.schedule_rounded,
              size: 16.sp,
              color: Colors.grey.shade600,
            ),
            SizedBox(width: 6.w),
            Expanded(
              child: Text(
                'Jam layanan: ${BantuanScreen.serviceHours}',
                style: TextStyle(
                  fontFamily: 'DMSans',
                  fontSize: 12.sp,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 14.h),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            icon: Icon(Icons.chat_outlined, size: 18.sp, color: Colors.white),
            label: Text(
              'Hubungi Admin lewat WhatsApp',
              style: TextStyle(
                fontFamily: 'DMSans',
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF25D366),
              elevation: 0,
              padding: EdgeInsets.symmetric(vertical: 14.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r),
              ),
            ),
            onPressed: () => AdminContactHelper.hubungiAdminWhatsApp(context),
          ),
        ),
      ],
    );
  }
}
