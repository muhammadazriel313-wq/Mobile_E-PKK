import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;

/// =====================================================================
/// ALAMAT SERVER
///
///   flutter run (mode debug) -> server LOKAL, dicari otomatis berurutan:
///        1) php artisan serve (Laragon) : http://127.0.0.1:8000/api
///        2) XAMPP (Apache)              : http://localhost/Website_PKK/public/api
///      Aplikasi memakai alamat pertama yang menjawab. Jadi pengguna XAMPP
///      maupun Laragon cukup `flutter run`, tanpa mengubah kode.
///   build rilis              -> server PRODUKSI (hosting)
///
/// Khusus: --dart-define=API_BASE_URL=... memaksa satu alamat tertentu,
/// misalnya HP asli: --dart-define=API_BASE_URL=http://IP-LAPTOP:8000/api
/// (Emulator Android memakai 10.0.2.2 secara otomatis.)
/// =====================================================================
const bool kPakaiServerLokal = kDebugMode;

const String kAlamatApiKhusus = String.fromEnvironment('API_BASE_URL');

class ApiHelper {
  static const String _produksi = 'https://epkknganjuk.pbltifnganjuk.com/api';

  static const List<String> _kandidatWeb = [
    'http://127.0.0.1:8000/api', // php artisan serve (Laragon)
    'http://localhost/Website_PKK/public/api', // XAMPP
  ];

  static const List<String> _kandidatEmulator = [
    'http://10.0.2.2:8000/api',
    'http://10.0.2.2/Website_PKK/public/api',
  ];

  /// Indeks alamat yang terakhir berhasil dipakai.
  static int _aktif = 0;

  static List<String> get _kandidat {
    if (kAlamatApiKhusus.isNotEmpty) return [kAlamatApiKhusus];
    if (!kPakaiServerLokal) return [_produksi];
    return kIsWeb ? _kandidatWeb : _kandidatEmulator;
  }

  /// Alamat dasar API yang sedang dipakai (dipakai juga oleh fitur Peringkat).
  static String get baseUrl {
    final k = _kandidat;
    return k[_aktif < k.length ? _aktif : 0];
  }

  static bool _gagalTerhubung(DioException e) =>
      e.type == DioExceptionType.connectionError ||
      e.type == DioExceptionType.connectionTimeout;

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      // Upload foto bisa lebih lama dari request biasa
      sendTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),

      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  ApiHelper() {
    _dio.interceptors.add(InterceptorsWrapper(onError: _cobaAlamatLain));
  }

  /// Bila server tidak bisa dihubungi, coba alamat lokal berikutnya.
  /// Alamat yang menjawab (selain 404) diingat dan dipakai seterusnya.
  Future<void> _cobaAlamatLain(
    DioException e,
    ErrorInterceptorHandler handler,
  ) async {
    final k = _kandidat;

    // Hanya untuk kegagalan koneksi, dan jangan berulang tanpa akhir.
    if (!_gagalTerhubung(e) ||
        k.length < 2 ||
        e.requestOptions.extra['sudah_coba_alamat_lain'] == true) {
      return handler.next(e);
    }

    for (var i = 0; i < k.length; i++) {
      if (k[i] == e.requestOptions.baseUrl) continue;

      final data = e.requestOptions.data;
      final opsi = e.requestOptions.copyWith(
        baseUrl: k[i],
        data: data is FormData ? data.clone() : data,
        extra: {...e.requestOptions.extra, 'sudah_coba_alamat_lain': true},
      );

      try {
        final res = await _dio.fetch(opsi);
        _aktif = i;
        return handler.resolve(res);
      } on DioException catch (e2) {
        final kode = e2.response?.statusCode;
        // Server ini menjawab (mis. 401, 422, 500) -> inilah server yang benar.
        if (kode != null && kode != 404) {
          _aktif = i;
          return handler.next(e2);
        }
        // Tidak terhubung atau 404 (bukan aplikasi kita) -> coba berikutnya.
      }
    }

    _aktif = 0;
    handler.next(e);
  }

  /// Pesan kesalahan yang layak ditampilkan ke pengguna.
  /// Bila server mengirim pesan (misalnya 422 "Isian PHBS harus berupa angka."),
  /// pesan itulah yang dipakai. Selain itu dipakai pesan umum berbahasa Indonesia.
  static String pesanGalat(Object e) {
    if (e is! DioException) {
      return 'Terjadi kesalahan. Coba lagi.';
    }

    final data = e.response?.data;
    if (data is Map) {
      final error = data['error'];
      final pesan = (error is Map ? error['message'] : null) ?? data['message'];
      if (pesan is String && pesan.trim().isNotEmpty) return pesan;
    }

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Waktu tunggu koneksi habis. Coba lagi.';
      case DioExceptionType.connectionError:
        return 'Tidak dapat terhubung ke server. Periksa koneksi internet.';
      default:
        return 'Terjadi kesalahan pada server. Coba lagi.';
    }
  }

  /// ================= GET =================
  Future<Response> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return await _dio.get(endpoint, queryParameters: queryParameters);
  }

  /// ================= POST =================
  Future<Response> post(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return await _dio.post(
      endpoint,
      data: data,
      queryParameters: queryParameters,
    );
  }

  /// ================= PUT =================
  Future<Response> put(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return await _dio.put(
      endpoint,
      data: data,
      queryParameters: queryParameters,
    );
  }

  /// ================= DELETE =================
  Future<Response> delete(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return await _dio.delete(
      endpoint,
      data: data,
      queryParameters: queryParameters,
    );
  }

  /// ================= MULTIPART (UPLOAD FILE) =================
  Future<Response> postMultipart(
    String endpoint, {
    required Map<String, dynamic> data,
  }) async {
    final formData = FormData.fromMap(data);

    return await _dio.post(
      endpoint,
      data: formData,
      options: Options(headers: {'Content-Type': 'multipart/form-data'}),
    );
  }
}