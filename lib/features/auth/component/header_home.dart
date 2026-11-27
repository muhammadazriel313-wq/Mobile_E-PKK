import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class HeaderHome extends StatelessWidget {
  final String textUser;

  /// Ketuk ikon lonceng (pojok kanan atas). Jika null, lonceng disembunyikan.
  final VoidCallback? onNotifTap;

  /// Jumlah notifikasi yang belum dibaca (angka merah di lonceng, 0 = tidak tampil).
  final int jumlahNotifikasi;

  const HeaderHome({
    super.key,
    required this.textUser,
    this.onNotifTap,
    this.jumlahNotifikasi = 0,
  });

  /// Fungsi greeting lama dipertahankan agar tidak melanggar batasan
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

  @override
  Widget build(BuildContext context) {
    // Format tanggal Indonesia: "Kamis, 26 November 2026"
    final tanggalSekarang = DateFormat(
      'EEEE, dd MMMM yyyy',
      'id_ID',
    ).format(DateTime.now());

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ================= BARIS 1: LOGO + BRAND + LONCENG =================
          SizedBox(height: 8.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo PKK (Resolusi tinggi, latar transparan bersih)
              // CATATAN: Ubah width dan height di bawah jika ingin mengatur besar/kecil logo secara manual
              Semantics(
                label: 'Logo PKK',
                child: Image.asset(
                  'assets/images/logo_pkk_clean.png',
                  width: 52.w, // Atur lebar logo di sini (default sebelumnya: 46.w)
                  height: 48.h, // Atur tinggi logo di sini (default sebelumnya: 34.h)
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                ),
              ),
              SizedBox(width: 10.w),

              // Brand Text: "E-PKK" & "Kabupaten Nganjuk"
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Teks E-PKK dengan efek stroke putih (outer border) sesuai Figma
                    Stack(
                      children: [
                        // Lapisan Stroke Putih di belakang
                        Text(
                          'E-PKK',
                          style: TextStyle(
                            fontFamily: 'DMSans',
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w700,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 3.0 // Ketebalan stroke putih (ubah di sini jika ingin tebal/tipis)
                              ..strokeJoin = StrokeJoin.round
                              ..color = Colors.white,
                            height: 1.1,
                          ),
                        ),
                        // Lapisan Teks Biru Utama di depan
                        Text(
                          'E-PKK',
                          style: TextStyle(
                            fontFamily: 'DMSans',
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0B4F8A),
                            height: 1.1,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Kabupaten Nganjuk',
                      style: TextStyle(
                        fontFamily: 'DMSans',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF0B3D73),
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ),

              // Tombol Lonceng
              if (onNotifTap != null) ...[
                _NotifBell(onTap: onNotifTap!, jumlah: jumlahNotifikasi),
              ],
            ],
          ),

          SizedBox(height: 12.h),

          // ================= BARIS 2 & 3: SAPAAN + NAMA AKUN + TANGGAL =================
          Padding(
            padding: EdgeInsets.only(left: 13.w), // Kompensasi visual Figma
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // "Selamat Datang,"
                Text(
                  'Selamat Datang,',
                  style: TextStyle(
                    fontFamily: 'DMSans',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF0B3D73),
                    shadows: const [
                      Shadow(
                        offset: Offset(0, 4),
                        blurRadius: 4,
                        color: Color(0x40000000), // rgba(0, 0, 0, 0.25)
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 2.h),

                // Nama Akun (Single line, auto-fit/shrink down to min ~20sp, lalu ellipsis)
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: 300.w,
                    ),
                    child: Text(
                      textUser,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'DMSans',
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0B4F8A),
                        height: 1.15,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 2.h),

                // Tanggal Hari Ini
                Text(
                  tanggalSekarang,
                  style: TextStyle(
                    fontFamily: 'DMSans',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF0B3D73),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 6.h), // Jarak ke kotak Kebun ±6px
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
              width: 44.w,
              height: 44.w,
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    Icons.notifications_none_rounded,
                    size: 25.sp,
                    color: const Color(0xFF3F8FC1),
                  ),
                  if (jumlah > 0)
                    Positioned(
                      top: -2.w,
                      right: -2.w,
                      child: Container(
                        constraints: BoxConstraints(
                          minWidth: 20.w,
                          minHeight: 20.w,
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE5484D),
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                        child: Text(
                          teks,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11.sp,
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
