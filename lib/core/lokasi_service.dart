import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

/// Hasil pengambilan posisi GPS: berisi [posisi] bila berhasil, atau [pesan]
/// penjelasan bila gagal.
class HasilPosisi {
  final LatLng? posisi;
  final String? pesan;

  const HasilPosisi({this.posisi, this.pesan});
}

class HasilCari {
  final LatLng posisi;
  final String nama;

  const HasilCari({required this.posisi, required this.nama});
}

/// Layanan lokasi untuk pemilih peta.
///
/// - GPS: geolocator (HP dan browser).
/// - Alamat dari koordinat dan pencarian tempat: OpenStreetMap Nominatim
///   (gratis, tanpa kunci API, dan jalan juga di Chrome).
class LokasiService {
  LokasiService._();

  static final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 8),
      receiveTimeout: const Duration(seconds: 8),
      // Nominatim meminta aplikasi memperkenalkan diri. Browser tidak
      // mengizinkan User-Agent diubah, jadi hanya dikirim di HP.
      headers: kIsWeb
          ? null
          : {'User-Agent': 'EPKK-Nganjuk/1.0 (aplikasi PKK Kabupaten Nganjuk)'},
    ),
  );

  // ================= GPS =================
  static Future<HasilPosisi> posisiSaatIni() async {
    try {
      if (!kIsWeb && !await Geolocator.isLocationServiceEnabled()) {
        return const HasilPosisi(
          pesan: 'GPS belum aktif. Aktifkan lokasi di pengaturan HP.',
        );
      }

      var izin = await Geolocator.checkPermission();
      if (izin == LocationPermission.denied) {
        izin = await Geolocator.requestPermission();
      }
      if (izin == LocationPermission.denied) {
        return const HasilPosisi(pesan: 'Izin lokasi ditolak.');
      }
      if (izin == LocationPermission.deniedForever) {
        return const HasilPosisi(
          pesan: 'Izin lokasi ditolak permanen. Aktifkan lewat pengaturan.',
        );
      }

      final p = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 15),
      );
      return HasilPosisi(posisi: LatLng(p.latitude, p.longitude));
    } catch (e) {
      debugPrint('Gagal mengambil lokasi: $e');
      return const HasilPosisi(
        pesan: 'Lokasi belum bisa diambil. Geser peta dan pilih manual.',
      );
    }
  }

  // ================= ALAMAT DARI KOORDINAT =================
  static Future<String?> alamat(double lat, double lng) async {
    try {
      final res = await _dio.get(
        'https://nominatim.openstreetmap.org/reverse',
        queryParameters: {
          'format': 'jsonv2',
          'lat': lat,
          'lon': lng,
          'zoom': 18,
          'addressdetails': 1,
          'accept-language': 'id',
        },
      );

      final data = res.data;
      if (data is! Map) return null;

      final a = data['address'];
      if (a is Map) {
        String? ambil(List<String> kunci) {
          for (final k in kunci) {
            final v = a[k];
            if (v is String && v.trim().isNotEmpty) return v.trim();
          }
          return null;
        }

        final jalan = ambil(['road', 'pedestrian', 'footway', 'path']);
        final desa = ambil(['village', 'suburb', 'neighbourhood', 'quarter', 'hamlet']);
        final kec = ambil(['city_district', 'subdistrict', 'municipality']);
        final kab = ambil(['county', 'city', 'town', 'regency']);

        final bagian = <String?>[
          jalan,
          desa,
          kec == null ? null : 'Kec. $kec',
          kab,
        ].whereType<String>().toList();
        if (bagian.isNotEmpty) return bagian.join(', ');
      }

      final nama = data['display_name'];
      return nama is String && nama.trim().isNotEmpty ? nama.trim() : null;
    } catch (e) {
      debugPrint('Gagal mengambil alamat: $e');
      return null;
    }
  }

  // ================= CARI TEMPAT =================
  static Future<HasilCari?> cari(String kata) async {
    try {
      final res = await _dio.get(
        'https://nominatim.openstreetmap.org/search',
        queryParameters: {
          'format': 'jsonv2',
          'q': kata,
          'countrycodes': 'id',
          'limit': 1,
          'accept-language': 'id',
          // Utamakan hasil di sekitar Kabupaten Nganjuk
          'viewbox': '111.55,-7.30,112.25,-7.95',
        },
      );

      final data = res.data;
      if (data is List && data.isNotEmpty && data.first is Map) {
        final h = data.first as Map;
        final lat = double.tryParse('${h['lat']}');
        final lon = double.tryParse('${h['lon']}');
        if (lat != null && lon != null) {
          return HasilCari(
            posisi: LatLng(lat, lon),
            nama: '${h['display_name'] ?? kata}',
          );
        }
      }
    } catch (e) {
      debugPrint('Gagal mencari tempat: $e');
    }
    return null;
  }
}
