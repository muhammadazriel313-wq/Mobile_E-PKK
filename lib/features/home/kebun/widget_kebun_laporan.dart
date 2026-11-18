import 'package:epkk_nganjuk/features/home/kebun/kebun_laporan_controller.dart';
import 'package:epkk_nganjuk/features/home/kebun/kebun_pohon_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

/// Banner biru tetap di Beranda (menggantikan slider banner).
///
/// Menampilkan pohon yang tumbuh sesuai jumlah laporan yang disetujui
/// Kabupaten pada bulan berjalan, dan kembali ke benih otomatis setiap
/// pergantian bulan.
///
/// Huruf dibuat besar untuk pengguna lansia. Tinggi banner mengikuti isi
/// (minimal [_tinggiMinimal]), jadi teks tidak terpotong walau ukuran huruf
/// di HP diperbesar.
class WidgetKebunLaporan extends StatelessWidget {
  const WidgetKebunLaporan({super.key});

  static const Color _biruAtas = Color(0xFF1F5FA6);
  static const Color _biruBawah = Color(0xFF2F86C9);
  static const Color _hijauProgres = Color(0xFFA6E86B);
  static const String _font = 'DMSans';

  @override
  Widget build(BuildContext context) {
    final c = Get.find<KebunLaporanController>();

    return SizedBox(
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Stack(
        children: [
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [_biruAtas, _biruBawah],
                ),
              ),
            ),
          ),
          Positioned(
            right: -50.w,
            bottom: -70.h,
            child: Container(
              width: 190.w,
              height: 190.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.07),
              ),
            ),
          ),
          Obx(() => _isi(c)),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(onTap: () => _tampilDetail(c)),
            ),
          ),
        ],
        ),
      ),
    );
  }

  double get _tinggiMinimal => 176.h;

  // ================= ISI BANNER =================
  Widget _isi(KebunLaporanController c) {
    final n = c.jumlahBulanIni.value;
    final bulan = DateFormat('MMMM', 'id_ID').format(c.periode.value);
    final tahap = KebunLaporanController.tahapUntuk(n);
    final progres =
        (n / KebunLaporanController.targetBulanan).clamp(0.0, 1.0).toDouble();

    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: double.infinity,
        minHeight: _tinggiMinimal,
      ),
      child: Stack(
        children: [
          // ---------- TEKS (menentukan tinggi banner) ----------
          Padding(
            padding: EdgeInsets.fromLTRB(18.w, 16.h, 128.w, 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  c.judul.value,
                  style: TextStyle(
                    fontFamily: _font,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  '${tahap.nama} · $bulan',
                  style: TextStyle(
                    fontFamily: _font,
                    fontSize: 14.sp,
                    color: const Color(0xFFE3F0FC),
                  ),
                ),
                SizedBox(height: 10.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '$n',
                      style: TextStyle(
                        fontFamily: _font,
                        fontSize: 40.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.0,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        'laporan disetujui Kabupaten',
                        style: TextStyle(
                          fontFamily: _font,
                          fontSize: 14.sp,
                          color: Colors.white,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(5.r),
                  child: LinearProgressIndicator(
                    value: progres,
                    minHeight: 8.h,
                    backgroundColor: Colors.white.withValues(alpha: 0.25),
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(_hijauProgres),
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  KebunLaporanController.petunjuk(n),
                  style: TextStyle(
                    fontFamily: _font,
                    fontSize: 13.sp,
                    color: const Color(0xFFE3F0FC),
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),

          // ---------- POHON ----------
          Positioned(
            right: 6.w,
            bottom: 6.h,
            width: 124.w,
            height: 118.h,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: SvgPicture.string(
                KebunPohonSvg.build(n),
                key: ValueKey<int>(n.clamp(0, KebunPohonSvg.maksLaporan)),
                fit: BoxFit.contain,
                alignment: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= DETAIL (ketuk banner) =================
  void _tampilDetail(KebunLaporanController c) {
    final bulanIni = DateFormat('MMMM yyyy', 'id_ID').format(c.periode.value);
    final bulanLalu = DateFormat('MMMM', 'id_ID').format(
      DateTime(c.periode.value.year, c.periode.value.month - 1, 1),
    );

    Widget baris(String label, String nilai) => Padding(
          padding: EdgeInsets.symmetric(vertical: 7.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontFamily: _font,
                    fontSize: 16.sp,
                    color: const Color(0xFF374151),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                nilai,
                style: TextStyle(
                  fontFamily: _font,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1F2A37),
                ),
              ),
            ],
          ),
        );

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 24.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  c.judul.value,
                  style: TextStyle(
                    fontFamily: _font,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1F2A37),
                  ),
                ),
                SizedBox(height: 10.h),
                baris(
                  'Bulan ini ($bulanIni)',
                  '${c.jumlahBulanIni.value} laporan',
                ),
                baris(
                  'Bulan lalu ($bulanLalu)',
                  '${c.jumlahBulanLalu.value} laporan',
                ),
                baris(
                  'Belum disetujui Kabupaten',
                  '${c.jumlahBelumSelesai.value} laporan',
                ),
                baris(
                  'Target bulan ini',
                  '${KebunLaporanController.targetBulanan} laporan',
                ),
                baris('Reset otomatis', '${c.sisaHariSebelumReset} hari lagi'),
                SizedBox(height: 10.h),
                Text(
                  'Pohon hanya tumbuh dari laporan yang sudah disetujui '
                  'Kabupaten dan tidak sedang direvisi. Bila laporan '
                  'dikembalikan, direvisi, atau belum sampai ke Kabupaten, '
                  'pohon menyusut lagi. Setiap tanggal 1 pohon kembali ke '
                  'benih.',
                  style: TextStyle(
                    fontFamily: _font,
                    fontSize: 14.sp,
                    color: const Color(0xFF4B5563),
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 16.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: const Color(0xFF3F8FC1),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                    ),
                    onPressed: () => Get.back(),
                    child: Text(
                      'Tutup',
                      style: TextStyle(
                        fontFamily: _font,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }
}
