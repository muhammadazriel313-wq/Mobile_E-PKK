import 'package:epkk_nganjuk/common/colors.dart';
import 'package:epkk_nganjuk/features/detail_laporan/detail_laporan_controller.dart';
import 'package:epkk_nganjuk/features/detail_laporan/edit_laporan_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DetailLaporanScreen extends StatelessWidget {
  final String uuid;
  final String title;
  final String subtitle;
  final String status;
  final DateTime createdAt;
  final int idOrganization;

  const DetailLaporanScreen({
    super.key,
    required this.uuid,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.createdAt,
    required this.idOrganization,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DetailLaporanController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadDetailLaporan(uuid: uuid, orgId: idOrganization);
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,

        centerTitle: true,

        title: Text(
          subtitle,

          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),

        actions: [
          if (status == 'Proses')
            IconButton(
              icon: Icon(Icons.edit_rounded, size: 22.sp),

              onPressed: () => _navigateToEditScreen(context),
            ),

          if (status == 'Proses')
            IconButton(
              icon: Icon(
                Icons.delete_outline_rounded,
                size: 22.sp,
                color: Colors.red.shade400,
              ),

              onPressed: () => _showCancelDialog(context),
            ),
        ],
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(16.w),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              _buildInfoCard(context),

              SizedBox(height: 20.h),

              _buildDetailFields(controller.laporanDetail.value),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: EdgeInsets.all(18.w),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(22.r),

        border: Border.all(color: const Color(0xFFE7EDF3)),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          /// TITLE
          Text(
            title,

            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
              height: 1.4,
            ),
          ),

          SizedBox(height: 10.h),

          /// SUBTITLE
          Row(
            children: [
              Icon(
                Icons.folder_open_rounded,

                size: 18.sp,

                color: BrandColors.brandPrimary500,
              ),

              SizedBox(width: 6.w),

              Expanded(
                child: Text(
                  subtitle,

                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.grey.shade700,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 14.h),

          /// STATUS + DATE
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),

                decoration: BoxDecoration(
                  color: _getStatusColor(status),

                  borderRadius: BorderRadius.circular(100.r),
                ),

                child: Text(
                  _getStatusLabel(status),

                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: _getStatusTextColor(status),
                  ),
                ),
              ),

              SizedBox(width: 10.w),

              Expanded(
                child: Text(
                  DateFormat('dd MMM yyyy').format(createdAt),

                  textAlign: TextAlign.end,

                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailFields(Map<String, dynamic> data) {
    final hiddenFields = [
      'uuid',
      'id_user',
      'id_kader_pokja1',
      'id_pokja1_bidang1',
      'id_pokja1_bidang2',
      'id_pokja2_bidang1',
      'id_pokja2_bidang2',
      'id_kader_pokja3',
      'id_pokja3_bidang1',
      'id_pokja3_bidang2',
      'id_pokja3_bidang3',
      'id_kader_pokja4',
      'id_pokja4_bidang1',
      'id_pokja4_bidang2',
      'id_pokja4_bidang3',
      'id_laporan_umum',
      'status',
      'created_at',
      'id_role',
      'id_organization',
    ];

    final displayData = Map.from(data)
      ..removeWhere((key, value) => hiddenFields.contains(key));

    return Column(
      children: displayData.entries.map((entry) {
        return Container(
          width: double.infinity,

          margin: EdgeInsets.only(bottom: 14.h),

          padding: EdgeInsets.all(14.w),

          decoration: BoxDecoration(
            color: Colors.white,

            borderRadius: BorderRadius.circular(18.r),

            border: Border.all(color: const Color(0xFFE7EDF3)),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                _getFieldLabel(entry.key),

                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
              ),

              SizedBox(height: 8.h),

              Text(
                entry.value?.toString() ?? '-',

                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  String _getFieldLabel(String fieldName) {
    switch (fieldName) {
      case 'nama_kader':
        return 'Nama Kader';

      case 'jumlah_kegiatan':
        return 'Jumlah Kegiatan';

      case 'keterangan':
        return 'Keterangan';

      default:
        return fieldName.replaceAll('_', ' ').capitalizeFirst ?? fieldName;
    }
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'Proses':
        return 'Sedang Diproses';

      case 'Disetujui1':
        return 'Disetujui Kecamatan';

      case 'Disetujui2':
        return 'Disetujui Kabupaten';

      case 'Dibatalkan':
        return 'Dibatalkan';

      default:
        return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Proses':
        return Colors.orange.shade100;

      case 'Disetujui1':
      case 'Disetujui2':
        return Colors.green.shade100;

      case 'Dibatalkan':
        return Colors.red.shade100;

      default:
        return Colors.grey.shade200;
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status) {
      case 'Proses':
        return Colors.orange.shade800;

      case 'Disetujui1':
      case 'Disetujui2':
        return Colors.green.shade800;

      case 'Dibatalkan':
        return Colors.red.shade800;

      default:
        return Colors.grey.shade700;
    }
  }

  void _navigateToEditScreen(BuildContext context) async {
    final controller = Get.find<DetailLaporanController>();

    final result = await Navigator.push(
      context,

      MaterialPageRoute(
        builder: (context) => EditLaporanScreen(
          uuid: uuid,
          orgId: idOrganization,

          initialData: Map.from(controller.laporanDetail.value),
        ),
      ),
    );

    if (result == true) {
      controller.loadDetailLaporan(uuid: uuid, orgId: idOrganization);
    }
  }

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,

      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.r),
        ),

        title: const Text('Batalkan Laporan'),

        content: const Text('Apakah Anda yakin ingin membatalkan laporan ini?'),

        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),

            child: const Text('Tidak'),
          ),

          TextButton(
            onPressed: () {
              Navigator.pop(context);

              _processCancellation(context);
            },

            child: const Text('Ya, Batalkan'),
          ),
        ],
      ),
    );
  }

  void _processCancellation(BuildContext context) async {
    final controller = Get.find<DetailLaporanController>();

    try {
      await controller.cancelLaporan(uuid: uuid, orgId: idOrganization);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Laporan berhasil dibatalkan')),
      );

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal membatalkan: $e')));
    }
  }
}
