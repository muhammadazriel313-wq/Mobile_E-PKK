import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb, kDebugMode;

/// =====================================================================
/// PILIH SERVER
///
/// Cara 1 (disarankan): tanpa mengubah file, pakai --dart-define
///   flutter run --dart-define=SERVER=produksi     -> hosting
///   flutter run --dart-define=SERVER=artisan      -> php artisan serve (port 8000)
///   flutter run --dart-define=SERVER=xampp        -> XAMPP (Apache, port 80)
///   flutter run --dart-define=SERVER=hp           -> HP fisik (isi _ipLaptop)
///
/// Cara 2: ubah nilai defaultValue di bawah.
///
/// Build rilis (flutter build apk --release) SELALU memakai produksi,
/// apa pun pilihan di atas, supaya tidak salah kirim ke server lokal.
///
/// PENTING: website dan mobile harus memakai server/database yang SAMA.
/// =====================================================================
const String _pilihan = String.fromEnvironment(
  'SERVER',
  defaultValue: 'artisan',
);

class ApiHelper {
  static const String _produksi = 'https://epkknganjuk.pbltifnganjuk.com/api';

  // Isi dengan IP laptop di WiFi yang sama (cek lewat `ipconfig`), tanpa http://
  static const String _ipLaptop = '192.168.1.10';

  static String get _baseUrl {
    // Rilis selalu ke hosting
    if (!kDebugMode) return _produksi;

    switch (_pilihan) {
      case 'artisan':
        // php artisan serve --host=0.0.0.0
        // Emulator Android: 10.0.2.2 | Chrome: localhost
        return kIsWeb
            ? 'http://localhost:8000/api'
            : 'http://10.0.2.2:8000/api';

      case 'xampp':
        return kIsWeb
            ? 'http://localhost/Website_E-PKK/public/api'
            : 'http://10.0.2.2/Website_E-PKK/public/api';

      case 'hp':
        return 'http://$_ipLaptop:8000/api';

      case 'produksi':
      default:
        return _produksi;
    }
  }

  /// Tampilkan di log supaya jelas server mana yang sedang dipakai.
  static String get baseUrlAktif => _baseUrl;

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
