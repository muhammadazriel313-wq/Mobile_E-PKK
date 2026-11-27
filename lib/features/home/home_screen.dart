import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:epkk_nganjuk/common/colors.dart';
import 'package:epkk_nganjuk/common/component/card_pengumuman.dart';

import 'package:epkk_nganjuk/features/auth/button/card_button_actions.dart';
import 'package:epkk_nganjuk/features/auth/component/header_home.dart';
import 'package:epkk_nganjuk/features/auth/component/widget_text_pengumuman.dart';

import 'package:epkk_nganjuk/features/home/kebun/kebun_laporan_controller.dart';
import 'package:epkk_nganjuk/features/home/component/card_action_figma.dart';
import 'package:epkk_nganjuk/features/home/kebun/widget_kebun_laporan.dart';
import 'package:epkk_nganjuk/features/home/nav_controller.dart';
import 'package:epkk_nganjuk/features/notifikasi/notifikasi_controller.dart';

import 'package:epkk_nganjuk/features/pengumuman/pengumuman_controller.dart';

// [PERUBAHAN BARU] Import section Peringkat
import 'package:epkk_nganjuk/features/peringkat/peringkat_home_section.dart';
// [PERUBAHAN 20-11-2026] Dibutuhkan untuk memilih podium desa/kecamatan
import 'package:epkk_nganjuk/features/peringkat/peringkat_model.dart';

import 'package:epkk_nganjuk/routes/app_routes.dart';

import 'package:epkk_nganjuk/services/preferences/preferences_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  // ================= USER DATA =================
  String idUser = '';
  String? idRole;

  String role = '';

  String? idOrganization;
  String? roleBidang;

  String? fullName = 'User';

  // [PERUBAHAN 20-11-2026] Akun kecamatan melihat podium kecamatan,
  // akun lain melihat podium desa.
  bool get _akunKecamatan => role.toLowerCase().contains('kecamatan');

  // ================= CONTROLLER =================
  final PengumumanController pengumumanController = Get.put(
    PengumumanController(),
  );

  // [PERUBAHAN 13-11-2026] Kebun Laporan (menggantikan slider banner) dan lonceng
  final KebunLaporanController kebunController = Get.put(
    KebunLaporanController(),
  );
  // [PERUBAHAN 18-11-2026] Pusat notifikasi (lonceng + pop up), berjalan selama aplikasi dibuka
  final NotifikasiController notifController = Get.put(
    NotifikasiController(),
    permanent: true,
  );
  Worker? _pengumumanWorker;

  // [PERUBAHAN 08-10-2026] Timer untuk penyegaran otomatis saat pergantian tengah malam WIB
  Timer? _midnightTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    loadUserData();
    // [PERUBAHAN 08-10-2026] Memuat hanya pengumuman minggu ini
    pengumumanController.loadWeeklyPengumuman(isRefresh: true);
    _scheduleMidnightTimer();

    // [PERUBAHAN 13-11-2026] Muat jumlah laporan disetujui untuk Kebun Laporan
    _muatKebun();

    // [PERUBAHAN 18-11-2026] Pengumuman baru minggu ini -> notifikasi
    _pengumumanWorker = ever(
      pengumumanController.weeklyPengumumanList,
      (_) => notifController.periksaPengumuman(
        pengumumanController.weeklyPengumumanList.toList(),
      ),
    );
  }

  @override
  void dispose() {
    _pengumumanWorker?.dispose();
    _midnightTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // [PERUBAHAN 08-10-2026] Segarkan data saat aplikasi kembali aktif (resume)
    if (state == AppLifecycleState.resumed) {
      pengumumanController.loadWeeklyPengumuman(isRefresh: true);
      // [PERUBAHAN 13-11-2026] Hitung ulang (bisa jadi sudah ganti bulan) dan muat ulang
      kebunController.hitung();
      _muatKebun();
    }
  }

  void _scheduleMidnightTimer() {
    _midnightTimer?.cancel();
    final now = DateTime.now();
    // Tengah malam berikutnya pukul 00:00:01
    final tomorrow = DateTime(now.year, now.month, now.day + 1, 0, 0, 1);
    final duration = tomorrow.difference(now);

    _midnightTimer = Timer(duration, () {
      pengumumanController.loadWeeklyPengumuman(isRefresh: true);
      // [PERUBAHAN 13-11-2026] Tengah malam tanggal 1 -> hitungan bulan baru = 0 (pohon reset)
      kebunController.hitung();
      _scheduleMidnightTimer();
    });
  }

  // [PERUBAHAN 18-11-2026] Mengaktifkan Kebun Laporan dan pusat notifikasi.
  // Data laporan diambil satu kali oleh NotifikasiController lalu dibagikan
  // ke Kebun Laporan, dan diperbarui otomatis tiap 1 menit selama aplikasi dibuka.
  Future<void> _muatKebun() async {
    final user = await PreferencesService.getUser();
    if (user == null) return;

    final idUser = user.id ?? '';
    final idRole = user.role?.id ?? '';
    final idOrg = user.organization?.id ?? '';

    kebunController.aturPengguna(idUser: idUser, idRole: idRole);

    await notifController.mulai(
      idUser: idUser,
      idRole: idRole,
      idOrganization: idOrg,
    );
    await notifController.periksaPengumuman(
      pengumumanController.weeklyPengumumanList.toList(),
    );
  }

  // ================= LOAD USER =================
  Future<void> loadUserData() async {
    final user = await PreferencesService.getUser();

    if (user != null) {
      setState(() {
        idUser = user.id ?? 'id user tidak diketahui';

        fullName = user.fullName;

        idRole = user.role?.id ?? 'id role tidak diketahui';

        role = user.role?.name ?? 'name role tidak diketahui';

        idOrganization =
            user.organization?.id ?? 'id organization tidak diketahui';

        roleBidang =
            user.organization?.name ?? 'name organization tidak diketahui';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Stack(
        children: [
          // Background Foto Tugu Nganjuk & Glow Putih (Figma Node 3463:3557)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: IgnorePointer(
              ignoring: true,
              child: ExcludeSemantics(
                child: SizedBox(
                  height: 250.h,
                  width: double.infinity,
                  child: Stack(
                    clipBehavior: Clip.hardEdge,
                    fit: StackFit.expand,
                    children: [
                      // Foto Tugu Nganjuk lebih jelas (opacity 100%)
                      Opacity(
                        opacity: 1.0,
                        child: Image.asset(
                          'assets/images/header_tugu_nganjuk.png',
                          fit: BoxFit.cover,
                          alignment: const Alignment(0.12, -1.0),
                        ),
                      ),
                      // Overlay Gradien Putih Lebih Ringan (atas 22%, tengah 10%, bawah memudar penuh)
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0.0, 0.62, 1.0],
                            colors: [
                              Color(0x38FFFFFF), // Putih ~22%
                              Color(0x1AFFFFFF), // Putih ~10%
                              Colors.white,      // Putih 100% (memudar mulus ke warna latar)
                            ],
                          ),
                        ),
                      ),
                      // Glow Putih Radial (Figma Node 3463:3557 "Ellipse 757") di belakang sapaan
                      Positioned(
                        left: -78.w,
                        top: 24.h,
                        width: 268.w,
                        height: 255.h,
                        child: SvgPicture.asset(
                          'assets/images/glow_header.svg',
                          fit: BoxFit.fill,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // ================= HEADER =================
            Obx(
              () => HeaderHome(
                textUser: fullName ?? 'User',
                jumlahNotifikasi: notifController.jumlahBelumDibaca.value,
                onNotifTap: notifController.bukaLayar,
              ),
            ),

            // ================= BODY =================
            Expanded(
              child: RefreshIndicator(
                color: const Color(0xFF3F8FC1),
                onRefresh: () => Future.wait([
                  pengumumanController.loadWeeklyPengumuman(isRefresh: true),
                  _muatKebun(),
                ]),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      // Jarak dari header ke atas kotak Kebun (turunkan ±14px lebih jauh: 6 + 14 = 20px)
                      SizedBox(height: 20.h),

                      // ================= BANNER (KEBUN LAPORAN) =================
                      // [PERUBAHAN 13-11-2026] Menggantikan WidgetCarouselBanner (slider)
                      const WidgetKebunLaporan(),

                      SizedBox(height: 20.h),

                      // ================= TITLE =================
                      Text(
                        'Layanan PKK',

                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: TextColors.grey700,
                        ),
                      ),

                      SizedBox(height: 18.h),

                      // ================= AKSI CEPAT (FIGMA 2 KOLOM) =================
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: CardActionFigma(
                                title: roleBidang == 'Bidang Umum'
                                    ? 'Upload Laporan Umum'
                                    : 'Upload Laporan',
                                description: 'Laporkan kegiatan PKK disini',
                                imageAsset: 'assets/icons/ic_upload_laporan.png',
                                onTap: () {
                                  if (roleBidang == 'Bidang Umum') {
                                    Get.toNamed(
                                      Routes.LAPORAN_UMUM1,
                                      arguments: {
                                        'id_user': idUser,
                                        'full_name': fullName,
                                        'id_role': idRole,
                                        'name_role': role,
                                        'id_organization': idOrganization,
                                        'name_organization': roleBidang,
                                      },
                                    );
                                  } else {
                                    Get.toNamed(
                                      Routes.UPLOAD_LAPORAN,
                                      arguments: {
                                        'id_user': idUser,
                                        'full_name': fullName,
                                        'id_role': idRole,
                                        'name_role': role,
                                        'id_organization': idOrganization,
                                        'name_organization': roleBidang,
                                      },
                                    );
                                  }
                                },
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: CardActionFigma(
                                title: 'Upload Foto Kegiatan',
                                description: 'Bagikan momen kegiatan PKK',
                                imageAsset: 'assets/icons/ic_upload_galeri.png',
                                onTap: () {
                                  Get.toNamed(
                                    Routes.UPLOAD_GALERI,
                                    arguments: {
                                      'id_user': idUser,
                                      'full_name': fullName,
                                      'id_role': idRole,
                                      'name_role': role,
                                      'id_organization': idOrganization,
                                      'name_organization': roleBidang,
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Kurangi jarak ke Peringkat dari ~32px menjadi ~16px
                      SizedBox(height: 16.h),

                      // ================= PERINGKAT (BARU) =================
                      // [PERUBAHAN 20-11-2026] Akun kecamatan -> podium kecamatan,
                      // akun lain -> podium desa.
                      PeringkatHomeSection(
                        jenis: _akunKecamatan
                            ? PeringkatJenis.kecamatan
                            : PeringkatJenis.desa,
                      ),

                      SizedBox(height: 24.h),

                      // ================= PENGUMUMAN =================
                      Obx(() {
                        // ================= LOADING =================
                        if (pengumumanController.isWeeklyLoading.value &&
                            pengumumanController.weeklyPengumumanList.isEmpty) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF3F8FC1),
                            ),
                          );
                        }

                        final list = pengumumanController.weeklyPengumumanList;

                        return Column(
                          children: [
                            // ================= TITLE =================
                            WidgetTextPengumuman(
                              firstText: 'Pengumuman',
                              secondText: 'Pengumuman minggu ini',
                              threeText: 'Lihat Semua',
                              svgIcon: 'assets/icons/ic_arrow_right.svg',
                              onTapThreeText: () {
                                final NavController navController =
                                    Get.find<NavController>();
                                navController.changeTabIndex(2);
                              },
                            ),

                            SizedBox(height: 16.h),

                            // [PERUBAHAN 08-10-2026] Tampilan lembut jika belum ada pengumuman minggu ini
                            if (list.isEmpty)
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                  vertical: 24.h,
                                  horizontal: 16.w,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8FAFC),
                                  borderRadius: BorderRadius.circular(16.r),
                                  border: Border.all(
                                    color: const Color(0xFFE7EDF3),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.campaign_outlined,
                                      size: 40.sp,
                                      color: Colors.grey.shade400,
                                    ),
                                    SizedBox(height: 10.h),
                                    Text(
                                      'Belum ada pengumuman minggu ini',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                    SizedBox(height: 6.h),
                                    Text(
                                      'Lihat arsip pengumuman di Riwayat Pengumuman',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                    SizedBox(height: 12.h),
                                    TextButton.icon(
                                      icon: Icon(
                                        Icons.calendar_month_outlined,
                                        size: 16.sp,
                                        color: const Color(0xFF3F8FC1),
                                      ),
                                      label: Text(
                                        'Buka Riwayat',
                                        style: TextStyle(
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF3F8FC1),
                                        ),
                                      ),
                                      onPressed: () {
                                        Get.toNamed(Routes.RIWAYAT_PENGUMUMAN);
                                      },
                                    ),
                                  ],
                                ),
                              )
                            else
                              // ================= LIST =================
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: list.length,
                                itemBuilder: (context, index) {
                                  final pengumuman = list[index];

                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 16.h),
                                    child: CardPengumuman(
                                      title: pengumuman.judul,
                                      subTitle: pengumuman.tempat,
                                      dateText: DateFormat(
                                        'dd-MM-yyyy',
                                      ).format(pengumuman.tanggal),
                                      onTab: () {
                                        _showDetailPengumuman(
                                          pengumuman.judul,
                                          pengumuman.deskripsi,
                                          pengumuman.tempat,
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
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

  // ================= DETAIL DIALOG =================
  void _showDetailPengumuman(String title, String description, String lokasi) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,

        insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
        ),

        child: Container(
          width: double.infinity,

          padding: EdgeInsets.all(20.w),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.r),
            color: Colors.white,
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min,

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              /// HEADER
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10.w),

                    decoration: BoxDecoration(
                      color: const Color(0xFF3F8FC1).withOpacity(0.1),

                      borderRadius: BorderRadius.circular(14.r),
                    ),

                    child: Icon(
                      Icons.campaign_rounded,
                      color: const Color(0xFF3F8FC1),
                      size: 24.sp,
                    ),
                  ),

                  SizedBox(width: 12.w),

                  Expanded(
                    child: Text(
                      'Detail Pengumuman',

                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),

                  InkWell(
                    borderRadius: BorderRadius.circular(100.r),

                    onTap: () => Get.back(),

                    child: Padding(
                      padding: EdgeInsets.all(4.w),

                      child: Icon(
                        Icons.close_rounded,
                        size: 22.sp,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20.h),

              /// JUDUL
              Container(
                width: double.infinity,

                padding: EdgeInsets.all(14.w),

                decoration: BoxDecoration(
                  color: Colors.grey.shade50,

                  borderRadius: BorderRadius.circular(16.r),

                  border: Border.all(color: Colors.grey.shade200),
                ),

                child: Text(
                  title,

                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
              ),

              SizedBox(height: 18.h),

              /// LOKASI
              Container(
                width: double.infinity,

                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),

                decoration: BoxDecoration(
                  color: const Color(0xFF3F8FC1).withOpacity(0.06),

                  borderRadius: BorderRadius.circular(14.r),

                  border: Border.all(
                    color: const Color(0xFF3F8FC1).withOpacity(0.15),
                  ),
                ),

                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      color: const Color(0xFF3F8FC1),
                      size: 20.sp,
                    ),

                    SizedBox(width: 10.w),

                    Expanded(
                      child: Text(
                        lokasi,

                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.grey.shade800,
                          height: 1.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20.h),

              /// DESKRIPSI
              Text(
                'Isi Pengumuman',

                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),

              SizedBox(height: 10.h),

              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 250.h),

                child: SingleChildScrollView(
                  child: Text(
                    description,

                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey.shade800,
                      height: 1.7,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 24.h),

              /// BUTTON
              SizedBox(
                width: double.infinity,

                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,

                    backgroundColor: const Color(0xFF3F8FC1),

                    foregroundColor: Colors.white,

                    padding: EdgeInsets.symmetric(vertical: 14.h),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),

                  onPressed: () => Get.back(),

                  child: Text(
                    'Tutup',

                    style: TextStyle(
                      fontSize: 14.sp,
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
}
