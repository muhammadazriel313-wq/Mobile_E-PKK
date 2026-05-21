import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:epkk_nganjuk/core/api_helper.dart';
import 'package:epkk_nganjuk/features/pengumuman/pengumuman_model.dart';
import 'package:get/get.dart';

class PengumumanController extends GetxController {
  final ApiHelper apiHelper = ApiHelper();

  var pengumumanList = <Pengumuman>[].obs;
  var latestPengumumanList = <Pengumuman>[].obs;

  var isLoading = false.obs;
  var errorMessage = ''.obs;

  var currentPage = 1.obs;
  var totalPages = 1.obs;
  var hasMore = true.obs;
  var isLoadMore = false.obs;

  // ================= LATEST =================
  Future<void> loadLatestPengumuman({int limit = 5}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await apiHelper.get(
        '/announcement',
        queryParameters: {'limit': limit},
      );

      final data = PengumumanResponse.fromJson(response.data);

      if (data.statusCode == 200) {
        latestPengumumanList.assignAll(data.data);
      } else {
        errorMessage.value = data.message;
      }
    } catch (e) {
      errorMessage.value = 'Gagal memuat pengumuman: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // ================= LIST =================
  Future<void> loadPengumuman({bool isRefresh = false}) async {
    try {
      if (isRefresh) {
        currentPage.value = 1;
        pengumumanList.clear();
        hasMore.value = true;
        isLoading.value = true;
      } else if (!hasMore.value || isLoadMore.value) {
        return;
      }

      isLoadMore.value = !isRefresh;
      errorMessage.value = '';

      final response = await apiHelper.get(
        '/announcement',
        queryParameters: {'page': currentPage.value, 'limit': 10},
      );

      final data = PengumumanResponse.fromJson(response.data);
      
      for (var item in data.data) {
        print("Judul: ${item.judul}");
        print("Deskripsi: ${item.deskripsi}");
        print("Tanggal: ${item.tanggal}");
      }

      if (data.statusCode == 200) {
        final newData = data.data;

        if (newData.isNotEmpty) {
          if (isRefresh) {
            pengumumanList.assignAll(newData);
          } else {
            pengumumanList.addAll(newData);
          }

          currentPage.value++;
          totalPages.value = data.pagination?.totalHalaman ?? 1;
          hasMore.value = currentPage.value <= totalPages.value;
        } else {
          hasMore.value = false;
        }
      } else {
        errorMessage.value = data.message;
      }
    } on SocketException {
      errorMessage.value = 'Tidak ada koneksi internet';
    } on TimeoutException {
      errorMessage.value = 'Server tidak merespons';
    } catch (e) {
      errorMessage.value = 'Error: $e';
    } finally {
      isLoading.value = false;
      isLoadMore.value = false;
    }
  }

  Future<void> loadMore() async {
    if (hasMore.value && !isLoadMore.value) {
      await loadPengumuman();
    }
  }

  Future<void> refreshData() async {
    await loadPengumuman(isRefresh: true);
  }

  void sortByNewest() {
    pengumumanList.sort((a, b) => b.tanggal.compareTo(a.tanggal));
  }
}
