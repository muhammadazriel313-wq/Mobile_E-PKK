import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:epkk_nganjuk/core/api_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'peringkat_model.dart';

class PeringkatController extends GetxController {
  // Alamat server mengikuti ApiHelper (lihat lib/core/api_helper.dart):
  // debug -> Laragon (artisan serve) atau XAMPP dicari otomatis, rilis -> hosting.
  final ApiHelper _api = ApiHelper();

  final jenis = PeringkatJenis.desa.obs;
  final periode = PeringkatPeriode.tahunIni.obs;
  final items = <PeringkatItem>[].obs;
  final loading = false.obs;
  final error = RxnString();

  int? limit; // isi 3 untuk beranda, null untuk halaman penuh

  // Penanda permintaan terbaru, supaya jawaban lama tidak menimpa yang baru
  int _permintaanKe = 0;

  @override
  void onInit() {
    super.onInit();
    muat();
  }

  void ganti({PeringkatJenis? j, PeringkatPeriode? p}) {
    if (j != null) jenis.value = j;
    if (p != null) periode.value = p;
    muat();
  }

  Future<void> muat() async {
    final ini = ++_permintaanKe;
    loading.value = true;
    error.value = null;

    final path = jenis.value == PeringkatJenis.desa ? 'desa' : 'kecamatan';

    try {
      debugPrint('[PERINGKAT] GET ${ApiHelper.baseUrl}/ranking/$path');
      final res = await _api.get(
        '/ranking/$path',
        queryParameters: {
          'periode': periode.value.kode,
          if (limit != null) 'limit': '$limit',
        },
      );
      debugPrint('[PERINGKAT] status ${res.statusCode}');

      if (ini != _permintaanKe) return; // sudah ada permintaan yang lebih baru

      final body = res.data is String ? jsonDecode(res.data as String) : res.data;
      final raw = body['items'] ?? body['data']?['items'] ?? [];
      final list = raw as List;

      items.assignAll(
        list.map((e) => PeringkatItem.fromJson(Map<String, dynamic>.from(e))),
      );
    } on DioException catch (e) {
      if (ini != _permintaanKe) return;
      debugPrint('[PERINGKAT] ERROR: $e');

      final kode = e.response?.statusCode;
      var pesan = kode != null
          ? 'Server membalas $kode'
          : 'Tidak dapat terhubung ke server';

      // Bila server mengirim pesan kesalahan (mis. dari Laravel), tampilkan
      // agar penyebab error 500 mudah dilacak.
      final data = e.response?.data;
      if (data is Map && data['message'] != null) {
        final m = data['message'].toString();
        pesan += '\n${m.length > 220 ? '${m.substring(0, 220)}...' : m}';
      }

      error.value = 'Gagal memuat peringkat.\n$pesan\n\nURL: ${e.requestOptions.uri}';
      items.clear();
    } catch (e) {
      if (ini != _permintaanKe) return;
      debugPrint('[PERINGKAT] ERROR: $e');
      error.value = 'Gagal memuat peringkat.\n$e';
      items.clear();
    } finally {
      if (ini == _permintaanKe) loading.value = false;
    }
  }
}
