import 'package:epkk_nganjuk/features/draft/draft_model.dart';
import 'package:epkk_nganjuk/features/draft/draft_service.dart';
import 'package:epkk_nganjuk/services/preferences/preferences_service.dart';
import 'package:get/get.dart';

class DraftController extends GetxController {
  final DraftService _draftService = DraftService();

  /// Jumlah draf laporan (pancasila, gotong_royong, kader_pokja1)
  var jumlahDraftLaporan = 0.obs;

  /// Jumlah draf galeri
  var jumlahDraftGaleri = 0.obs;

  /// Daftar draf yang sedang ditampilkan pada halaman Draf Saya
  var daftarDraft = <DraftModel>[].obs;
  var isLoading = false.obs;

  static const List<String> jenisLaporan = [
    'pancasila',
    'gotong_royong',
    'kader_pokja1',
  ];

  static const List<String> jenisGaleri = [
    'galeri',
  ];

  @override
  void onInit() {
    super.onInit();
    refreshAllCount();
  }

  /// Memperbarui hitungan badge draf untuk laporan dan galeri
  Future<void> refreshAllCount() async {
    final user = await PreferencesService.getUser();
    if (user == null || user.id.isEmpty) {
      jumlahDraftLaporan.value = 0;
      jumlahDraftGaleri.value = 0;
      return;
    }

    final idAkun = user.id;

    try {
      final hitunganLaporan = await _draftService.hitungJumlahDraft(
        idAkun: idAkun,
        daftarJenis: jenisLaporan,
      );
      jumlahDraftLaporan.value = hitunganLaporan;

      final hitunganGaleri = await _draftService.hitungJumlahDraft(
        idAkun: idAkun,
        daftarJenis: jenisGaleri,
      );
      jumlahDraftGaleri.value = hitunganGaleri;
    } catch (_) {
      // Tangani error tanpa crash
    }
  }

  /// Memuat daftar draf untuk halaman Draf Saya dengan filter jenis tertentu
  Future<void> loadDrafts({required List<String> filterJenis}) async {
    isLoading.value = true;
    final user = await PreferencesService.getUser();
    if (user == null || user.id.isEmpty) {
      daftarDraft.clear();
      isLoading.value = false;
      return;
    }

    try {
      final list = await _draftService.getDraftsByAkun(
        idAkun: user.id,
        daftarJenis: filterJenis,
      );
      daftarDraft.assignAll(list);
    } catch (_) {
      daftarDraft.clear();
    } finally {
      isLoading.value = false;
      // Perbarui juga badge count
      refreshAllCount();
    }
  }

  /// Hapus draf dan refresh daftar serta hitungan
  Future<void> hapusDraft(String idDraft, {required List<String> filterJenis}) async {
    await _draftService.hapusDraft(idDraft);
    await loadDrafts(filterJenis: filterJenis);
    await refreshAllCount();
  }
}

