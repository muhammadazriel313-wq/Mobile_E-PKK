import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:epkk_nganjuk/common/appbar/custom_appbar.dart';
import 'package:epkk_nganjuk/common/colors.dart';
import 'package:epkk_nganjuk/features/akun/profile_controller.dart';
import 'package:epkk_nganjuk/services/preferences/preferences_service.dart';

/// =======================================================
/// FILE : bantuan_screen.dart
/// [PERUBAHAN 08-10-2026] Halaman bantuan statis untuk panduan pengguna,
/// arti status laporan, FAQ, kontak admin WhatsApp, dan info aplikasi.
/// =======================================================

class BantuanScreen extends StatefulWidget {
  const BantuanScreen({super.key});

  /// ================= KONSTANTA DATA =================
  /// Catatan: Bila data asli telah tersedia, ganti nilai konstanta di bawah ini.
  /// Format nomor WhatsApp: 62812xxxx (tanpa tanda + dan tanpa angka 0 di depan).
  static const String adminWhatsAppNumber = '[belum diisi]';
  static const String serviceHours = '[belum diisi]';
  static const String developerName = '[belum diisi]';

  /// Catatan: Versi diselaraskan dengan field 'version' pada pubspec.yaml.
  /// Harap diperbarui bersamaan jika versi di pubspec.yaml berubah.
  static const String appVersion = '1.0.0+1';

  @override
  State<BantuanScreen> createState() => _BantuanScreenState();
}

class _BantuanScreenState extends State<BantuanScreen> {
  String userName = '';
  String userPhone = '';
  String userRole = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = await PreferencesService.getUser();
      if (user != null) {
        setState(() {
          userName = user.fullName;
          userPhone = user.phoneNumber;
          userRole = user.role?.name ?? '';
        });
        return;
      }

      if (Get.isRegistered<ProfilController>()) {
        final profil = Get.find<ProfilController>().profilData.value;
        setState(() {
          userName = profil.fullName;
          userPhone = profil.phoneNumber;
          userRole = profil.idRole == '1'
              ? 'Desa'
              : (profil.idRole == '2' ? 'Kecamatan' : '');
        });
      }
    } catch (_) {}
  }

  Future<void> _hubungiAdminWhatsApp() async {
    final rawNumber = BantuanScreen.adminWhatsAppNumber.trim();

    if (rawNumber.isEmpty || rawNumber == '[belum diisi]') {
      _tampilkanDialogNomorBelumTersedia();
      return;
    }

    final cleanNumber = rawNumber.replaceAll(RegExp(r'[^0-9]'), '');

    String pesan;
    if (userName.isNotEmpty && userRole.isNotEmpty) {
      pesan =
          'Halo Admin, saya $userName ($userPhone) sebagai kader $userRole. Saya butuh bantuan menggunakan aplikasi E-PKK.';
    } else if (userName.isNotEmpty) {
      pesan =
          'Halo Admin, saya $userName ($userPhone). Saya butuh bantuan menggunakan aplikasi E-PKK.';
    } else {
      pesan = 'Halo Admin, saya butuh bantuan menggunakan aplikasi E-PKK.';
    }

    final uri = Uri.parse(
      'https://wa.me/$cleanNumber?text=${Uri.encodeComponent(pesan)}',
    );

    try {
      final berhasil = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!berhasil && mounted) {
        _tampilkanGagalBukaWhatsApp(cleanNumber);
      }
    } catch (_) {
      if (mounted) {
        _tampilkanGagalBukaWhatsApp(cleanNumber);
      }
    }
  }

  void _tampilkanDialogNomorBelumTersedia() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: const Color(0xFF3F8FC1),
                size: 36.sp,
              ),
              SizedBox(height: 14.h),
              Text(
                'Kontak Belum Tersedia',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Nomor WhatsApp admin saat ini belum diatur di dalam sistem.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.grey.shade600,
                  height: 1.4,
                ),
              ),
              SizedBox(height: 20.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3F8FC1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    elevation: 0,
                  ),
                  onPressed: () => Get.back(),
                  child: Text(
                    'Tutup',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _tampilkanGagalBukaWhatsApp(String nomor) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.chat_bubble_outline_rounded,
                color: Colors.orange.shade700,
                size: 36.sp,
              ),
              SizedBox(height: 14.h),
              Text(
                'WhatsApp Tidak Dapat Dibuka',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Aplikasi WhatsApp tidak ditemukan atau tautan tidak dapat dibuka di perangkat ini. Anda dapat menyalin nomor admin di bawah ini.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.grey.shade600,
                  height: 1.4,
                ),
              ),
              SizedBox(height: 14.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: SelectableText(
                  nomor,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              SizedBox(height: 18.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      onPressed: () => Get.back(),
                      child: Text(
                        'Tutup',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 13.sp,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.copy_rounded,
                          size: 16.sp, color: Colors.white),
                      label: Text(
                        'Salin Nomor',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3F8FC1),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: nomor));
                        Get.back();
                        Get.snackbar(
                          'Nomor Tersalin',
                          'Nomor WhatsApp admin berhasil disalin ke papan klip.',
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: const Color(0xFF3F8FC1),
                          colorText: Colors.white,
                          margin: EdgeInsets.all(12.w),
                          borderRadius: 12.r,
                          duration: const Duration(seconds: 2),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TextColors.grey50,
      appBar: AppBarPrimary(
        title: 'Bantuan',
        backgroundColor: Colors.white,
        onBack: () => Get.back(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBagianPanduanCepat(),
              SizedBox(height: 18.h),
              _buildBagianArtiStatus(),
              SizedBox(height: 18.h),
              _buildBagianPertanyaanUmum(),
              SizedBox(height: 18.h),
              _buildBagianHubungiAdmin(),
              SizedBox(height: 18.h),
              _buildBagianTentangAplikasi(),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKartuKontainer({
    required String judul,
    required IconData ikon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF3F8FC1).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(ikon, size: 20.sp, color: const Color(0xFF3F8FC1)),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  judul,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          child,
        ],
      ),
    );
  }

  Widget _buildBagianPanduanCepat() {
    return _buildKartuKontainer(
      judul: 'Panduan Cepat',
      ikon: Icons.menu_book_rounded,
      child: Column(
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
      ),
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
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
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
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  uraian,
                  style: TextStyle(
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

  Widget _buildBagianArtiStatus() {
    return _buildKartuKontainer(
      judul: 'Arti Status Laporan',
      ikon: Icons.flag_outlined,
      child: Column(
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
      ),
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

  Widget _buildBagianPertanyaanUmum() {
    return _buildKartuKontainer(
      judul: 'Pertanyaan Umum',
      ikon: Icons.quiz_outlined,
      child: Column(
        children: [
          _buildExpansionFaq(
            pertanyaan: 'Laporan saya tidak muncul di Riwayat',
            jawaban:
                'Pastikan pilihan tab filter di bagian atas halaman Riwayat sudah sesuai dengan status laporan Anda, yaitu tab Proses, Revisi, atau Selesai.',
          ),
          _buildExpansionFaq(
            pertanyaan: 'Cara mengedit atau membatalkan laporan',
            jawaban:
                'Pengeditan dan pembatalan hanya dapat dilakukan jika laporan masih berstatus Sedang Diproses melalui ikon di pojok kanan atas halaman rincian laporan.',
          ),
          _buildExpansionFaq(
            pertanyaan: 'Saya lupa kata sandi',
            jawaban:
                'Tekan tombol Lupa Kata Sandi pada halaman masuk, masukkan nomor telepon yang terdaftar, lalu ikuti petunjuk verifikasi kode untuk membuat kata sandi baru.',
          ),
          _buildExpansionFaq(
            pertanyaan: 'Foto kegiatan gagal diunggah',
            jawaban:
                'Pastikan koneksi internet stabil, izin akses galeri aktif pada pengaturan perangkat, dan ukuran foto tidak melebihi batas yang ditentukan sistem.',
          ),
          _buildExpansionFaq(
            pertanyaan: 'Nomor WhatsApp saya salah atau berganti',
            jawaban:
                'Buka menu Profil, tekan Informasi Akun, ubah isian Nomor HP dengan nomor baru yang aktif, lalu tekan tombol Simpan Perubahan.',
          ),
          _buildExpansionFaq(
            pertanyaan: 'Laporan saya mendapat catatan revisi, apa langkahnya',
            jawaban:
                'Laporan dengan catatan revisi tidak dapat diedit atau dikirim ulang secara langsung pada formulir lama. Buka rincian laporan di menu Riwayat untuk membaca catatan evaluasi pemeriksa, lalu buat dan kirim laporan baru dengan isian yang sudah diperbaiki.',
          ),
        ],
      ),
    );
  }

  Widget _buildExpansionFaq({
    required String pertanyaan,
    required String jawaban,
  }) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        childrenPadding: EdgeInsets.only(bottom: 12.h, left: 4.w, right: 4.w),
        iconColor: const Color(0xFF3F8FC1),
        collapsedIconColor: Colors.grey.shade500,
        title: Text(
          pertanyaan,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              jawaban,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey.shade600,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBagianHubungiAdmin() {
    return _buildKartuKontainer(
      judul: 'Hubungi Admin',
      ikon: Icons.headset_mic_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.schedule_rounded,
                  size: 16.sp, color: Colors.grey.shade600),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  'Jam layanan: ${BantuanScreen.serviceHours}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: Icon(
                Icons.chat_outlined,
                size: 18.sp,
                color: Colors.white,
              ),
              label: Text(
                'Hubungi Admin lewat WhatsApp',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF25D366),
                elevation: 0,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
              ),
              onPressed: _hubungiAdminWhatsApp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBagianTentangAplikasi() {
    return _buildKartuKontainer(
      judul: 'Tentang Aplikasi',
      ikon: Icons.info_outline_rounded,
      child: Column(
        children: [
          _buildBarisInfo(
            label: 'Nama Aplikasi',
            nilai: 'E-PKK Kabupaten Nganjuk',
          ),
          SizedBox(height: 8.h),
          _buildBarisInfo(
            label: 'Versi',
            nilai: BantuanScreen.appVersion,
          ),
          SizedBox(height: 8.h),
          _buildBarisInfo(
            label: 'Pengembang',
            nilai: BantuanScreen.developerName,
          ),
        ],
      ),
    );
  }

  Widget _buildBarisInfo({
    required String label,
    required String nilai,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey.shade600,
          ),
        ),
        SizedBox(width: 12.w),
        Flexible(
          child: Text(
            nilai,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
