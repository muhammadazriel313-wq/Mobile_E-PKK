import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PertanyaanUmumContent extends StatelessWidget {
  const PertanyaanUmumContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildExpansionFaq(
          context: context,
          pertanyaan: 'Laporan saya tidak muncul di Riwayat',
          jawaban:
              'Pastikan pilihan tab filter di bagian atas halaman Riwayat sudah sesuai dengan status laporan Anda, yaitu tab Proses, Revisi, atau Selesai.',
        ),
        _buildExpansionFaq(
          context: context,
          pertanyaan: 'Cara mengedit atau membatalkan laporan',
          jawaban:
              'Pengeditan dan pembatalan hanya dapat dilakukan jika laporan masih berstatus Sedang Diproses melalui ikon di pojok kanan atas halaman rincian laporan.',
        ),
        _buildExpansionFaq(
          context: context,
          pertanyaan: 'Saya lupa kata sandi',
          jawaban:
              'Tekan tombol Lupa Kata Sandi pada halaman masuk, masukkan nomor telepon yang terdaftar, lalu ikuti petunjuk verifikasi kode untuk membuat kata sandi baru.',
        ),
        _buildExpansionFaq(
          context: context,
          pertanyaan: 'Foto kegiatan gagal diunggah',
          jawaban:
              'Pastikan koneksi internet stabil, izin akses galeri aktif pada pengaturan perangkat, dan ukuran foto tidak melebihi batas yang ditentukan sistem.',
        ),
        _buildExpansionFaq(
          context: context,
          pertanyaan: 'Nomor WhatsApp saya salah atau berganti',
          jawaban:
              'Buka menu Profil, tekan Informasi Akun, ubah isian Nomor HP dengan nomor baru yang aktif, lalu tekan tombol Simpan Perubahan.',
        ),
        _buildExpansionFaq(
          context: context,
          pertanyaan: 'Laporan saya mendapat catatan revisi, apa langkahnya',
          jawaban:
              'Laporan dengan catatan revisi tidak dapat diedit atau dikirim ulang secara langsung pada formulir lama. Buka rincian laporan di menu Riwayat untuk membaca catatan evaluasi pemeriksa, lalu buat dan kirim laporan baru dengan isian yang sudah diperbaiki.',
        ),
      ],
    );
  }

  Widget _buildExpansionFaq({
    required BuildContext context,
    required String pertanyaan,
    required String jawaban,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14.r),
        child: Theme(
          data: Theme.of(context).copyWith(
            dividerColor: Colors.transparent,
            splashColor: const Color(0xFF3F8FC1).withValues(alpha: 0.05),
            highlightColor: const Color(0xFF3F8FC1).withValues(alpha: 0.03),
          ),
          child: ExpansionTile(
            tilePadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 2.h),
            childrenPadding: EdgeInsets.only(
              left: 14.w,
              right: 14.w,
              bottom: 14.h,
              top: 2.h,
            ),
            iconColor: const Color(0xFF3F8FC1),
            collapsedIconColor: const Color(0xFF64748B),
            shape: const Border(),
            collapsedShape: const Border(),
            title: Text(
              pertanyaan,
              style: TextStyle(
                fontFamily: 'DMSans',
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1E293B),
                letterSpacing: -0.1,
              ),
            ),
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: const Color(0xFFEDF2F7)),
                ),
                child: Text(
                  jawaban,
                  style: TextStyle(
                    fontFamily: 'DMSans',
                    fontSize: 12.sp,
                    color: const Color(0xFF475569),
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
