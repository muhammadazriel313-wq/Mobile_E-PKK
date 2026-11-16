import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'peringkat_model.dart';

class PeringkatController extends GetxController {
  // =====================================================
  // PENGATURAN ALAMAT API PERINGKAT (khusus fitur ini)
  //
  // _pakaiLokal = true  -> pakai XAMPP di laptop (untuk tes)
  // _pakaiLokal = false -> pakai hosting (isi _hostingUrl dulu!)
  //
  // _hostLokal:
  //  - Emulator Android : '10.0.2.2'
  //  - HP asli          : IP laptop, mis. '192.168.1.10' (satu Wi-Fi)
  // =====================================================
  static const bool _pakaiLokal = true;
  static const String _hostLokal = '10.0.2.2';
  static const String _hostingUrl = 'https://GANTI-DOMAIN-HOSTING/api';

  // Di Chrome/web, '10.0.2.2' tidak berlaku -> pakai 'localhost'.
  String get _base => _pakaiLokal
      ? 'http://${kIsWeb ? 'localhost' : _hostLokal}/Website_PKK/public/api'
      : _hostingUrl;

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
    final uri = Uri.parse('$_base/ranking/$path').replace(
      queryParameters: {
        'periode': periode.value.kode,
        if (limit != null) 'limit': '$limit',
      },
    );

    try {
      debugPrint('[PERINGKAT] GET $uri');
      final res = await http
          .get(uri, headers: {'Accept': 'application/json'})
          .timeout(const Duration(seconds: 30));
      debugPrint('[PERINGKAT] status ${res.statusCode}');

      if (res.statusCode != 200) {
        throw 'Server membalas ${res.statusCode}';
      }

      if (ini != _permintaanKe) return; // sudah ada permintaan yang lebih baru

      final body = jsonDecode(res.body);
      final raw = body['items'] ?? body['data']?['items'] ?? [];
      final list = raw as List;

      items.assignAll(
        list.map((e) => PeringkatItem.fromJson(Map<String, dynamic>.from(e))),
      );
    } catch (e) {
      if (ini != _permintaanKe) return;
      debugPrint('[PERINGKAT] ERROR: $e');
      error.value = 'Gagal memuat peringkat.\n$e\n\nURL: $uri';
      items.clear();
    } finally {
      if (ini == _permintaanKe) loading.value = false;
    }
  }
}
