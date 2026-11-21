import 'package:epkk_nganjuk/features/draft/draft_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('DraftModel serialization dan parsing', () {
    final model = DraftModel(
      id: 'test-uuid-1234',
      idAkun: 'user-01',
      jenis: 'pancasila',
      dataForm: {
        'kisah_kegiatan': 'Pengajian rutin',
        'kisah_vol': '10',
      },
      daftarFoto: [],
      tanggalDibuat: '2026-11-05T12:00:00Z',
      status: 'draf',
    );

    final map = model.toMap();
    expect(map['id'], 'test-uuid-1234');
    expect(map['id_akun'], 'user-01');
    expect(map['jenis'], 'pancasila');

    final reconstructed = DraftModel.fromMap(map);
    expect(reconstructed.id, model.id);
    expect(reconstructed.dataForm['kisah_kegiatan'], 'Pengajian rutin');
    expect(reconstructed.getJudulJenis(), 'Pengamalan Pancasila');
    expect(reconstructed.getRingkasan(), 'Pengajian rutin');
  });
}
