/// =======================================================
/// FILE : inovasi_screen.dart
/// =======================================================

import 'package:epkk_nganjuk/common/appbar/custom_appbar.dart';
import 'package:epkk_nganjuk/common/colors.dart';
import 'package:epkk_nganjuk/common/typography.dart';
import 'package:epkk_nganjuk/features/auth/button/button_file.dart';
import 'package:epkk_nganjuk/features/pages/pokja4/inovasi/component/jenis_laporan_dropdown.dart';
import 'package:epkk_nganjuk/features/pages/pokja4/inovasi/component/kategori_dorpdown.dart';
import 'package:epkk_nganjuk/routes/app_routes.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

class InovasiScreen extends StatefulWidget {
  const InovasiScreen({super.key});

  @override
  State<InovasiScreen> createState() => _InovasiScreenState();
}

class _InovasiScreenState extends State<InovasiScreen> {
  final _formKey = GlobalKey<FormState>();

  /// ================= DROPDOWN =================

  String? selectedKategori;

  String? selectedJenisLaporan;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    final isTablet = media.size.width >= 600;

    return Scaffold(
      resizeToAvoidBottomInset: true,

      backgroundColor: Colors.white,

      /// ================= APPBAR =================
      appBar: AppBarSecondary(
        title: 'Inovasi',

        onBack: () => Get.back(),
      ),

      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),

          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),

                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,

                padding: EdgeInsets.only(
                  left: isTablet ? 40.w : 16.w,
                  right: isTablet ? 40.w : 16.w,
                  top: 20.h,
                  bottom: media.viewInsets.bottom + 20.h,
                ),

                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isTablet ? 650 : double.infinity,
                      minHeight: constraints.maxHeight,
                    ),

                    child: Form(
                      key: _formKey,

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          SizedBox(height: 6.h),

                          /// ================= HEADER =================
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20.r),

                            child: Image.asset(
                              'assets/images/header_inovasi.png',

                              width: double.infinity,

                              fit: BoxFit.cover,
                            ),
                          ),

                          SizedBox(height: 30.h),

                          /// ================= KATEGORI =================
                          TypographyStyles.bodyCaptionSemiBold(
                            'Kategori Inovasi',

                            color: TextColors.grey900,
                          ),

                          SizedBox(height: 12.h),

                          KategoriDropdown(
                            value: selectedKategori,

                            onChanged: (value) {
                              setState(() {
                                selectedKategori = value;
                              });
                            },
                          ),

                          SizedBox(height: 24.h),

                          /// ================= JENIS =================
                          TypographyStyles.bodyCaptionSemiBold(
                            'Jenis Laporan',

                            color: TextColors.grey900,
                          ),

                          SizedBox(height: 12.h),

                          JenisLaporanDropdown(
                            value: selectedJenisLaporan,

                            onChanged: (value) {
                              setState(() {
                                selectedJenisLaporan = value;
                              });
                            },
                          ),

                          SizedBox(height: 30.h),

                          /// ================= INFO =================
                          Container(
                            padding: EdgeInsets.all(16.w),

                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,

                              borderRadius: BorderRadius.circular(14.r),
                            ),

                            child: Row(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,

                              children: [
                                Container(
                                  padding: EdgeInsets.all(10.w),

                                  decoration: BoxDecoration(
                                    color: Colors.white,

                                    borderRadius:
                                        BorderRadius.circular(10.r),
                                  ),

                                  child: Icon(
                                    Icons.info_outline,

                                    color: const Color(0xFF2F80B7),

                                    size: 24.w,
                                  ),
                                ),

                                SizedBox(width: 12.w),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,

                                    children: [
                                      Text(
                                        'Informasi',

                                        style: TextStyle(
                                          fontSize: 14.sp,

                                          fontWeight: FontWeight.bold,

                                          color: TextColors.grey900,
                                        ),
                                      ),

                                      SizedBox(height: 4.h),

                                      Text(
                                        'Pastikan kategori dan jenis laporan sudah sesuai sebelum melanjutkan proses pengisian data.',

                                        style: TextStyle(
                                          fontSize: 13.sp,

                                          color: TextColors.grey600,

                                          height: 1.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 30.h),

                          /// ================= BUTTON =================
                          ButtonFill(
                            text: 'Lanjut',

                            textColor: Colors.white,

                            onPressed: () {
                              /// VALIDASI KATEGORI
                              if (selectedKategori == null) {
                                Get.snackbar(
                                  'Error',

                                  'Pilih kategori terlebih dahulu',

                                  snackPosition:
                                      SnackPosition.TOP,

                                  backgroundColor: Colors.red,

                                  colorText: Colors.white,
                                );

                                return;
                              }

                              /// VALIDASI JENIS
                              if (selectedJenisLaporan == null) {
                                Get.snackbar(
                                  'Error',

                                  'Pilih jenis laporan terlebih dahulu',

                                  snackPosition:
                                      SnackPosition.TOP,

                                  backgroundColor: Colors.red,

                                  colorText: Colors.white,
                                );

                                return;
                              }

                              /// ================= REKAP DESA =================

                              if (selectedJenisLaporan ==
                                  'Rekap Desa Per Bulan') {
                                Get.toNamed(
                                  Routes.REKAP_DESA_1,

                                  arguments: {
                                    'kategori':
                                        selectedKategori!,
                                  },
                                );
                              }

                              if (selectedJenisLaporan ==
                                  'Rekap Desa Per Tahun') {
                                Get.toNamed(
                                  Routes.REKAP_DESA_TAHUNAN_1,

                                  arguments: {
                                    'kategori':
                                        selectedKategori!,
                                  },
                                );
                              }

                              if (selectedJenisLaporan ==
                                  'Rekap Posyandu') {
                                Get.toNamed(
                                  Routes.POSYANDU_1,

                                  arguments: {
                                    'kategori':
                                        selectedKategori!,
                                  },
                                );
                              }

                              if (selectedJenisLaporan ==
                                  'Kegiatan Pokja 4') {
                                Get.toNamed(
                                  Routes.KEGIATAN_POKJA4_1,

                                  arguments: {
                                    'kategori':
                                        selectedKategori!,
                                  },
                                );
                              }
                            },
                          ),

                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}