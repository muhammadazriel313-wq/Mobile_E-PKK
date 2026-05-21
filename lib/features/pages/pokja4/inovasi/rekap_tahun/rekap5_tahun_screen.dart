/// =======================================================
/// FILE : rekap_desa_tahunan_5_screen.dart
/// =======================================================

import 'package:epkk_nganjuk/common/appbar/custom_appbar.dart';
import 'package:epkk_nganjuk/common/colors.dart';
import 'package:epkk_nganjuk/features/auth/button/button_file.dart';
import 'package:epkk_nganjuk/features/pages/pokja4/inovasi/rekap_tahun/rekap_tahun_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class RekapDesaTahunan5Screen extends StatefulWidget {
  const RekapDesaTahunan5Screen({super.key});

  @override
  State<RekapDesaTahunan5Screen> createState() =>
      _RekapDesaTahunan5ScreenState();
}

class _RekapDesaTahunan5ScreenState extends State<RekapDesaTahunan5Screen> {
  /// ================= CONTROLLER =================

  final RekapDesaTahunanController controller = Get.put(
    RekapDesaTahunanController(),
  );

  /// ================= ARGUMENT =================

  late Map<String, dynamic> data;

  @override
  void initState() {
    super.initState();

    data = Get.arguments;
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    final isTablet = media.size.width >= 600;

    return Scaffold(
      resizeToAvoidBottomInset: true,

      backgroundColor: Colors.white,

      appBar: AppBarSecondary(
        title: 'Rekap Desa Tahunan',

        currentStep: 5,

        totalSteps: 5,

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
                    ScrollViewKeyboardDismissBehavior.manual,

                padding: EdgeInsets.only(
                  left: isTablet ? 40.w : 16.w,

                  right: isTablet ? 40.w : 16.w,

                  top: 20.h,

                  bottom: media.viewInsets.bottom + 20.h,
                ),

                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isTablet ? 700 : double.infinity,

                      minHeight: constraints.maxHeight,
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        /// ================= WARNING =================
                        Container(
                          padding: EdgeInsets.all(16.w),

                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,

                            borderRadius: BorderRadius.circular(12.r),
                          ),

                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(10.w),

                                decoration: BoxDecoration(
                                  color: Colors.white,

                                  borderRadius: BorderRadius.circular(10.r),
                                ),

                                child: Icon(
                                  Icons.search,

                                  color: const Color(0xFF2F80B7),

                                  size: 28.w,
                                ),
                              ),

                              SizedBox(width: 12.w),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [
                                    Text(
                                      'Pastikan data yang Anda masukkan sudah benar !!!',

                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,

                                        fontSize: 15.sp,

                                        color: TextColors.grey900,
                                      ),
                                    ),

                                    SizedBox(height: 4.h),

                                    Text(
                                      'Jika terdapat kesalahan, silakan lakukan perbaikan pada halaman ini.',

                                      style: TextStyle(
                                        fontSize: 15.sp,

                                        color: TextColors.grey600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 24.h),

                        /// ================= HEADER =================
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            Text(
                              'Detail Laporan',

                              style: TextStyle(
                                fontSize: 18.sp,

                                fontWeight: FontWeight.bold,

                                color: TextColors.grey900,
                              ),
                            ),

                            GestureDetector(
                              onTap: () => Get.back(),

                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,

                                  vertical: 6.h,
                                ),

                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),

                                  borderRadius: BorderRadius.circular(8.r),
                                ),

                                child: Row(
                                  mainAxisSize: MainAxisSize.min,

                                  children: [
                                    Icon(
                                      Icons.edit,

                                      size: 18.w,

                                      color: const Color(0xFF2F80B7),
                                    ),

                                    SizedBox(width: 6.w),

                                    Text(
                                      'Edit',

                                      style: TextStyle(
                                        fontSize: 13.sp,

                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 16.h),

                        /// ================= CARD =================
                        Container(
                          padding: EdgeInsets.all(16.w),

                          decoration: BoxDecoration(
                            color: Colors.white,

                            borderRadius: BorderRadius.circular(12.r),

                            border: Border.all(color: Colors.grey.shade300),
                          ),

                          child: Column(
                            children: data.entries.map((entry) {
                              return _row(
                                entry.key.replaceAll('_', ' '),

                                entry.value.toString(),
                              );
                            }).toList(),
                          ),
                        ),

                        SizedBox(height: 30.h),

                        /// ================= BUTTON =================
                        Obx(
                          () => ButtonFill(
                            text: controller.isLoading.value
                                ? 'Loading...'
                                : 'Kirim',

                            textColor: Colors.white,

                            isLoading: controller.isLoading.value,

                            onPressed: controller.isLoading.value
                                ? null
                                : () async {
                                    final success = await controller
                                        .submitDataRekapDesaTahunan(
                                          kategori: data['kategori'],

                                          kaderKesehatan:
                                              data['kader_kesehatan'],

                                          gizi: data['gizi'],

                                          kesling: data['kesling'],

                                          phbs: data['phbs'],

                                          kb: data['kb'],

                                          posyandu: data['posyandu'],

                                          imunisasiVaksinasiBayiBalita:
                                              data['imunisasi_vaksinasi_bayi_balita'],

                                          pkg: data['pkg'],

                                          tbc: data['tbc'],

                                          jambanWc: data['jamban_wc'],

                                          spal: data['spal'],

                                          tps: data['tps'],

                                          jumlahMck: data['jumlah_mck'],

                                          pdam: data['pdam'],

                                          sumur: data['sumur'],

                                          lainLain: data['lain_lain'],

                                          jmlPus: data['jml_pus'],

                                          jmlWus: data['jml_wus'],

                                          akseptorKbL: data['akseptor_kb_l'],

                                          akseptorKbP: data['akseptor_kb_p'],

                                          jmlKkTabungan:
                                              data['jml_kk_tabungan'],

                                          jmlKkAsuransi:
                                              data['jml_kk_asuransi'],

                                          kesehatanProgram:
                                              data['kesehatan_program'],

                                          kelestarianLingkunganHidup:
                                              data['kelestarian_lingkungan_hidup'],

                                          perencanaanSehatProgram:
                                              data['perencanaan_sehat_program'],
                                        );

                                    /// ================= SUCCESS =================

                                    if (success) {
                                      data.clear();

                                      Get.offAllNamed('/main');
                                    }
                                  },
                          ),
                        ),

                        SizedBox(height: 20.h),
                      ],
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

  /// ================= ROW =================

  Widget _row(String label, String? value) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),

          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,

            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Expanded(
                flex: 2,

                child: Text(
                  label,

                  style: TextStyle(fontSize: 13.sp, color: TextColors.grey600),
                ),
              ),

              SizedBox(width: 12.w),

              Expanded(
                child: Text(
                  value ?? '0',

                  textAlign: TextAlign.end,

                  style: TextStyle(
                    fontSize: 13.sp,

                    fontWeight: FontWeight.w600,

                    color: TextColors.grey900,
                  ),
                ),
              ),
            ],
          ),
        ),

        Divider(color: Colors.grey.shade300, height: 1),
      ],
    );
  }
}
