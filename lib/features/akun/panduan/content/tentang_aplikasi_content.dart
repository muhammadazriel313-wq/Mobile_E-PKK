import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:epkk_nganjuk/features/akun/bantuan_screen.dart';

class TentangAplikasiContent extends StatelessWidget {
  const TentangAplikasiContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildBarisInfo(
          label: 'Nama Aplikasi',
          nilai: 'E-PKK Kabupaten Nganjuk',
        ),
        SizedBox(height: 8.h),
        _buildBarisInfo(label: 'Versi', nilai: BantuanScreen.appVersion),
        SizedBox(height: 8.h),
        _buildBarisInfo(
          label: 'Pengembang',
          nilai: BantuanScreen.developerName,
        ),
      ],
    );
  }

  Widget _buildBarisInfo({required String label, required String nilai}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'DMSans',
            fontSize: 13.sp,
            color: Colors.grey.shade600,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            nilai,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontFamily: 'DMSans',
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
