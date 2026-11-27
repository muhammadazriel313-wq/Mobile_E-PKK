import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

/// Layar kamera untuk Chrome/web (webcam).
///
/// Hasil foto dikembalikan lewat Get.back(result: XFile). Dibuka oleh
/// [AmbilFoto.pilih] hanya di web; di HP dipakai kamera bawaan.
/// Catatan: browser hanya mengizinkan kamera pada https atau localhost.
class KameraWebScreen extends StatefulWidget {
  const KameraWebScreen({super.key});

  @override
  State<KameraWebScreen> createState() => _KameraWebScreenState();
}

class _KameraWebScreenState extends State<KameraWebScreen> {
  CameraController? _controller;
  String? _error;
  bool _mengambil = false;

  @override
  void initState() {
    super.initState();
    _siapkanKamera();
  }

  Future<void> _siapkanKamera() async {
    try {
      final daftar = await availableCameras();

      if (daftar.isEmpty) {
        if (mounted) {
          setState(() => _error = 'Kamera tidak ditemukan di perangkat ini.');
        }
        return;
      }

      final controller = CameraController(
        daftar.first,
        ResolutionPreset.medium, // ukuran file lebih kecil agar cepat terkirim
        enableAudio: false,
      );

      await controller.initialize();

      if (!mounted) {
        await controller.dispose();
        return;
      }

      setState(() => _controller = controller);
    } on CameraException catch (e) {
      final kode = e.code.toLowerCase();
      final ditolak = kode.contains('denied') || kode.contains('notallowed');

      if (mounted) {
        setState(() {
          _error = ditolak
              ? 'Izin kamera ditolak. Izinkan kamera pada browser (ikon di '
                  'sebelah alamat), lalu coba lagi.'
              : 'Kamera tidak dapat dibuka (${e.code}).';
        });
      }
    } catch (e) {
      if (mounted) setState(() => _error = 'Kamera tidak dapat dibuka: $e');
    }
  }

  Future<void> _ambilFoto() async {
    final controller = _controller;
    if (controller == null || _mengambil) return;

    setState(() => _mengambil = true);

    try {
      final foto = await controller.takePicture();
      Get.back(result: foto);
    } catch (e) {
      if (mounted) {
        setState(() => _mengambil = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal mengambil foto: $e')));
      }
    }
  }

  Future<void> _pilihDariBerkas() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file != null) Get.back(result: file);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Ambil Foto'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(child: _isi()),
    );
  }

  Widget _isi() {
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.no_photography_outlined,
                  color: Colors.white70, size: 56),
              const SizedBox(height: 16),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _pilihDariBerkas,
                icon: const Icon(Icons.photo_library_outlined),
                label: const Text('Pilih dari berkas'),
              ),
            ],
          ),
        ),
      );
    }

    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Expanded(child: Center(child: CameraPreview(controller))),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton.icon(
                onPressed: _pilihDariBerkas,
                icon: const Icon(Icons.photo_library_outlined,
                    color: Colors.white70),
                label: const Text('Berkas',
                    style: TextStyle(color: Colors.white70)),
              ),
              GestureDetector(
                onTap: _ambilFoto,
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                  ),
                  padding: const EdgeInsets.all(5),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _mengambil ? Colors.grey : Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 72), // penyeimbang tata letak
            ],
          ),
        ),
      ],
    );
  }
}
