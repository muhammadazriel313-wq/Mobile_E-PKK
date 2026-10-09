import 'dart:async';
import 'package:dio/dio.dart' as dio;
import 'package:intl/intl.dart';

import 'package:epkk_nganjuk/core/api_helper.dart';
import 'package:epkk_nganjuk/features/pengumuman/pengumuman_model.dart';
import 'package:get/get.dart';

class PengumumanController extends GetxController {
  final ApiHelper apiHelper = ApiHelper();

  var pengumumanList = <Pengumuman>[].obs;
  var latestPengumumanList = <Pengumuman>[].obs;

  // [PERUBAHAN 08-10-2026] State pengumuman minggu ini untuk Beranda dan Tab Pengumuman
  var weeklyPengumumanList = <Pengumuman>[].obs;
  var isWeeklyLoading = false.obs;
  var weeklyErrorMessage = ''.obs;

  // [PERUBAHAN 08-10-2026] State pengumuman bulanan untuk Kalender Riwayat
  var monthlyPengumumanList = <Pengumuman>[].obs;
  var isMonthlyLoading = false.obs;
  var monthlyErrorMessage = ''.obs;

  var isLoading = false.obs;
  var errorMessage = ''.obs;

  var currentPage = 1.obs;
  var totalPages = 1.obs;
  var hasMore = true.obs;
  var isLoadMore = false.obs;

  // [PERUBAHAN 08-10-2026] Fungsi tunggal menghitung awal minggu (Senin 00:00:00) dan akhir minggu (Minggu 23:59:59)
  static Map<String, dynamic> getWeeklyDateRange([DateTime? referenceDate]) {
    final now = referenceDate ?? DateTime.now();
    // Tanggal murni tanpa komponen jam (WIB / lokal perangkat)
    final today = DateTime(now.year, now.month, now.day);
    // Di Dart: DateTime.monday = 1 ... DateTime.sunday = 7
    final daysFromMonday = today.weekday - DateTime.monday;
    final monday = today.subtract(Duration(days: daysFromMonday));
    final sunday = monday.add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));

    final formatter = DateFormat('yyyy-MM-dd');
    return {
      'start': monday,
      'end': sunday,
      'dari': formatter.format(monday),
      'sampai': formatter.format(sunday),
    };
  }

  // ================= PENGUMUMAN MINGGU INI =================
  // [PERUBAHAN 08-10-2026] Memuat hanya pengumuman minggu ini (Senin - Minggu WIB)
  Future<void> loadWeeklyPengumuman({bool isRefresh = false}) async {
    try {
      if (isRefresh || weeklyPengumumanList.isEmpty) {
        isWeeklyLoading.value = true;
      }
      weeklyErrorMessage.value = '';

      final range = getWeeklyDateRange();

      final response = await apiHelper.get(
        '/announcement',
        queryParameters: {
          'dari': range['dari'],
          'sampai': range['sampai'],
          'limit': 50,
        },
      );

      final data = PengumumanResponse.fromJson(response.data);

      if (data.statusCode == 200) {
        weeklyPengumumanList.assignAll(data.data);
        latestPengumumanList.assignAll(data.data);
      } else {
        weeklyPengumumanList.clear();
        latestPengumumanList.clear();
      }
    } on dio.DioException catch (e) {
      // [PERUBAHAN 08-10-2026] Menangani 404 sebagai daftar kosong (bukan error)
      if (e.response?.statusCode == 404) {
        weeklyPengumumanList.clear();
        latestPengumumanList.clear();
      } else {
        weeklyErrorMessage.value = 'Gagal memuat pengumuman';
      }
    } catch (e) {
      weeklyErrorMessage.value = 'Gagal memuat pengumuman';
    } finally {
      isWeeklyLoading.value = false;
    }
  }

  // ================= PENGUMUMAN BULANAN (KALENDER RIWAYAT) =================
  // [PERUBAHAN 08-10-2026] Memuat seluruh pengumuman pada bulan yang dipilih
  Future<void> loadPengumumanBulan(DateTime monthDate) async {
    try {
      isMonthlyLoading.value = true;
      monthlyErrorMessage.value = '';

      final bulanStr = DateFormat('yyyy-MM').format(monthDate);

      final response = await apiHelper.get(
        '/announcement',
        queryParameters: {
          'bulan': bulanStr,
          'limit': 100,
        },
      );

      final data = PengumumanResponse.fromJson(response.data);

      if (data.statusCode == 200) {
        monthlyPengumumanList.assignAll(data.data);
      } else {
        monthlyPengumumanList.clear();
      }
    } on dio.DioException catch (e) {
      if (e.response?.statusCode == 404) {
        monthlyPengumumanList.clear();
      } else {
        monthlyErrorMessage.value = 'Gagal memuat riwayat pengumuman';
      }
    } catch (e) {
      monthlyErrorMessage.value = 'Gagal memuat riwayat pengumuman';
    } finally {
      isMonthlyLoading.value = false;
    }
  }

  // ================= LATEST =================
  Future<void> loadLatestPengumuman({int limit = 5}) async {
    // [PERUBAHAN 08-10-2026] Mengarahkan ke pengumuman minggu ini
    await loadWeeklyPengumuman(isRefresh: true);
  }

  // ================= LIST =================
  Future<void> loadPengumuman({bool isRefresh = false}) async {
    // [PERUBAHAN 08-10-2026] Tab Pengumuman menggunakan pengumuman minggu ini
    await loadWeeklyPengumuman(isRefresh: isRefresh);
  }

  Future<void> loadMore() async {
    // Tidak diperlukan pagination bila daftar terbatas pada minggu ini
  }

  Future<void> refreshData() async {
    await loadWeeklyPengumuman(isRefresh: true);
  }

  void sortByNewest() {
    weeklyPengumumanList.sort((a, b) => b.tanggal.compareTo(a.tanggal));
  }
}
