import 'package:epkk_nganjuk/common/appbar/custom_appbar.dart';
import 'package:epkk_nganjuk/common/colors.dart';
import 'package:epkk_nganjuk/common/typography.dart';
import 'package:epkk_nganjuk/features/auth/button/button_file.dart';
import 'package:epkk_nganjuk/features/pages/pokja3/pangan/pangan_controller.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class Pangan3Screen extends StatefulWidget {
  const Pangan3Screen({super.key});

  @override
  State<Pangan3Screen> createState() => _Pangan3ScreenState();
}

class _Pangan3ScreenState extends State<Pangan3Screen> {
  final PanganController uploadController = Get.find<PanganController>();

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
        title: 'Pangan',

        currentStep: 3,

        totalSteps: 3,

        onBack: () => Get.back(),
      ),

      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),

              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,

              padding: EdgeInsets.only(
                left: isTablet ? 40.w : 16.w,

                right: isTablet ? 40.w : 16.w,

                top: 20.h,

                bottom: 20.h,
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
                      // ================= WARNING =================
                      Container(
                        padding: EdgeInsets.all(16.w),

                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,

                          borderRadius: BorderRadius.circular(12.r),
                        ),

                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,

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

                                size: 30.w,
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
                                      fontSize: 13.sp,

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

                      // ================= HEADER =================
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          Expanded(
                            child: Text(
                              'Detail Laporan',

                              style: TextStyle(
                                fontSize: 18.sp,

                                fontWeight: FontWeight.bold,

                                color: TextColors.grey900,
                              ),
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
                                border: Border.all(color: Colors.grey.shade300),

                                borderRadius: BorderRadius.circular(8.r),
                              ),

                              child: Row(
                                mainAxisSize: MainAxisSize.min,

                                children: [
                                  Icon(
                                    Icons.edit,

                                    size: 18.sp,

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

                      // ================= CARD =================
                      Container(
                        padding: EdgeInsets.all(16.w),

                        decoration: BoxDecoration(
                          color: Colors.white,

                          borderRadius: BorderRadius.circular(12.r),

                          border: Border.all(color: Colors.grey.shade300),
                        ),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            /// MAKANAN POKOK
                            _section('Makanan Pokok', [
                              _row('Beras', data['beras']),

                              _row('Non Beras', data['non_beras']),
                            ]),

                            /// PEKARANGAN
                            _section('Pemanfaatan Pekarangan', [
                              _row('Peternakan', data['peternakan']),

                              _row('Perikanan', data['perikanan']),

                              _row('Warung Hidup', data['warung_hidup']),

                              _row('Lumbung Hidup', data['lumbung_hidup']),

                              _row('TOGA', data['toga']),

                              _row('Tanaman Keras', data['tanaman_keras']),

                              _row(
                                'Tanaman Lainnya',

                                data['tanaman_lainnya'] ?? '0',
                              ),
                            ]),
                          ],
                        ),
                      ),

                      SizedBox(height: 24.h),

                      // ================= BUTTON =================
                      Obx(
                        () => ButtonFill(
                          text: uploadController.isLoading.value
                              ? 'Loading...'
                              : 'Kirim',

                          textColor: Colors.white,

                          onPressed: uploadController.isLoading.value
                              ? null
                              : () async {
                                  await uploadController.submitDataPangan(
                                    idUser: data['id_user'],

                                    beras: data['beras'],

                                    nonBeras: data['non_beras'],

                                    peternakan: data['peternakan'],

                                    perikanan: data['perikanan'],

                                    warungHidup: data['warung_hidup'],

                                    lumbungHidup: data['lumbung_hidup'],

                                    toga: data['toga'],

                                    tanamanKeras: data['tanaman_keras'],

                                    tanamanLainnya: data['tanaman_lainnya'],

                                    idRole: data['id_role'],

                                    idOrganization: data['id_organization'],
                                  );

                                  if (uploadController.reportData.value !=
                                          null &&
                                      uploadController
                                              .reportData
                                              .value!
                                              .statusCode ==
                                          200) {
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
    );
  }

  // ================= ROW =================
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

  // ================= SECTION =================
  Widget _section(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        SizedBox(height: 12.h),

        TypographyStyles.bodyCaptionSemiBold(title, color: TextColors.grey900),

        SizedBox(height: 8.h),

        ...children,
      ],
    );
  }
}
