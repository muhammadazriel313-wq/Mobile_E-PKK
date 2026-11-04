import 'package:epkk_nganjuk/common/appbar/custom_appbar.dart';
import 'package:epkk_nganjuk/common/colors.dart';
import 'package:epkk_nganjuk/common/typography.dart';
import 'package:epkk_nganjuk/features/auth/button/button_file.dart';
import 'package:epkk_nganjuk/features/draft/draft_controller.dart';
import 'package:epkk_nganjuk/features/draft/draft_model.dart';
import 'package:epkk_nganjuk/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DraftListScreen extends StatefulWidget {
  const DraftListScreen({super.key});

  @override
  State<DraftListScreen> createState() => _DraftListScreenState();
}

class _DraftListScreenState extends State<DraftListScreen> {
  final DraftController _draftController = Get.isRegistered<DraftController>()
      ? Get.find<DraftController>()
      : Get.put(DraftController());

  String _screenTitle = 'Draf Saya';
  List<String> _filterJenis = DraftController.jenisLaporan;
  Map<String, dynamic> _parentArgs = {};

  @override
  void initState() {
    super.initState();
    final args = Get.arguments ?? {};
    if (args['title'] != null) {
      _screenTitle = args['title'];
    }
    if (args['filter_jenis'] != null && args['filter_jenis'] is List<String>) {
      _filterJenis = args['filter_jenis'];
    }
    if (args['parent_args'] != null && args['parent_args'] is Map<String, dynamic>) {
      _parentArgs = args['parent_args'];
    }

    _draftController.loadDrafts(filterJenis: _filterJenis);
  }

  String _formatTanggal(String isoDate) {
    try {
      final dt = DateTime.parse(isoDate).toLocal();
      return DateFormat('dd MMM yyyy, HH:mm', 'id_ID').format(dt);
    } catch (_) {
      try {
        final dt = DateTime.parse(isoDate).toLocal();
        return DateFormat('dd MMM yyyy, HH:mm').format(dt);
      } catch (e) {
        return isoDate;
      }
    }
  }

  Widget _buildStatusBadge(String status) {
    Color bg;
    Color text;
    String label;

    switch (status) {
      case 'mengirim':
        bg = const Color(0xFFFFF3E0);
        text = const Color(0xFFF57C00); // oranye
        label = 'Mengirim';
        break;
      case 'gagal_kirim':
        bg = const Color(0xFFFFEBEE);
        text = const Color(0xFFD32F2F); // merah
        label = 'Gagal kirim';
        break;
      case 'draf':
      default:
        bg = const Color(0xFFE3F2FD);
        text = const Color(0xFF1976D2); // biru soft
        label = 'Draf';
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: TypographyStyles.fontFamily,
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: text,
        ),
      ),
    );
  }

  void _bukaFormEdit(DraftModel draft) async {
    if (draft.jenis == 'pancasila') {
      final formArgs = Map<String, dynamic>.from(_parentArgs);
      formArgs['draft'] = draft;
      await Get.toNamed(Routes.PENGHAYATAN, arguments: formArgs);
      // Refresh setelah kembali dari form edit
      _draftController.loadDrafts(filterJenis: _filterJenis);
    } else {
      Get.snackbar(
        'Segera Tersedia',
        'Edit untuk jenis ${draft.getJudulJenis()} akan segera aktif di tahap berikutnya.',
        backgroundColor: const Color(0xFF3F8FC1),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  void _konfirmasiHapus(DraftModel draft) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        backgroundColor: Colors.white,
        titlePadding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 8.h),
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
        actionsPadding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
        title: TypographyStyles.bodyCaptionBold(
          'Hapus Draf?',
          color: TextColors.grey800,
        ),
        content: TypographyStyles.bodyCaptionReguler(
          'Hapus draf ini? Isian dan foto di dalamnya akan hilang.',
          color: TextColors.grey600,
          overflow: TextOverflow.visible,
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Get.back(),
                  style: TextButton.styleFrom(
                    minimumSize: Size(double.infinity, 48.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                  ),
                  child: TypographyStyles.button(
                    'Batal',
                    color: TextColors.grey700,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    Get.back(); // tutup dialog
                    await _draftController.hapusDraft(draft.id, filterJenis: _filterJenis);
                    Get.snackbar(
                      'Draf Dihapus',
                      'Draf dan fotonya berhasil dihapus',
                      backgroundColor: const Color(0xFFEF5350),
                      colorText: Colors.white,
                      snackPosition: SnackPosition.TOP,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEF5350),
                    elevation: 0,
                    minimumSize: Size(double.infinity, 48.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                  ),
                  child: TypographyStyles.button(
                    'Hapus',
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBarPrimary(
        title: _screenTitle,
        onBack: () => Get.back(),
      ),
      body: SafeArea(
        child: Obx(() {
          if (_draftController.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final drafts = _draftController.daftarDraft;

          if (drafts.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.note_alt_outlined,
                      size: 64.sp,
                      color: TextColors.grey300,
                    ),
                    SizedBox(height: 16.h),
                    TypographyStyles.bodyCaptionBold(
                      'Belum ada draf',
                      color: TextColors.grey700,
                    ),
                    SizedBox(height: 8.h),
                    TypographyStyles.bodyCaptionReguler(
                      'Draf yang Anda simpan akan muncul di sini.',
                      textAlign: TextAlign.center,
                      color: TextColors.grey500,
                      overflow: TextOverflow.visible,
                    ),
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => _draftController.loadDrafts(filterJenis: _filterJenis),
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              itemCount: drafts.length,
              separatorBuilder: (context, index) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                final item = drafts[index];
                return _buildDraftCard(item);
              },
            ),
          );
        }),
      ),
    );
  }

  Widget _buildDraftCard(DraftModel draft) {
    return InkWell(
      onTap: () => _bukaFormEdit(draft),
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: TextColors.grey200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Baris atas: Jenis & Menu Titik Tiga
            Row(
              children: [
                Expanded(
                  child: TypographyStyles.bodyCaptionBold(
                    draft.getJudulJenis(),
                    color: TextColors.grey800,
                  ),
                ),
                _buildStatusBadge(draft.status),
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert,
                    color: TextColors.grey600,
                    size: 22.sp,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  onSelected: (value) {
                    if (value == 'edit') {
                      _bukaFormEdit(draft);
                    } else if (value == 'hapus') {
                      _konfirmasiHapus(draft);
                    }
                  },
                  itemBuilder: (ctx) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit_outlined, size: 18.sp, color: TextColors.grey700),
                          SizedBox(width: 8.w),
                          TypographyStyles.bodyCaptionReguler('Edit', color: TextColors.grey800),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'hapus',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline, size: 18.sp, color: const Color(0xFFEF5350)),
                          SizedBox(width: 8.w),
                          TypographyStyles.bodyCaptionReguler('Hapus', color: const Color(0xFFEF5350)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 6.h),

            // Ringkasan Kegiatan
            TypographyStyles.bodyCaptionReguler(
              draft.getRingkasan(),
              color: TextColors.grey700,
              maxlines: 2,
            ),

            SizedBox(height: 10.h),

            // Tanggal dibuat & Jumlah Foto
            Row(
              children: [
                Icon(Icons.access_time_rounded, size: 14.sp, color: TextColors.grey400),
                SizedBox(width: 4.w),
                TypographyStyles.captionReguler(
                  _formatTanggal(draft.tanggalDibuat),
                  color: TextColors.grey500,
                ),
                if (draft.daftarFoto.isNotEmpty) ...[
                  SizedBox(width: 12.w),
                  Icon(Icons.photo_outlined, size: 14.sp, color: TextColors.grey400),
                  SizedBox(width: 4.w),
                  TypographyStyles.captionReguler(
                    '${draft.daftarFoto.length} foto',
                    color: TextColors.grey500,
                  ),
                ],
              ],
            ),

            // Tampilkan pesan error jika status gagal_kirim
            if (draft.status == 'gagal_kirim' && draft.pesanError != null && draft.pesanError!.isNotEmpty) ...[
              SizedBox(height: 8.h),
              Text(
                draft.pesanError!,
                style: TextStyle(
                  fontFamily: TypographyStyles.fontFamily,
                  fontSize: 12.sp,
                  color: const Color(0xFFD32F2F),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],

            SizedBox(height: 14.h),

            // Tombol Kirim di Kartu
            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ButtonFill(
                text: 'Kirim',
                textColor: Colors.white,
                onPressed: () {
                  // Sesuai Tahap 3: Kirim draf penuh akan diaktifkan di Tahap 4
                  Get.snackbar(
                    'Fitur Kirim Draf',
                    'Fitur kirim draf menyusul (Tahap 4)',
                    backgroundColor: const Color(0xFF3F8FC1),
                    colorText: Colors.white,
                    snackPosition: SnackPosition.TOP,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
