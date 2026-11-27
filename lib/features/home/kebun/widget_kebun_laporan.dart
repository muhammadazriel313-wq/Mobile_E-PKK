import 'package:epkk_nganjuk/features/home/kebun/kebun_laporan_controller.dart';
import 'package:epkk_nganjuk/features/home/kebun/kebun_pohon_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

/// Banner biru "Kebun Laporan" di Beranda sesuai spesifikasi Figma (Node 3463:3304).
///
/// Dimensi dasar Figma: 328 x 154 (radius 18.78 / ~19r, padding kiri 18).
/// Menampilkan pohon yang tumbuh sesuai jumlah laporan yang disetujui
/// Kabupaten pada bulan berjalan (0 - 20), dan kembali ke benih otomatis setiap
/// pergantian bulan.
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
        borderRadius: BorderRadius.circular(19.r),
        child: Stack(
          children: [
            // ---------- LATAR BELAKANG GRADASI & ORNAMEN FIGMA ----------
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
            // Ornamen lingkaran transparan (Figma node 3463:3305)
            Positioned(
              right: -55.w,
              bottom: -65.h,
              child: ExcludeSemantics(
                child: Container(
                  width: 190.w,
                  height: 190.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.07),
                  ),
                ),
              ),
            ),

            // ---------- ISI KONTEN DINAMIS ----------
            Obx(() => _isi(c)),

            // ---------- TARGET KLIK (DETAIL BOTTOM SHEET) ----------
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _tampilDetail(c),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= ISI BANNER =================
  Widget _isi(KebunLaporanController c) {
    final n = c.jumlahBulanIni.value;
    final bulan = DateFormat('MMMM', 'id_ID').format(c.periode.value);
    final tahap = KebunLaporanController.tahapUntuk(n);
    final progres =
        (n / KebunLaporanController.targetBulanan).clamp(0.0, 1.0).toDouble();

    // Pemetaan ilustrasi pohon:
    // Jika tahap mencapai "Pohon Dewasa" atau "Pohon Berbuah", gunakan ilustrasi pohon asli Figma (3463:3320).
    // Untuk tahap awal (Benih, Tunas, Bibit, Pohon Muda), gunakan ilustrasi pertumbuhan dari KebunPohonSvg.
    final bool isPohonDewasaAtauBerbuah = n >= 10;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Rasio tinggi minimal mengikuti Figma: lebarKartu * (154 / 328)
        final lebarKartu = constraints.maxWidth;
        final minHeight = lebarKartu * (154.0 / 328.0);
        // Lebar kolom teks ~56% lebar kartu agar leluasa dan tidak menabrak ilustrasi
        final lebarKolomTeks = lebarKartu * 0.56;

        return ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: double.infinity,
            minHeight: minHeight,
          ),
          child: Stack(
            children: [
              // ---------- ILUSTRASI POHON DI KANAN BAWAH (Target area ~150x95) ----------
              Positioned(
                right: 0,
                bottom: 0,
                width: 152.w,
                height: 100.h,
                child: ExcludeSemantics(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: isPohonDewasaAtauBerbuah
                        ? SvgPicture.asset(
                            'assets/icons/pohon_figma.svg',
                            key: const ValueKey('pohon_figma'),
                            width: 152.w,
                            height: 100.h,
                            fit: BoxFit.contain,
                            alignment: Alignment.bottomRight,
                          )
                        : Transform.scale(
                            scale: 1.15, // Perbesar tunas/bibit proporsional agar mengisi area kanan bawah
                            alignment: Alignment.bottomRight,
                            child: SvgPicture.string(
                              KebunPohonSvg.build(n),
                              key: ValueKey<int>(n.clamp(0, KebunPohonSvg.maksLaporan)),
                              fit: BoxFit.contain,
                              alignment: Alignment.bottomRight,
                            ),
                          ),
                  ),
                ),
              ),

              // ---------- KONTEN TEKS (KOLOM KIRI) ----------
              Padding(
                padding: EdgeInsets.fromLTRB(18.w, 16.h, 14.w, 14.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Judul (y=14): Bold 15, putih
                    Text(
                      c.judul.value,
                      style: TextStyle(
                        fontFamily: _font,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: 3.h),

                    // Subjudul (y=33): DM Sans 11, #CFE6FA
                    Text(
                      '${tahap.nama} · $bulan',
                      style: TextStyle(
                        fontFamily: _font,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFFCFE6FA),
                      ),
                    ),
                    SizedBox(height: 10.h),

                    // Angka besar (y=58) Bold 34 putih + label dua baris #E3F0FC 10sp
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '$n',
                          style: TextStyle(
                            fontFamily: _font,
                            fontSize: 34.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            height: 1.0,
                          ),
                        ),
                        SizedBox(width: 14.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'laporan disetujui',
                              style: TextStyle(
                                fontFamily: _font,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFFE3F0FC),
                                height: 1.2,
                              ),
                            ),
                            Text(
                              'Kabupaten',
                              style: TextStyle(
                                fontFamily: _font,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFFE3F0FC),
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),

                    // Progress bar (y=109): lebar kolom kiri ~56% lebar kartu, tinggi 5.6h
                    SizedBox(
                      width: lebarKolomTeks,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(3.r),
                        child: LinearProgressIndicator(
                          value: progres,
                          minHeight: 5.6.h,
                          backgroundColor: Colors.white.withValues(alpha: 0.25),
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(_hijauProgres),
                        ),
                      ),
                    ),
                    SizedBox(height: 7.h),

                    // Teks keterangan (y=121): DM Sans 9.5sp, #CFE6FA, sampai 3 baris tanpa terpotong
                    SizedBox(
                      width: lebarKolomTeks,
                      child: Text(
                        KebunLaporanController.petunjuk(n),
                        maxLines: 3,
                        softWrap: true,
                        style: TextStyle(
                          fontFamily: _font,
                          fontSize: 9.5.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFFCFE6FA),
                          height: 1.25,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
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
