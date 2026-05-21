import 'package:epkk_nganjuk/common/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class CardLaporan extends StatelessWidget {
  final String title;
  final String subtitle;
  final String status;
  final String dateText;
  final VoidCallback onTap;

  const CardLaporan({
    super.key,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.dateText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ZoomTapAnimation(
      onTap: onTap,

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
                  Icons.description_rounded,

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

                    /// SUBTITLE
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Icon(
                          Icons.folder_open_outlined,

                          size: 16.sp,

                          color: TextColors.grey500,
                        ),

                        SizedBox(width: 4.w),

                        Expanded(
                          child: Text(
                            subtitle,

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

                    SizedBox(height: 12.h),

                    /// FOOTER
                    Row(
                      children: [
                        /// DATE
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 5.h,
                          ),

                          decoration: BoxDecoration(
                            color: BrandColors.brandPrimary500.withOpacity(
                              0.08,
                            ),

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

                        const Spacer(),

                        /// STATUS
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 6.h,
                          ),

                          decoration: BoxDecoration(
                            color: getStatusColor(status),

                            borderRadius: BorderRadius.circular(100.r),
                          ),

                          child: Text(
                            status,

                            maxLines: 1,

                            overflow: TextOverflow.ellipsis,

                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w700,
                              color: getStatusTextColor(status),
                            ),
                          ),
                        ),
                      ],
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

Color getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'sedang diproses':
      return Colors.orange.shade100;

    case 'revisi':
      return Colors.red.shade100;

    case 'disetujui kecamatan':
      return Colors.green.shade100;

    case 'disetujui kabupaten':
      return Colors.green.shade100;

    default:
      return Colors.grey.shade200;
  }
}

Color getStatusTextColor(String status) {
  switch (status.toLowerCase()) {
    case 'sedang diproses':
      return Colors.orange.shade800;

    case 'revisi':
      return Colors.red.shade800;

    case 'disetujui kecamatan':
      return Colors.green.shade800;

    case 'disetujui kabupaten':
      return Colors.green.shade800;

    default:
      return Colors.grey.shade600;
  }
}

String getSubtitleFromUUID(String uuid) {
  final prefix = uuid.split('-').first;

  switch (prefix) {
    case 'KP1':
      return 'Kader Pokja I';

    case 'KP1B1':
      return 'Penghayatan dan Pengamalan Pancasila';

    case 'KP1B2':
      return 'Gotong Royong';

    case 'KP2B1':
      return 'Pendidikan Ketrampilan';

    case 'KP2B2':
      return 'Pengembangan Kehidupan Berkoperasi';

    case 'KP3':
      return 'Kader Pokja III';

    case 'KP3B1':
      return 'Pangan';

    case 'KP3B2':
      return 'Jumlah Industri Rumah Tangga';

    case 'KP3B3':
      return 'Perumahan dan Tata Laksana Rumah Tangga';

    case 'KP4':
      return 'Kader Pokja IV';

    case 'KP4B1':
      return 'Kesehatan';

    case 'KP4B2':
      return 'Kelestarian Lingkungan Hidup';

    case 'KP4B3':
      return 'Jumlah Rumah Yang Memiliki';

    case 'UNGGULAN':
      return 'Inovasi Unggulan';

    case 'PRIORITAS':
      return 'Inovasi Prioritas';

    case 'PKKUM':
      return 'Laporan Umum';

    default:
      return 'Kategori Tidak Dikenal';
  }
}
