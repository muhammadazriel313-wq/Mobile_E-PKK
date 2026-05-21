/// =======================================================
/// FILE : posyandu_5_screen.dart
/// =======================================================

import 'package:epkk_nganjuk/common/appbar/custom_appbar.dart';
import 'package:epkk_nganjuk/common/colors.dart';
import 'package:epkk_nganjuk/features/auth/button/button_file.dart';
import 'package:epkk_nganjuk/features/pages/pokja4/inovasi/posyandu/posyandu_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class Posyandu5Screen extends StatefulWidget {
  const Posyandu5Screen({super.key});

  @override
  State<Posyandu5Screen> createState() => _Posyandu5ScreenState();
}

class _Posyandu5ScreenState extends State<Posyandu5Screen> {
  /// ================= CONTROLLER =================

  final PosyanduController controller = Get.put(PosyanduController());

  /// ================= ARGUMENT =================

  Map<String, dynamic> data = {};

  /// ================= SAFE =================

  String safe(dynamic value, {String defaultValue = ''}) {
    if (value == null) return defaultValue;

    return value.toString();
  }

  @override
  void initState() {
    super.initState();

    final args = Get.arguments;

    if (args != null && args is Map<String, dynamic>) {
      data = args;
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    final isTablet = media.size.width >= 600;

    return Scaffold(
      resizeToAvoidBottomInset: true,

      backgroundColor: Colors.white,

      appBar: AppBarSecondary(
        title: 'Posyandu',

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
                      maxWidth: isTablet ? 650 : double.infinity,

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
                                entry.key,

                                entry.value?.toString() ?? '',
                              );
                            }).toList(),
                          ),
                        ),

                        SizedBox(height: 30.h),

                        /// ================= BUTTON =================
                        ZoomTapAnimation(
                          child: Obx(
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
                                          .submitDataPosyandu(
                                            kategori: safe(data['kategori']),

                                            bulan: safe(data['bulan']),

                                            jmlIbuHamil: safe(
                                              data['jml_ibu_hamil'],
                                              defaultValue: '0',
                                            ),

                                            diperiksa: safe(
                                              data['diperiksa'],
                                              defaultValue: '0',
                                            ),

                                            feTabletDarah: safe(
                                              data['fe_tablet_darah'],
                                              defaultValue: '0',
                                            ),

                                            jmlIbuMenyusui: safe(
                                              data['jml_ibu_menyusui'],
                                              defaultValue: '0',
                                            ),

                                            kondom: safe(
                                              data['kondom'],
                                              defaultValue: '0',
                                            ),

                                            pil: safe(
                                              data['pil'],
                                              defaultValue: '0',
                                            ),

                                            implant: safe(
                                              data['implant'],
                                              defaultValue: '0',
                                            ),

                                            mop: safe(
                                              data['mop'],
                                              defaultValue: '0',
                                            ),

                                            mow: safe(
                                              data['mow'],
                                              defaultValue: '0',
                                            ),

                                            iud: safe(
                                              data['iud'],
                                              defaultValue: '0',
                                            ),

                                            suntikan: safe(
                                              data['suntikan'],
                                              defaultValue: '0',
                                            ),

                                            lainLainKb: safe(
                                              data['lain_lain_kb'],
                                              defaultValue: '0',
                                            ),

                                            jmlBalitaL: safe(
                                              data['jml_balita_l'],
                                              defaultValue: '0',
                                            ),

                                            jmlBalitaP: safe(
                                              data['jml_balita_p'],
                                              defaultValue: '0',
                                            ),

                                            bukuKiaL: safe(
                                              data['buku_kia_l'],
                                              defaultValue: '0',
                                            ),

                                            bukuKiaP: safe(
                                              data['buku_kia_p'],
                                              defaultValue: '0',
                                            ),

                                            datangL: safe(
                                              data['datang_l'],
                                              defaultValue: '0',
                                            ),

                                            datangP: safe(
                                              data['datang_p'],
                                              defaultValue: '0',
                                            ),

                                            naikL: safe(
                                              data['naik_l'],
                                              defaultValue: '0',
                                            ),

                                            naikP: safe(
                                              data['naik_p'],
                                              defaultValue: '0',
                                            ),

                                            vitAL: safe(
                                              data['vit_a_l'],
                                              defaultValue: '0',
                                            ),

                                            vitAP: safe(
                                              data['vit_a_p'],
                                              defaultValue: '0',
                                            ),

                                            pmtL: safe(
                                              data['pmt_l'],
                                              defaultValue: '0',
                                            ),

                                            pmtP: safe(
                                              data['pmt_p'],
                                              defaultValue: '0',
                                            ),

                                            imunisasiTt1: safe(
                                              data['imunisasi_tt_1'],
                                              defaultValue: '0',
                                            ),

                                            imunisasiTt2: safe(
                                              data['imunisasi_tt_2'],
                                              defaultValue: '0',
                                            ),
                                          );

                                      if (success) {
                                        data.clear();

                                        Get.offAllNamed('/main');
                                      }
                                    },
                            ),
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
    String finalLabel = label
        .replaceAll('_', ' ')
        .split(' ')
        .map(
          (word) => word.isNotEmpty
              ? '${word[0].toUpperCase()}${word.substring(1)}'
              : '',
        )
        .join(' ');

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),

          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Expanded(
                flex: 2,

                child: Text(
                  finalLabel,

                  style: TextStyle(fontSize: 13.sp, color: TextColors.grey600),
                ),
              ),

              SizedBox(width: 16.w),

              Expanded(
                flex: 1,

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
