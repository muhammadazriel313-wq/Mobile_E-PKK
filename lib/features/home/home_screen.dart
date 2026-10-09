import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:epkk_nganjuk/common/colors.dart';
import 'package:epkk_nganjuk/common/component/card_pengumuman.dart';

import 'package:epkk_nganjuk/features/auth/button/card_button_actions.dart';
import 'package:epkk_nganjuk/features/auth/component/header_home.dart';
import 'package:epkk_nganjuk/features/auth/component/widget_carousel_banner.dart';
import 'package:epkk_nganjuk/features/auth/component/widget_text_pengumuman.dart';

import 'package:epkk_nganjuk/features/home/nav_controller.dart';

import 'package:epkk_nganjuk/features/pengumuman/pengumuman_controller.dart';

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

  // ================= CONTROLLER =================
  final PengumumanController pengumumanController = Get.put(
    PengumumanController(),
  );

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
  }

  @override
  void dispose() {
    _midnightTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // [PERUBAHAN 08-10-2026] Segarkan data saat aplikasi kembali aktif (resume)
    if (state == AppLifecycleState.resumed) {
      pengumumanController.loadWeeklyPengumuman(isRefresh: true);
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
      _scheduleMidnightTimer();
    });
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

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // ================= HEADER =================
            HeaderHome(textUser: fullName ?? 'User'),

            // ================= BODY =================
            Expanded(
              child: RefreshIndicator(
                color: const Color(0xFF3F8FC1),
                onRefresh: () =>
                    pengumumanController.loadWeeklyPengumuman(isRefresh: true),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      SizedBox(height: 20.h),

                      // ================= BANNER =================
                      WidgetCarouselBanner(),

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

                      // ================= BUTTON LAPORAN =================
                      if (roleBidang == 'Bidang Umum') ...[
                        CardButtonActions(
                          backroundColor: ButtonActionsColors.fillLaporan,

                          strokeColor: ButtonActionsColors.strokeLaporan,

                          titleText: 'Upload Laporan Umum',

                          subTitle: 'upload laporan umum PKK disini',

                          imageAssets: 'assets/images/ic_report.png',

                          onTab: () {
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
                          },
                        ),
                      ] else ...[
                        CardButtonActions(
                          backroundColor: ButtonActionsColors.fillLaporan,

                          strokeColor: ButtonActionsColors.strokeLaporan,

                          titleText: 'Upload Laporan',

                          subTitle: 'upload laporan PKK disini',

                          imageAssets: 'assets/images/ic_report.png',

                          onTab: () {
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
                          },
                        ),
                      ],

                      SizedBox(height: 14.h),

                      // ================= BUTTON GALERI =================
                      CardButtonActions(
                        backroundColor: ButtonActionsColors.fillGalery,

                        strokeColor: ButtonActionsColors.strokeGalery,

                        titleText: 'Tambah Foto kegiatan',

                        subTitle: 'upload kegiatan PKK disini',

                        imageAssets: 'assets/images/ic_gallery.png',

                        onTab: () {
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

                      SizedBox(height: 32.h),

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
