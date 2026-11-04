import 'package:epkk_nganjuk/common/colors.dart';
import 'package:epkk_nganjuk/common/typography.dart';
import 'package:epkk_nganjuk/features/draft/draft_controller.dart';
import 'package:epkk_nganjuk/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

enum DraftScope { laporan, galeri }

class DraftBadgeIcon extends StatelessWidget {
  final DraftScope scope;
  final Map<String, dynamic>? arguments;

  const DraftBadgeIcon({
    super.key,
    required this.scope,
    this.arguments,
  });

  @override
  Widget build(BuildContext context) {
    final DraftController draftController = Get.isRegistered<DraftController>()
        ? Get.find<DraftController>()
        : Get.put(DraftController());

    final filterJenis = (scope == DraftScope.laporan)
        ? DraftController.jenisLaporan
        : DraftController.jenisGaleri;

    final title = (scope == DraftScope.laporan) ? 'Draf Laporan' : 'Draf Galeri';

    return Center(
      child: Tooltip(
        message: 'Draf Saya',
        child: Semantics(
          label: 'Draf Saya',
          button: true,
          child: Container(
            margin: EdgeInsets.only(right: 16.w),
            decoration: BoxDecoration(
              color: TextColors.grey50,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                strokeAlign: 1,
                color: TextColors.grey200,
              ),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  onPressed: () async {
                    await Get.toNamed(
                      Routes.DRAFT_LIST,
                      arguments: {
                        'title': title,
                        'filter_jenis': filterJenis,
                        'parent_args': arguments ?? {},
                      },
                    );
                    // Saat kembali dari Draf Saya, pastikan hitungan badge diperbarui
                    draftController.refreshAllCount();
                  },
                  icon: Icon(
                    Icons.edit_document,
                    color: TextColors.grey700,
                    size: 22.sp,
                  ),
                ),

                // Badge angka merah di pojok kanan atas
                Obx(() {
                  final count = (scope == DraftScope.laporan)
                      ? draftController.jumlahDraftLaporan.value
                      : draftController.jumlahDraftGaleri.value;

                  if (count <= 0) return const SizedBox.shrink();

                  final displayCount = count > 9 ? '9+' : '$count';

                  return Positioned(
                    top: -2.h,
                    right: -2.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: count > 9 ? 4.w : 5.w,
                        vertical: 2.h,
                      ),
                      constraints: BoxConstraints(
                        minWidth: 18.w,
                        minHeight: 18.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF5350), // merah cerah
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: Colors.white, width: 1.5.w),
                      ),
                      child: Center(
                        child: Text(
                          displayCount,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: TypographyStyles.fontFamily,
                            color: Colors.white,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                            height: 1.1,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

