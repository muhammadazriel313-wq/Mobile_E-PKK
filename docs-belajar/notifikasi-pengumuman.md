# Ringkasan: Notifikasi Pengumuman (Website Admin -> Mobile)

> Dibuat 25-11-2026. Ringkasan ini untuk dibaca ulang sebelum sidang.
> Isi kode di bawah dikutip persis dari file yang dipakai proyek.

## 3 kalimat versi hafalan

1. Admin website menyimpan pengumuman ke **satu database** yang sama dengan mobile.
2. HP mengecek database lewat API **tiap 60 detik** selama aplikasi dibuka.
3. Pengumuman yang ID-nya belum pernah dilihat HP dibuatkan **notifikasi + pop up**, dan ID-nya disimpan supaya tidak dobel.

---

## 1. Inti masalah dan solusinya

**Sebelum diperbaiki:** notifikasi pengumuman hanya dicek saat Beranda dimuat
(pertama dibuka, kembali dari background, atau tengah malam). Sinkron otomatis
60 detik hanya memeriksa laporan. Akibatnya, pengumuman yang dikirim admin saat
aplikasi sedang di tab lain tidak memunculkan notifikasi sampai Beranda dimuat ulang.

**Solusi:** pengecekan pengumuman dimasukkan ke sinkron 60 detik yang sudah ada,
jadi pengumuman baru terdeteksi otomatis paling lambat 1 menit.

**Tidak ada perubahan alur data website.** Website sejak awal sudah menyimpan ke
tabel `pengumumen`, dan API sudah bisa membacanya. Yang disambung hanya sisi HP.

---

## 2. Alur lengkap

```
[1] Admin kabupaten klik Simpan
        |
        v
[2] Tabel database: pengumumen
        |
        v   (GET /api/announcement?dari=..&sampai=..&limit=50)
[3] API mengembalikan daftar pengumuman minggu ini (JSON)
        |
        v   (tiap 60 detik, selama aplikasi terbuka)
[4] NotifikasiController di HP membandingkan ID pengumuman
        |
        +-- ID sudah dikenal  -> diamkan (tidak dobel)
        |
        +-- ID belum dikenal  -> buat notifikasi + pop up
                                 + simpan ID ke HP
                                 + perbarui daftar Beranda & tab Pengumuman
```

Saat user mengetuk notifikasi: aplikasi menandai notifikasi sudah dibaca, lalu
pindah ke tab **Pengumuman** (indeks tab 2 di `main_screen.dart`).

---

## 3. File yang terlibat

| Bagian | File | Baris |
|---|---|---|
| Website: simpan pengumuman | `app/Http/Controllers/backend/InputPengumumanController.php` | 26-49 |
| API: baca daftar pengumuman | `app/Http/Controllers/Api/AnnouncementController.php` | 11-148 |
| HP: timer 60 detik | `lib/features/notifikasi/notifikasi_controller.dart` | 81-88 |
| HP: sinkron laporan + pengumuman | `lib/features/notifikasi/notifikasi_controller.dart` | 114-154 |
| HP: ambil pengumuman mingguan | `lib/features/notifikasi/notifikasi_controller.dart` | 156-187 |
| HP: bandingkan ID, buat notifikasi | `lib/features/notifikasi/notifikasi_controller.dart` | 259-290 |
| HP: simpan daftar notifikasi | `lib/features/notifikasi/notifikasi_controller.dart` | 371-381 |
| HP: pop up + pindah tab | `lib/features/notifikasi/notifikasi_controller.dart` | 383-394, 396 dst |
| HP: pemicu dari Beranda | `lib/features/home/home_screen.dart` | 86-92, 147-149 |
| HP: model data pengumuman | `lib/features/pengumuman/pengumuman_model.dart` | 86-102 |
| HP: urutan tab | `lib/main_screen.dart` | 21-26 |

---

## 4. Potongan kode kunci

### 4.1 Website: menyimpan pengumuman (Pengumuman disimpan ke database)

`app/Http/Controllers/backend/InputPengumumanController.php` baris 26-49:

```php
public function store(Request $request): RedirectResponse
{
    $request->validate([
        'judulPengumuman' => 'required|string|max:255',
        'deskripsiPengumuman' => 'required|string',
        'tempatPengumuman' => 'required|string|max:255',
        'tanggalPengumuman' => 'required|date|before:2100-01-01|after:1970-01-01',
    ], [ ... ]);

    $tanggal = Carbon::parse($request->tanggalPengumuman)->format('Y-m-d');

    Pengumuman::create([
        'judulPengumuman' => $request->judulPengumuman,
        'deskripsiPengumuman' => $request->deskripsiPengumuman,
        'tempatPengumuman' => $request->tempatPengumuman,
        'tanggalPengumuman' => $tanggal,
    ]);

    return redirect()->route('input_pengumuman.index')
        ->with('success', 'Berhasil Menambahkan Pengumuman');
}
```

Poin bicara: "Klik Simpan hanya menulis satu baris baru ke tabel `pengumumen`.
Tidak ada kirim pesan ke HP dari sini."

### 4.2 API: membaca pengumuman (jembatan website -> HP)

`app/Http/Controllers/Api/AnnouncementController.php` baris 52-95 (diringkas):

```php
$query = DB::table('pengumumen')
    ->select(
        'id',
        'judulPengumuman as judul_pengumuman',
        'deskripsiPengumuman as deskripsi_pengumuman',
        'tempatPengumuman as tempat_pengumuman',
        'tanggalPengumuman as tanggal_pengumuman',
        'updated_at',
        'created_at'
    );

// Rentang tanggal: tanggal kegiatan ATAU waktu dibuat (dikonversi WIB)
if ($dari && $sampai) {
    $query->where(function ($q) use ($dari, $sampai) {
        $q->whereBetween('tanggalPengumuman', [$dari, $sampai])
          ->orWhereRaw("DATE(DATE_ADD(created_at, INTERVAL 7 HOUR)) BETWEEN ? AND ?", [$dari, $sampai]);
    });
}

$data = $query->orderBy('tanggalPengumuman', 'desc')
    ->limit($limit)
    ->offset($offset)
    ->get();
```

Poin bicara: "Karena filter memakai `tanggalPengumuman` **atau** `created_at`,
pengumuman yang baru dikirim hari ini tetap masuk walaupun tanggal kegiatannya
berbeda."

Contoh bentuk balasan (nilai hanya contoh):

```json
{
  "statusCode": 200,
  "message": "Berhasil mengambil data pengumuman",
  "data": [
    {
      "id": 12,
      "judul_pengumuman": "Rapat Pokja",
      "deskripsi_pengumuman": "...",
      "tempat_pengumuman": "Balai Desa",
      "tanggal_pengumuman": "2026-11-25",
      "updated_at": "2026-11-25 09:10:00",
      "created_at": "2026-11-25 09:10:00"
    }
  ],
  "pagination": {
    "total_data": 1,
    "total_halaman": 1,
    "halaman_sekarang": 1,
    "data_per_halaman": 50
  },
  "error": null
}
```

### 4.3 HP: pengecekan otomatis tiap 60 detik

`lib/features/notifikasi/notifikasi_controller.dart` baris 37 dan 81-88:

```dart
static const Duration intervalSinkron = Duration(seconds: 60);
// ...
if (_timer == null || gantiAkun) {
  WidgetsBinding.instance.removeObserver(this);
  WidgetsBinding.instance.addObserver(this);
  _timer?.cancel();
  _timer = Timer.periodic(intervalSinkron, (_) => sinkron());
}
```

Poin bicara: "Timer ini hanya hidup selama aplikasi terbuka. Kalau aplikasi
dibuka lagi, `didChangeAppLifecycleState` memanggil sinkron juga."

### 4.4 HP: satu sinkron mengurus laporan dan pengumuman

`notifikasi_controller.dart` baris 114-154 (diringkas):

```dart
Future<void> sinkron() async {
  if (_idUser.isEmpty || _sedangSinkron) return;
  _sedangSinkron = true;

  try {
    if (await PreferencesService.getUser() == null) {
      berhenti();
      return;
    }

    try {
      final response = await _api.get('/riwayat', queryParameters: {
        'user_id': _idUser,
        'user_role': _idRole,
        'user_org': _idOrg,
      });
      final hasil = RiwayatResponse.fromJson(response.data);
      if (hasil.statusCode == 200) {
        // ... Kebun Laporan + periksa laporan ...
      }
    } catch (e) {
      debugPrint('ERROR SINKRON LAPORAN: $e');
    }

    // Pengumuman tetap diperiksa walau sinkron laporan gagal.
    await _sinkronPengumuman();
  } finally {
    _sedangSinkron = false;
  }
}
```

Poin bicara: "`_sedangSinkron` mencegah dua pengecekan berjalan bersamaan.
Pengecekan pengumuman ditaruh di blok terpisah supaya tetap jalan walau
data laporan error."

### 4.5 HP: mengambil pengumuman minggu ini (bagian yang baru ditambahkan)

`notifikasi_controller.dart` baris 156-187:

```dart
/// Memeriksa pengumuman minggu ini langsung dari API supaya pengumuman
/// yang baru dikirim admin website muncul sebagai notifikasi tanpa harus
/// menunggu Beranda dimuat ulang.
Future<void> _sinkronPengumuman() async {
  try {
    final range = PengumumanController.getWeeklyDateRange();

    final response = await _api.get('/announcement', queryParameters: {
      'dari': range['dari'],
      'sampai': range['sampai'],
      'limit': 50,
    });

    final hasil = PengumumanResponse.fromJson(response.data);
    if (hasil.statusCode != 200) return;

    await periksaPengumuman(hasil.data);

    // Setelah dicatat, samakan daftar di Beranda dan tab Pengumuman
    // supaya pengumuman baru ikut tampil tanpa refresh manual.
    if (Get.isRegistered<PengumumanController>()) {
      Get.find<PengumumanController>().weeklyPengumumanList.assignAll(
        hasil.data,
      );
    }
  } catch (e) {
    debugPrint('ERROR SINKRON PENGUMUMAN: $e');
  }
}
```

Poin bicara: "Rentang minggunya memakai fungsi yang sama dengan Beranda
(`getWeeklyDateRange`, Senin sampai Minggu), jadi aturan tampilnya konsisten.
`periksaPengumuman` dipanggil **sebelum** daftar diganti agar tidak terjadi
notifikasi dobel."

### 4.6 HP: membandingkan ID dan membuat notifikasi

`notifikasi_controller.dart` baris 259-290:

```dart
Future<void> periksaPengumuman(List<Pengumuman> daftar) async {
  if (_idUser.isEmpty || daftar.isEmpty) return;

  final idSekarang = daftar.map((p) => p.id).toSet();
  final prefs = await SharedPreferences.getInstance();

  // Pertama kali: catat saja sebagai keadaan awal.
  if (_pengumumanDikenal == null) {
    _pengumumanDikenal = idSekarang;
    await prefs.setStringList('notif_peng_$_idUser', idSekarang.toList());
    return;
  }

  final baru = <NotifikasiItem>[];
  for (final p in daftar) {
    if (!_pengumumanDikenal!.contains(p.id)) {
      baru.add(_buat(
        TipeNotifikasi.pengumuman,
        'Pengumuman baru',
        p.judul,
      ));
    }
  }

  _pengumumanDikenal = {..._pengumumanDikenal!, ...idSekarang};
  await prefs.setStringList(
    'notif_peng_$_idUser',
    _pengumumanDikenal!.toList(),
  );

  await _tambah(baru);
}
```

Poin bicara (3 hal penting):
- "`_pengumumanDikenal` adalah daftar ID yang sudah pernah dilihat HP."
- "Sinkron **pertama kali** hanya mencatat, tidak memunculkan notifikasi, supaya
  pengumuman lama tidak membanjiri layar."
- "ID yang sudah dikenal dilewati, jadi satu pengumuman hanya memunculkan satu
  notifikasi. Daftar ID disimpan di HP (`SharedPreferences`) sehingga tetap
  diingat walau aplikasi ditutup."

### 4.7 HP: menyimpan dan menampilkan notifikasi

`notifikasi_controller.dart` baris 306-317 dan 371-381 (diringkas):

```dart
Future<void> _tambah(List<NotifikasiItem> baru) async {
  if (baru.isEmpty) return;

  items.insertAll(0, baru);
  if (items.length > maksTersimpan) {
    items.removeRange(maksTersimpan, items.length);
  }

  await _simpanItems();
  _hitungBelumDibaca();
  _tampilkanPopup(baru);
}

Future<void> _simpanItems() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(
    'notif_items_$_idUser',
    jsonEncode(items.map((e) => e.toJson()).toList()),
  );
}
```

Poin bicara: "Notifikasi baru masuk ke daftar (lonceng), jumlah belum dibaca
dihitung ulang, lalu pop up ditampilkan. Daftar notifikasi juga disimpan di HP,
jadi tetap ada saat aplikasi dibuka lagi."

### 4.8 HP: ketuk notifikasi -> pindah ke tab Pengumuman

`notifikasi_controller.dart` baris 389-394:

```dart
/// Buka tujuan dari sebuah notifikasi: laporan -> Riwayat, pengumuman -> Pengumuman.
void bukaTujuan(NotifikasiItem n) {
  tandaiDibaca(n.id);
  Get.back();
  Get.find<NavController>().changeTabIndex(n.terkaitLaporan ? 1 : 2);
}
```

Poin bicara: "Notifikasi laporan membuka tab Riwayat (indeks 1), notifikasi
pengumuman membuka tab Pengumuman (indeks 2)."

### 4.9 HP: pemicu tambahan dari Beranda

`lib/features/home/home_screen.dart` baris 86-92:

```dart
// [PERUBAHAN 18-11-2026] Pengumuman baru minggu ini -> notifikasi
_pengumumanWorker = ever(
  pengumumanController.weeklyPengumumanList,
  (_) => notifController.periksaPengumuman(
    pengumumanController.weeklyPengumumanList.toList(),
  ),
);
```

Poin bicara: "Ini jalur lama: setiap kali daftar pengumuman Beranda berubah,
langsung diperiksa. Sekarang daftar itu juga diperbarui oleh sinkron 60 detik,
jadi dua jalur ini saling melengkapi tanpa dobel."

---

## 5. Kenapa aman (tidak dobel, tidak mengganggu fitur lain)

1. **Anti-dobel**: ID pengumuman dicatat di HP. Pengecekan kedua dan seterusnya
   melewati ID yang sudah dikenal.
2. **Sinkron pertama senyap**: login di HP baru tidak memunculkan notifikasi
   untuk semua pengumuman lama.
3. **Tidak mengganggu laporan**: pengecekan laporan dan pengumuman dipisah;
   error di satu bagian tidak mematikan bagian lain.
4. **Tidak menambah permintaan ganda**: data pengumuman hasil sinkron langsung
   dipakai untuk Beranda dan tab Pengumuman, jadi tidak perlu fetch lagi.
5. **Hemat penyimpanan**: notifikasi dibatasi maksimal 100 item terakhir.
6. **Satu akun satu riwayat**: nama kunci penyimpanan memakai ID user
   (`notif_peng_<idUser>`, `notif_items_<idUser>`), sehingga ganti akun tidak
   tercampur.

---

## 6. Batasan dan pengembangan lanjutan

- Notifikasi hanya muncul saat **aplikasi sedang dibuka**. Saat aplikasi dibuka
  lagi, pengumuman yang terlewat tetap dimunculkan (karena ada sinkron saat resume).
- Notifikasi saat aplikasi **tertutup** memerlukan push dari server (Firebase
  Cloud Messaging/FCM): perlu kredensial Firebase, kolom token perangkat di
  `users_mobile`, dan pengiriman dari server. Ini sudah tercatat sebagai
  BUG-03 di `BUG_REPORT.md`.
- Tidak ada biaya tambahan dan tidak ada server notifikasi baru untuk versi
  yang dipakai sekarang.

---

## 7. Tanya-jawab sidang

**"Kenapa tidak langsung (realtime)?"**
> Karena supaya tidak ketergantungan layanan tambahan seperti Firebase. HP
> mengecek lewat API tiap 60 detik; pengumuman baru muncul paling lambat
> 1 menit. Ini paling sederhana dan cukup untuk kebutuhan proyek.

**"Bagaimana memastikan notifikasi tidak dobel?"**
> ID pengumuman yang sudah pernah dilihat disimpan di HP. Saat pengecekan
> berikutnya, ID itu dilewati. Selain itu, pemeriksaan dilakukan **sebelum**
> daftar pengumuman di Beranda diganti.

**"Kalau aplikasi ditutup, apakah pengumuman hilang?"**
> Tidak. Data ada di database. Saat aplikasi dibuka lagi, sinkron langsung
> berjalan dan pengumuman yang belum pernah dilihat dimunculkan.

**"Apakah website dan mobile saling terhubung langsung?"**
> Tidak langsung. Keduanya memakai database yang sama: website menulis, API
> membaca, mobile mengecek lewat API. Pola ini disebut polling.

**"Kenapa hanya pengumuman minggu ini?"**
> Itu aturan fitur Beranda (Senin–Minggu). Walaupun begitu, pengumuman yang
> baru dikirim tetap terdeteksi karena API juga memeriksa waktu dibuat
> (`created_at`), bukan hanya tanggal kegiatan.

**"Apa bedanya notifikasi dan pop up di sini?"**
> Notifikasi adalah item yang masuk ke daftar lonceng dan tersimpan di HP.
> Pop up adalah tampilan singkat di bagian atas layar saat notifikasi baru
> masuk. Keduanya berasal dari data yang sama.

---

## 8. Langkah demo saat sidang

1. Buka aplikasi mobile, biarkan di tab **Riwayat** atau **Akun** (jangan di Beranda).
2. Di website admin kabupaten: menu Input Pengumuman -> tambah pengumuman
   bertanggal hari ini -> Simpan.
3. Tunggu maksimal 1 menit (timer sinkron 60 detik).
4. Muncul pop up "Pengumuman baru: <judul>"; angka di lonceng bertambah.
5. Ketuk notifikasi -> aplikasi pindah ke tab **Pengumuman** dan judulnya terlihat.
6. (Opsional) Buka aplikasi notifikasi HP lalu tutup lagi: tidak muncul notifikasi
   baru untuk pengumuman yang sama (bukti tidak dobel).

---

## 9. Daftar istilah

| Istilah | Arti sederhana |
|---|---|
| Database | Tempat penyimpanan data bersama milik website dan mobile |
| Tabel `pengumumen` | Daftar semua pengumuman yang disimpan website |
| API | Pintu/jembatan agar mobile bisa membaca data dari website |
| GET | Permintaan membaca data (tidak mengubah data) |
| JSON | Format data yang dikirim API ke mobile |
| Polling | HP mengecek berulang secara berkala (di sini tiap 60 detik) |
| Push (FCM) | Server yang langsung mengirim pesan ke HP (belum dipakai) |
| `SharedPreferences` | Penyimpanan kecil di HP untuk mengingat data antar sesi |
| Pop up | Tampilan singkat di atas layar saat notifikasi baru masuk |
| Timer | Pewaktu di aplikasi yang memicu pengecekan tiap 60 detik |
