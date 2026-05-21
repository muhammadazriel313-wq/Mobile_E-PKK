import 'dart:async';
import 'dart:io';
import 'package:epkk_nganjuk/core/api_helper.dart';
import 'package:epkk_nganjuk/features/Riwayat/riwayat_model.dart';
import 'package:get/get.dart';


class RiwayatController extends GetxController {
  final ApiHelper apiHelper = ApiHelper();

  var riwayatList = <Laporan>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  // ========================
  // GET RIWAYAT
  // ========================
  Future<void> loadRiwayat({
    required String idUser,
    required String idRole,
    required String idOrganization,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await apiHelper.get(
        '/riwayat',
        queryParameters: {
          'user_id': idUser,
          'user_role': idRole,
          'user_org': idOrganization,
        },
      );

      final result = RiwayatResponse.fromJson(response.data);

      if (result.statusCode == 200) {
        riwayatList.assignAll(result.data);
      } else {
        errorMessage.value = result.message;
      }
    } on SocketException {
      errorMessage.value = 'Tidak ada koneksi internet';
    } on TimeoutException {
      errorMessage.value = 'Server tidak merespons';
    } catch (e) {
      errorMessage.value = 'Gagal memuat riwayat';
      print("ERROR RIWAYAT: $e");
    } finally {
      isLoading.value = false;
    }
  }
}