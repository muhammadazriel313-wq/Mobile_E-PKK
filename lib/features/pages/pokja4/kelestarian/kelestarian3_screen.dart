import 'package:epkk_nganjuk/common/appbar/custom_appbar.dart';
import 'package:epkk_nganjuk/common/colors.dart';
import 'package:epkk_nganjuk/common/typography.dart';
import 'package:epkk_nganjuk/features/auth/button/button_file.dart';
import 'package:epkk_nganjuk/features/pages/pokja4/kelestarian/kelestarian_controller.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class Kelestarian3Screen extends StatefulWidget {
  const Kelestarian3Screen({super.key});

  @override
  State<Kelestarian3Screen> createState() => _Kelestarian3ScreenState();
}

class _Kelestarian3ScreenState extends State<Kelestarian3Screen> {
  final KelestarianController uploadController = Get.put(
    KelestarianController(),
  );

  late Map<String, dynamic> data;

  @override
  void initState() {
    super.initState();

    data = Get.arguments;
  }

  Widget _row(String label, String? value) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Expanded(
                child: Text(
                  label,

                  style: TextStyle(fontSize: 13.sp, color: TextColors.grey600),
                ),
              ),

              SizedBox(width: 12.w),

              Text(
                value ?? '0',

                style: TextStyle(
                  fontSize: 13.sp,

                  fontWeight: FontWeight.w600,

                  color: TextColors.grey900,
                ),
              ),
            ],
          ),
        ),

        Divider(color: Colors.grey.shade300, height: 1),
      ],
    );
  }

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

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    final isTablet = media.size.width >= 600;

    return Scaffold(
      resizeToAvoidBottomInset: true,

      backgroundColor: Colors.white,

      appBar: AppBarSecondary(
        title: 'Kelestarian Lingkungan Hidup',

        currentStep: 3,

        totalSteps: 3,

        onBack: () => Get.back(),
      ),

      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),

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
                                      fontSize: 14.sp,

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
                                border: Border.all(color: Colors.grey.shade300),

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
                            // ================= SECTION 1 =================
                            _section('Jumlah Rumah Yang Memiliki', [
                              _row('Jamban', data['jamban']),

                              _row('SPAL', data['spal']),

                              _row('Tempat Pembuangan Sampah', data['tps']),

                              _row('Jumlah MCK', data['mck']),
                            ]),

                            // ================= SECTION 2 =================
                            _section('Jumlah KART Yang Menggunakan Air', [
                              _row('PDAM', data['pdam']),

                              _row('Sumur', data['sumur']),

                              _row('Lain-lain', data['dll']),
                            ]),
                          ],
                        ),
                      ),

                      SizedBox(height: 20.h),

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
                                  await uploadController.submitKelestarianData(
                                    idUser: data['id_user'],

                                    jamban: data['jamban'],

                                    spal: data['spal'],

                                    tps: data['tps'],

                                    mck: data['mck'],

                                    pdam: data['pdam'],

                                    sumur: data['sumur'],

                                    lainnya: data['dll'],

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
}
