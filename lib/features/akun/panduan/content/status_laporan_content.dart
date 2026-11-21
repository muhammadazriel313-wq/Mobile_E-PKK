import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatusLaporanContent extends StatelessWidget {
  const StatusLaporanContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildItemStatus(
          label: 'Sedang Diproses',
          latar: Colors.orange.shade50,
          warnaTeks: Colors.orange.shade800,
          uraian:
              'Laporan baru terkirim dan sedang menunggu pemeriksaan oleh petugas pemeriksa.',
        ),
        _buildItemStatus(
          label: 'Disetujui Kecamatan',
          latar: Colors.green.shade50,
          warnaTeks: Colors.green.shade800,
          uraian:
              'Laporan desa telah diperiksa dan disetujui kecamatan, kemudian diteruskan ke kabupaten.',
        ),
        _buildItemStatus(
          label: 'Disetujui Kabupaten',
          latar: Colors.green.shade50,
          warnaTeks: Colors.green.shade800,
          uraian:
              'Laporan telah disetujui penuh oleh tingkat kabupaten sebagai data yang sah.',
        ),
        _buildItemStatus(
          label: 'Dibatalkan',
          latar: Colors.red.shade50,
          warnaTeks: Colors.red.shade800,
          uraian:
              'Laporan yang masih berstatus proses telah dibatalkan oleh pembuat laporan.',
        ),
        _buildItemStatus(
          label: 'Revisi',
          latar: Colors.red.shade50,
          warnaTeks: Colors.red.shade800,
          uraian:
              'Laporan memerlukan perbaikan berdasarkan catatan evaluasi pemeriksa yang dapat dibaca di rincian laporan.',
        ),
      ],
    );
  }

  Widget _buildItemStatus({
    required String label,
    required Color latar,
    required Color warnaTeks,
    required String uraian,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: latar,
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'DMSans',
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                color: warnaTeks,
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              uraian,
              style: TextStyle(
                fontFamily: 'DMSans',
                fontSize: 12.sp,
                color: Colors.grey.shade700,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
