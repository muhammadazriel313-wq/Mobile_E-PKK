import 'package:epkk_nganjuk/common/colors.dart';
import 'package:epkk_nganjuk/common/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DraftExitDialog {
  /// Dialog konfirmasi keluar saat ada isian form yang belum disimpan/dikirim
  /// Mengembalikan true jika pengguna memilih untuk keluar (baik setelah simpan atau buang),
  /// atau false jika pengguna memilih untuk tetap lanjut mengisi.
  static Future<bool> show({
    required BuildContext context,
    required Future<void> Function() onSaveDraft,
  }) async {
    final result = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          backgroundColor: Colors.white,
          titlePadding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 8.h),
          contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
          actionsPadding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
          title: Row(
            children: [
              Icon(Icons.help_outline_rounded, color: BrandColors.brandPrimary25, size: 24.sp),
              SizedBox(width: 8.w),
              Expanded(
                child: TypographyStyles.bodyCaptionBold(
                  'Simpan sebagai draf?',
                  color: TextColors.grey800,
                ),
              ),
            ],
          ),
          content: TypographyStyles.bodyCaptionReguler(
            'Isian form Anda belum dikirim. Anda dapat menyimpannya sebagai draf di HP dan mengirimkannya nanti saat sinyal bagus.',
            color: TextColors.grey600,
            overflow: TextOverflow.visible,
          ),
          actions: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Tombol Simpan Draf (Tinggi minimal 48 px untuk kenyamanan sentuhan)
                ElevatedButton(
                  onPressed: () => Navigator.of(ctx).pop('save'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: BrandColors.brandPrimary25,
                    elevation: 0,
                    minimumSize: Size(double.infinity, 48.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                  ),
                  child: TypographyStyles.button(
                    'Simpan Draf',
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8.h),
                // Tombol Buang & Lanjut Mengisi
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(ctx).pop('discard'),
                        style: OutlinedButton.styleFrom(
                          minimumSize: Size(double.infinity, 48.h),
                          side: BorderSide(color: const Color(0xFFEF5350), width: 1.w),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.r),
                          ),
                        ),
                        child: TypographyStyles.button(
                          'Buang',
                          color: const Color(0xFFEF5350),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.of(ctx).pop('cancel'),
                        style: TextButton.styleFrom(
                          minimumSize: Size(double.infinity, 48.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.r),
                          ),
                        ),
                        child: TypographyStyles.button(
                          'Lanjut Mengisi',
                          color: TextColors.grey700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );

    if (result == 'save') {
      await onSaveDraft();
      return true; // keluar setelah berhasil disimpan
    } else if (result == 'discard') {
      return true; // buang isian dan keluar
    } else {
      return false; // tetap berada di form
    }
  }
}
