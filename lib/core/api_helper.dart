import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

/// =====================================================================
/// SAKLAR SERVER
///   true  -> server LOKAL (XAMPP di laptop)  : untuk testing / demo lokal
///   false -> server PRODUKSI (hosting)       : untuk push / rilis
///
/// Cukup ubah satu baris ini. Alamat lokal dipilih otomatis:
///   Chrome (web)     -> http://localhost/...
///   Android emulator -> http://10.0.2.2/...
///
/// Kalau memakai HP fisik, ganti [_lokalHp] dengan IP laptop di WiFi yang
/// sama, contoh: 'http://192.168.1.10/Website_PKK/public/api'
/// =====================================================================
const bool kPakaiServerLokal = true;

class ApiHelper {
  static const String _produksi = 'https://epkknganjuk.pbltifnganjuk.com/api';

  static const String _lokalWeb = 'http://localhost/Website_PKK/public/api';

  static const String _lokalEmulator = 'http://10.0.2.2/Website_PKK/public/api';

  static String get _baseUrl {
    if (!kPakaiServerLokal) return _produksi;

    return kIsWeb ? _lokalWeb : _lokalEmulator;
  }

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
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

  /// ================= GET =================
  Future<Response> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return await _dio.get(
      endpoint,
      queryParameters: queryParameters,
    );
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
      options: Options(
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      ),
    );
  }
}