import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class HeaderHome extends StatelessWidget {
  final String textUser;

  /// Ketuk ikon lonceng (pojok kanan atas). Jika null, lonceng disembunyikan.
  final VoidCallback? onNotifTap;

  /// Jumlah notifikasi yang belum dibaca (angka merah di lonceng, 0 = tidak tampil).
  final int jumlahNotifikasi;

  HeaderHome({
    super.key,
    required this.textUser,
    this.onNotifTap,
    this.jumlahNotifikasi = 0,
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

          /// LONCENG (menuju pengumuman terkini)
          if (onNotifTap != null) ...[
            SizedBox(width: 8.w),
            _NotifBell(onTap: onNotifTap!, jumlah: jumlahNotifikasi),
          ],
        ],
      ),
    );
  }
}

class _NotifBell extends StatelessWidget {
  final VoidCallback onTap;
  final int jumlah;

  const _NotifBell({required this.onTap, required this.jumlah});

  @override
  Widget build(BuildContext context) {
    final teks = jumlah > 9 ? '9+' : '$jumlah';

    return Semantics(
      button: true,
      label: jumlah > 0
          ? 'Notifikasi, $jumlah belum dibaca'
          : 'Notifikasi',
      child: Tooltip(
        message: 'Notifikasi',
        child: Material(
          color: const Color(0xFFDEF3FF),
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onTap,
            child: SizedBox(
              width: 52.w,
              height: 52.w,
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    Icons.notifications_none_rounded,
                    size: 30.sp,
                    color: const Color(0xFF3F8FC1),
                  ),
                  if (jumlah > 0)
                    Positioned(
                      top: -2.w,
                      right: -2.w,
                      child: Container(
                        constraints: BoxConstraints(
                          minWidth: 24.w,
                          minHeight: 24.w,
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE5484D),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Text(
                          teks,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w800,
                            height: 1.0,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}