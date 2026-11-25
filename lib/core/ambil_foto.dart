import 'package:epkk_nganjuk/features/kamera/kamera_web_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

/// Pengambil foto untuk seluruh aplikasi (kamera atau galeri).
///
/// - HP (Android/iOS): memakai kamera bawaan lewat image_picker.
/// - Chrome/web + kamera: image_picker hanya membuka jendela pilih berkas
///   (browser desktop tidak mendukung atribut capture), jadi webcam dibuka
///   lewat [KameraWebScreen].
/// - Galeri: tetap memakai image_picker di semua platform.
class AmbilFoto {
  AmbilFoto._();

  static final ImagePicker _picker = ImagePicker();

  static Future<XFile?> pilih(
    ImageSource source, {
    int? imageQuality,
    double? maxWidth,
  }) async {
    if (kIsWeb && source == ImageSource.camera) {
      final hasil = await Get.to<XFile>(() => const KameraWebScreen());
      return hasil == null ? null : await _beriNamaBerekstensi(hasil);
    }

    return _picker.pickImage(
      source: source,
      imageQuality: imageQuality,
      maxWidth: maxWidth,
    );
  }

  /// Foto webcam hanya punya nama berupa ID blob (tanpa .jpg/.png). Beri nama
  /// berekstensi sesuai isi berkas agar diterima server dan tersimpan benar.
  static Future<XFile> _beriNamaBerekstensi(XFile f) async {
    final bytes = await f.readAsBytes();

    var ext = 'jpg';
    var mime = 'image/jpeg';

    final png = bytes.length > 4 &&
        bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4E &&
        bytes[3] == 0x47;
    final webp = bytes.length > 12 &&
        bytes[0] == 0x52 &&
        bytes[1] == 0x49 &&
        bytes[2] == 0x46 &&
        bytes[3] == 0x46 &&
        bytes[8] == 0x57 &&
        bytes[9] == 0x45 &&
        bytes[10] == 0x42 &&
        bytes[11] == 0x50;

    if (png) {
      ext = 'png';
      mime = 'image/png';
    } else if (webp) {
      ext = 'webp';
      mime = 'image/webp';
    }

    return XFile.fromData(
      bytes,
      name: 'foto_${DateTime.now().millisecondsSinceEpoch}.$ext',
      mimeType: mime,
    );
  }
}
