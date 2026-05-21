/// =======================================================
/// FILE : components/jenis_laporan_dropdown.dart
/// =======================================================

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class JenisLaporanDropdown extends StatelessWidget {
  final String? value;

  final Function(String?) onChanged;

  const JenisLaporanDropdown({
    super.key,

    required this.value,

    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> jenisLaporanList = [
      'Rekap Desa Per Bulan',

      'Rekap Desa Per Tahun',

      'Rekap Posyandu',

      'Kegiatan Pokja 4',
    ];

    return DropdownButtonFormField<String>(
      value: value,

      isExpanded: true,

      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,

        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),

          borderSide: BorderSide(color: Colors.grey.shade300),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),

          borderSide: BorderSide(color: Colors.grey.shade300),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),

          borderSide: const BorderSide(color: Color(0xff0EA5E9), width: 1.5),
        ),
      ),

      hint: Text(
        'Pilih Jenis Laporan',

        style: TextStyle(fontSize: 14.sp, color: Colors.grey),
      ),

      icon: const Icon(Icons.keyboard_arrow_down_rounded),

      style: TextStyle(
        color: Colors.black87,
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
      ),

      items: jenisLaporanList.map((item) {
        return DropdownMenuItem<String>(value: item, child: Text(item));
      }).toList(),

      onChanged: onChanged,
    );
  }
}
