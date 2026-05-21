import 'dart:async';
import 'package:epkk_nganjuk/common/appbar/custom_appbar.dart';
import 'package:epkk_nganjuk/common/component/card_laporan.dart';
import 'package:epkk_nganjuk/common/component/riwayat_button.dart';
import 'package:epkk_nganjuk/features/Riwayat/riwayat_controller.dart';
import 'package:epkk_nganjuk/features/detail_laporan/detail_laporan_screen.dart';
import 'package:epkk_nganjuk/features/home/nav_controller.dart';
import 'package:epkk_nganjuk/services/preferences/preferences_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RiwayatScreen extends StatefulWidget {
  const RiwayatScreen({super.key});

  @override
  State<RiwayatScreen> createState() => _RiwayatScreenState();
}

class _RiwayatScreenState extends State<RiwayatScreen> {
  final RiwayatController riwayatController = Get.put(RiwayatController());

  String selectedStatus = 'Proses';

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final user = await PreferencesService.getUser();
    final idUser = user?.id ?? 'id user tidak diketahui';
    final idRole = user?.role?.id ?? 'id role tidak diketahui';
    final idOrganization =
        user?.organization?.id ?? 'id organization tidak diketahui';

    await riwayatController.loadRiwayat(
      idUser: idUser,
      idRole: idRole,
      idOrganization: idOrganization,
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarPrimary(
        title: 'Riwayat',
        backgroundColor: Colors.white,
        onBack: () {
          final NavController navController = Get.find<NavController>();
          navController.changeTabIndex(0);
          Get.back();
        },
      ),
      body: Column(
        children: [
          StatusFilterCard(
            selectedStatus: selectedStatus,
            onStatusSelected: (status) {
              setState(() {
                selectedStatus = status;
              });
            },
          ),
          Expanded(
            child: Obx(() {
              if (riwayatController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (riwayatController.errorMessage.isNotEmpty) {
                return Center(
                  child: Text(riwayatController.errorMessage.value),
                );
              }

              final filteredList = riwayatController.riwayatList.where((r) {
                if (selectedStatus == 'Selesai') {
                  return r.status == 'Disetujui1' ||
                      r.status == 'Disetujui2' ||
                      r.status == 'Dibatalkan';
                }
                return r.status == selectedStatus;
              }).toList();

              if (filteredList.isEmpty) {
                return const Center(
                  child: Text("Tidak ada laporan dengan status ini."),
                );
              }

              return ListView.builder(
                padding: EdgeInsets.only(top: 16.h),
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  final riwayat = filteredList[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: CardLaporan(
                      title: riwayat.uuid,
                      subtitle: getSubtitleFromUUID(riwayat.uuid),
                      status: _getStatusLabel(riwayat.status),
                      dateText: DateFormat(
                        'dd-MM-yyyy',
                      ).format(riwayat.createdAt),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailLaporanScreen(
                              uuid: riwayat.uuid,
                              title: riwayat.uuid,
                              subtitle: getSubtitleFromUUID(riwayat.uuid),
                              status: riwayat.status,
                              createdAt: riwayat.createdAt,
                              idOrganization: riwayat.idOrganization,
                            ),
                          ),
                        );

                        //  REFRESH SETELAH KEMBALI
                        await loadUserData();
                      },
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  String _getJenisLaporanFromUUID(String uuid) {
    return uuid.split('-').first;
  }
}
