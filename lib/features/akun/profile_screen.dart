import 'package:epkk_nganjuk/common/appbar/custom_appbar.dart';
import 'package:epkk_nganjuk/common/colors.dart';
import 'package:epkk_nganjuk/common/component/card_profil_button.dart';
import 'package:epkk_nganjuk/features/akun/profile_controller.dart';
import 'package:epkk_nganjuk/features/auth/auth_controller.dart';
import 'package:epkk_nganjuk/features/home/nav_controller.dart';
import 'package:epkk_nganjuk/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AkunPage extends StatelessWidget {
  AkunPage({super.key});

  final ProfilController profilController = Get.find<ProfilController>();
  final AuthController authController = Get.find<AuthController>();

  String getOrganizationName(String? id) {
    print('ID ORGANIZATION : $id');

    final organizations = {
      '1': 'Kader Pokja I',
      '2': 'Kader Pokja II',
      '3': 'Kader Pokja III',
      '4': 'Kader Pokja IV',
      '5': 'Bidang Umum',
    };

    return organizations[id?.trim()] ?? 'Anggota PKK';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TextColors.grey50,

      appBar: AppBarPrimary(
        title: 'Profil',
        backgroundColor: Colors.white,

        onBack: () {
          final NavController navController = Get.find<NavController>();

          navController.changeTabIndex(0);
        },
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),

          child: Column(
            children: [
              // HEADER PROFILE
              Obx(() {
                final profil = profilController.profilData.value;

                return Container(
                  width: double.infinity,

                  padding: EdgeInsets.symmetric(
                    vertical: 24.h,
                    horizontal: 20.w,
                  ),

                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF3F8FC1), Color(0xFF66A9D2)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),

                    borderRadius: BorderRadius.circular(24.r),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),

                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 42.r,
                        backgroundColor: Colors.white,

                        child: Icon(
                          Icons.person,
                          size: 50.sp,
                          color: const Color(0xFF3F8FC1),
                        ),
                      ),

                      SizedBox(height: 14.h),

                      Text(
                        profil.fullName.isEmpty ? 'Pengguna' : profil.fullName,

                        textAlign: TextAlign.center,

                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      SizedBox(height: 6.h),

                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 6.h,
                        ),

                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),

                          borderRadius: BorderRadius.circular(30.r),

                          border: Border.all(
                            color: Colors.white.withOpacity(0.25),
                          ),
                        ),

                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.groups_rounded,
                              color: Colors.white,
                              size: 16.sp,
                            ),

                            SizedBox(width: 6.w),

                            Text(
                              getOrganizationName(profil.idOrganization.trim()),

                              style: TextStyle(
                                fontSize: 13.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),

              SizedBox(height: 28.h),

              // MENU CARD
              Container(
                padding: EdgeInsets.all(16.w),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22.r),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),

                child: Column(
                  children: [
                    // INFORMASI AKUN
                    CardButtonRow(
                      leadingIcon: Icons.person_outline,
                      titleText: 'Informasi Akun',

                      onTap: () {
                        Get.toNamed(Routes.INFO_AKUN);
                      },

                      backgroundColor: Colors.white,
                      strokeColor: Colors.grey.shade200,
                      iconColor: const Color(0xFF3F8FC1),
                    ),

                    SizedBox(height: 14.h),

                    // UBAH PASSWORD
                    CardButtonRow(
                      leadingIcon: Icons.lock_outline,
                      titleText: 'Ubah Kata Sandi',

                      onTap: () {
                        Get.toNamed(Routes.EDIT_PASSWORD);
                      },

                      backgroundColor: Colors.white,
                      strokeColor: Colors.grey.shade200,
                      iconColor: const Color(0xFF3F8FC1),
                    ),

                    SizedBox(height: 14.h),

                    // LOGOUT
                    CardButtonRow(
                      leadingIcon: Icons.logout_rounded,
                      titleText: 'Keluar',

                      onTap: () {
                        Get.dialog(
                          Dialog(
                            backgroundColor: Colors.white,

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.r),
                            ),

                            child: Padding(
                              padding: EdgeInsets.all(20.w),

                              child: Column(
                                mainAxisSize: MainAxisSize.min,

                                children: [
                                  /// ICON
                                  Container(
                                    padding: EdgeInsets.all(16.w),

                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFF3F8FC1,
                                      ).withOpacity(0.1),

                                      shape: BoxShape.circle,
                                    ),

                                    child: Icon(
                                      Icons.logout_rounded,
                                      color: const Color(0xFF3F8FC1),
                                      size: 34.sp,
                                    ),
                                  ),

                                  SizedBox(height: 18.h),

                                  /// TITLE
                                  Text(
                                    'Keluar Aplikasi',

                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),

                                  SizedBox(height: 8.h),

                                  /// DESC
                                  Text(
                                    'Apakah anda yakin ingin keluar dari aplikasi?',

                                    textAlign: TextAlign.center,

                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: Colors.grey.shade600,
                                      height: 1.5,
                                    ),
                                  ),

                                  SizedBox(height: 24.h),

                                  /// BUTTON
                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 14.h,
                                            ),

                                            side: BorderSide(
                                              color: Colors.grey.shade300,
                                            ),

                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(14.r),
                                            ),
                                          ),

                                          onPressed: () {
                                            Get.back();
                                          },

                                          child: Text(
                                            'Batal',

                                            style: TextStyle(
                                              color: Colors.grey.shade700,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13.sp,
                                            ),
                                          ),
                                        ),
                                      ),

                                      SizedBox(width: 12.w),

                                      Expanded(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            elevation: 0,

                                            backgroundColor: const Color(
                                              0xFF3F8FC1,
                                            ),

                                            padding: EdgeInsets.symmetric(
                                              vertical: 14.h,
                                            ),

                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(14.r),
                                            ),
                                          ),

                                          onPressed: () {
                                            authController.logout();
                                          },

                                          child: Text(
                                            'Keluar',

                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13.sp,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },

                      backgroundColor: Colors.red.shade50,
                      strokeColor: Colors.red.shade100,
                      iconColor: Colors.red.shade400,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
