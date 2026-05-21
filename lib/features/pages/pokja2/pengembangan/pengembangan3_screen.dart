import 'package:epkk_nganjuk/common/appbar/custom_appbar.dart';
import 'package:epkk_nganjuk/common/colors.dart';
import 'package:epkk_nganjuk/common/typography.dart';
import 'package:epkk_nganjuk/features/auth/button/button_file.dart';
import 'package:epkk_nganjuk/features/pages/pokja2/pengembangan/pengembangan_kehidupan_controller.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class Pengembangan3 extends StatelessWidget {
  const Pengembangan3({super.key});

  @override
  Widget build(BuildContext context) {
    final controller =
        Get.find<
          PengembanganKehidupanController
        >();

    final form = controller.form;

    final media =
        MediaQuery.of(context);

    final isTablet =
        media.size.width >= 600;

    return Scaffold(
      resizeToAvoidBottomInset: true,

      backgroundColor: Colors.white,

      appBar: AppBarSecondary(
        title:
            'Pengembangan Kehidupan Berkoperasi',

        currentStep: 3,

        totalSteps: 3,

        onBack: () => Get.back(),
      ),

      body: SafeArea(
        child: LayoutBuilder(
          builder:
              (context, constraints) {
            return SingleChildScrollView(
              physics:
                  const BouncingScrollPhysics(),

              keyboardDismissBehavior:
                  ScrollViewKeyboardDismissBehavior
                      .onDrag,

              padding: EdgeInsets.only(
                left:
                    isTablet ? 40.w : 16.w,

                right:
                    isTablet ? 40.w : 16.w,

                top: 20.h,

                bottom: 20.h,
              ),

              child: Center(
                child: ConstrainedBox(
                  constraints:
                      BoxConstraints(
                    maxWidth: isTablet
                        ? 700
                        : double.infinity,

                    minHeight:
                        constraints
                            .maxHeight,
                  ),

                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                    children: [
                      // ================= INFO BOX =================
                      Container(
                        padding:
                            EdgeInsets.all(
                                16.w),

                        decoration:
                            BoxDecoration(
                              color: Colors
                                  .grey
                                  .shade100,

                              borderRadius:
                                  BorderRadius.circular(
                                    12.r,
                                  ),
                            ),

                        child: Row(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,

                          children: [
                            Container(
                              padding:
                                  EdgeInsets.all(
                                    10.w,
                                  ),

                              decoration:
                                  BoxDecoration(
                                    color:
                                        Colors
                                            .white,

                                    borderRadius:
                                        BorderRadius.circular(
                                          10.r,
                                        ),
                                  ),

                              child: Icon(
                                Icons.search,

                                color:
                                    const Color.fromARGB(
                                      255,
                                      47,
                                      128,
                                      183,
                                    ),

                                size: 30.w,
                              ),
                            ),

                            SizedBox(
                                width: 12.w),

                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,

                                children: [
                                  Text(
                                    'Pastikan data yang Anda masukkan sudah benar !!!',

                                    style:
                                        TextStyle(
                                          fontWeight:
                                              FontWeight
                                                  .w600,

                                          fontSize:
                                              15.sp,

                                          color:
                                              TextColors
                                                  .grey900,
                                        ),
                                  ),

                                  SizedBox(
                                      height:
                                          4.h),

                                  Text(
                                    'Jika terdapat kesalahan, silakan lakukan perbaikan pada halaman ini.',

                                    style:
                                        TextStyle(
                                          fontSize:
                                              13.sp,

                                          color:
                                              TextColors
                                                  .grey600,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                          height: 24.h),

                      // ================= HEADER =================
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween,

                        children: [
                          Expanded(
                            child: Text(
                              'Detail Laporan',

                              style:
                                  TextStyle(
                                    fontSize:
                                        18.sp,

                                    fontWeight:
                                        FontWeight
                                            .bold,

                                    color:
                                        TextColors
                                            .grey900,
                                  ),
                            ),
                          ),

                          GestureDetector(
                            onTap:
                                () =>
                                    Get.back(),

                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal:
                                    10.w,

                                vertical:
                                    6.h,
                              ),

                              decoration:
                                  BoxDecoration(
                                    border: Border.all(
                                      color:
                                          Colors
                                              .grey
                                              .shade300,
                                    ),

                                    borderRadius:
                                        BorderRadius.circular(
                                          8.r,
                                        ),
                                  ),

                              child: Row(
                                mainAxisSize:
                                    MainAxisSize
                                        .min,

                                children: [
                                  Icon(
                                    Icons.edit,

                                    size:
                                        18.sp,

                                    color:
                                        const Color.fromARGB(
                                          255,
                                          47,
                                          128,
                                          183,
                                        ),
                                  ),

                                  SizedBox(
                                      width:
                                          6.w),

                                  Text(
                                    'Edit',

                                    style:
                                        TextStyle(
                                          fontSize:
                                              13.sp,

                                          fontWeight:
                                              FontWeight
                                                  .w500,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(
                          height: 16.h),

                      // ================= CARD =================
                      Container(
                        padding:
                            EdgeInsets.all(
                                16.w),

                        decoration:
                            BoxDecoration(
                              color:
                                  Colors.white,

                              borderRadius:
                                  BorderRadius.circular(
                                    12.r,
                                  ),

                              border: Border.all(
                                color: Colors
                                    .grey
                                    .shade300,
                              ),
                            ),

                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,

                          children: [
                            /// PRAKOPERASI
                            _section(
                              'Prakoperasi / Usaha Bersama / UP2K PKK',

                              [
                                _section(
                                  'Pemula',

                                  [
                                    _row(
                                      'Jumlah Kelompok',

                                      form
                                          .jumlahKelompokPemula,
                                    ),

                                    _row(
                                      'Jumlah Peserta',

                                      form
                                          .jumlahPesertaPemula,
                                    ),
                                  ],
                                ),

                                _section(
                                  'Madya',

                                  [
                                    _row(
                                      'Jumlah Kelompok',

                                      form
                                          .jumlahKelompokMadya,
                                    ),

                                    _row(
                                      'Jumlah Peserta',

                                      form
                                          .jumlahPesertaMadya,
                                    ),
                                  ],
                                ),

                                _section(
                                  'Utama',

                                  [
                                    _row(
                                      'Jumlah Kelompok',

                                      form
                                          .jumlahKelompokUtama,
                                    ),

                                    _row(
                                      'Jumlah Peserta',

                                      form
                                          .jumlahPesertaUtama,
                                    ),
                                  ],
                                ),

                                _section(
                                  'Mandiri',

                                  [
                                    _row(
                                      'Jumlah Kelompok',

                                      form
                                          .jumlahKelompokMandiri,
                                    ),

                                    _row(
                                      'Jumlah Peserta',

                                      form
                                          .jumlahPesertaMandiri,
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            /// KOPERASI
                            _section(
                              'Koperasi Berbadan Hukum',

                              [
                                _row(
                                  'Jumlah Kelompok',

                                  form
                                      .jumlahKelompokHukum,
                                ),

                                _row(
                                  'Jumlah Peserta',

                                  form
                                      .jumlahPesertaHukum,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                          height: 24.h),

                      // ================= BUTTON =================
                      ZoomTapAnimation(
                        child: Obx(
                          () => ButtonFill(
                            text: controller
                                    .isLoading
                                    .value
                                ? 'Loading...'
                                : 'Kirim',

                            textColor:
                                Colors.white,

                            onPressed:
                                controller
                                        .isLoading
                                        .value
                                    ? null
                                    : () async {
                                        final success =
                                            await controller
                                                .submit();

                                        if (success) {
                                          Get.offAllNamed(
                                            '/main',
                                          );
                                        }
                                      },
                          ),
                        ),
                      ),

                      SizedBox(
                          height: 20.h),
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
  Widget _row(
    String label,
    String value,
  ) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: 10.h,
          ),

          child: Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            mainAxisAlignment:
                MainAxisAlignment
                    .spaceBetween,

            children: [
              Expanded(
                flex: 2,

                child: Text(
                  label,

                  style: TextStyle(
                    fontSize: 13.sp,

                    color:
                        TextColors
                            .grey600,
                  ),
                ),
              ),

              SizedBox(width: 12.w),

              Expanded(
                child: Text(
                  value,

                  textAlign:
                      TextAlign.end,

                  style: TextStyle(
                    fontSize: 13.sp,

                    fontWeight:
                        FontWeight.w600,

                    color:
                        TextColors
                            .grey900,
                  ),
                ),
              ),
            ],
          ),
        ),

        Divider(
          color: Colors.grey.shade300,
          height: 1,
        ),
      ],
    );
  }

  // ================= SECTION =================
  Widget _section(
    String title,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [
        SizedBox(height: 12.h),

        TypographyStyles
            .bodyCaptionSemiBold(
          title,
          color: TextColors.grey900,
        ),

        SizedBox(height: 8.h),

        ...children,
      ],
    );
  }
}