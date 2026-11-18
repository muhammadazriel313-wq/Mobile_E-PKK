import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PanduanCepatContent extends StatelessWidget {
  const PanduanCepatContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildItemPanduan(
          nomor: '1',
          judul: 'Masuk ke akun',
          uraian:
              'Buka aplikasi lalu masukkan nomor telepon dan kata sandi yang telah terdaftar.',
        ),
        _buildItemPanduan(
          nomor: '2',
          judul: 'Memilih bidang',
          uraian:
              'Menu laporan pada beranda otomatis menyesuaikan dengan penugasan bidang atau pokja Anda.',
        ),
        _buildItemPanduan(
          nomor: '3',
          judul: 'Mengisi dan mengirim laporan',
          uraian:
              'Tekan tombol Upload Laporan pada halaman beranda, lengkapi formulir isian data secara berurutan, lalu kirim laporan.',
        ),
        _buildItemPanduan(
          nomor: '4',
          judul: 'Menambah foto kegiatan',
          uraian:
              'Tekan tombol Tambah Foto kegiatan pada beranda, pilih foto dokumentasi dari perangkat, isi keterangan kegiatan, lalu kirim.',
        ),
        _buildItemPanduan(
          nomor: '5',
          judul: 'Melihat riwayat',
          uraian:
              'Pilih menu Riwayat di navigasi bawah untuk memeriksa laporan yang sedang berjalan maupun yang telah selesai.',
        ),
        _buildItemPanduan(
          nomor: '6',
          judul: 'Mengubah kata sandi',
          uraian:
              'Buka menu Profil, pilih Ubah Kata Sandi, masukkan kata sandi saat ini, lalu simpan kata sandi baru.',
        ),
        SizedBox(height: 6.h),
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: const Color(0xFF3F8FC1).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: const Color(0xFF3F8FC1).withValues(alpha: 0.25),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: const Color(0xFF3F8FC1),
                size: 18.sp,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'Perbedaan peran: Laporan kader Desa diperiksa dan disetujui bertahap oleh pihak Kecamatan lalu Kabupaten. Laporan kader Kecamatan diperiksa langsung oleh pihak Kabupaten.',
                  style: TextStyle(
                    fontFamily: 'DMSans',
                    fontSize: 12.sp,
                    color: const Color(0xFF1E567A),
                    height: 1.45,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildItemPanduan({
    required String nomor,
    required String judul,
    required String uraian,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 11.r,
            backgroundColor: const Color(0xFF3F8FC1),
            child: Text(
              nomor,
              style: TextStyle(
                fontFamily: 'DMSans',
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  judul,
                  style: TextStyle(
                    fontFamily: 'DMSans',
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  uraian,
                  style: TextStyle(
                    fontFamily: 'DMSans',
                    fontSize: 12.sp,
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
