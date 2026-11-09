import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:epkk_nganjuk/features/akun/bantuan_screen.dart';
import 'package:epkk_nganjuk/features/akun/profile_controller.dart';
import 'package:epkk_nganjuk/services/preferences/preferences_service.dart';

class AdminContactHelper {
  static Future<void> hubungiAdminWhatsApp(BuildContext context) async {
    String userName = '';
    String userPhone = '';
    String userRole = '';

    try {
      final user = await PreferencesService.getUser();
      if (user != null) {
        userName = user.fullName;
        userPhone = user.phoneNumber;
        userRole = user.role?.name ?? '';
      } else if (Get.isRegistered<ProfilController>()) {
        final profil = Get.find<ProfilController>().profilData.value;
        userName = profil.fullName;
        userPhone = profil.phoneNumber;
        userRole = profil.idRole == '1'
            ? 'Desa'
            : (profil.idRole == '2' ? 'Kecamatan' : '');
      }
    } catch (_) {}

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

      if (!berhasil) {
        _tampilkanGagalBukaWhatsApp(cleanNumber);
      }
    } catch (_) {
      _tampilkanGagalBukaWhatsApp(cleanNumber);
    }
  }

  static void _tampilkanDialogNomorBelumTersedia() {
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
                  fontFamily: 'DMSans',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Nomor WhatsApp admin saat ini belum diatur di dalam sistem.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'DMSans',
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
                      fontFamily: 'DMSans',
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

  static void _tampilkanGagalBukaWhatsApp(String nomor) {
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
                  fontFamily: 'DMSans',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Aplikasi WhatsApp tidak ditemukan atau tautan tidak dapat dibuka di perangkat ini. Anda dapat menyalin nomor admin di bawah ini.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'DMSans',
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
                    fontFamily: 'DMSans',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
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
                          fontFamily: 'DMSans',
                          color: Colors.grey.shade700,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: Icon(
                        Icons.copy_rounded,
                        size: 16.sp,
                        color: Colors.white,
                      ),
                      label: Text(
                        'Salin Nomor',
                        style: TextStyle(
                          fontFamily: 'DMSans',
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
}
