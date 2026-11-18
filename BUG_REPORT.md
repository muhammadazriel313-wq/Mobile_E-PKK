# LAPORAN TEMUAN BUG PENGUJIAN SISTEM E-PKK (WEBSITE & MOBILE)

Dokumen ini memuat daftar temuan bug, anomali, dan ketidaksesuaian fungsional yang teridentifikasi selama pelaksanaan pengujian perangkat lunak sistem E-PKK (Website Laravel + Mobile Flutter) berdasarkan skenario pengujian pada `Tes Scenario & Tes Case.xlsx`.

---

## Ringkasan Temuan

| ID Bug | Test Case Terkait | Judul Temuan | Tingkat Keparahan | Status |
| :--- | :---: | :--- | :---: | :---: |
| **BUG-01** | TC08, TC13 | Tipe Data Kolom `dusun_lingkungan` Integer Memicu Error SQL 1366 Saat Diinput Nama Dusun/Teks | **High** | Teridentifikasi |
| **BUG-02** | TC16 | Ketiadaan Validasi Logika Bisnis Demografi (Jumlah KK Lebih Besar Dari Jumlah Jiwa/Warga) | **Low** | Teridentifikasi |
| **BUG-03** | TC25 | Layanan Push Notifikasi (FCM) Belum Terintegrasi Saat Perubahan Status Laporan di Web | **Medium** | Teridentifikasi |
| **BUG-04** | TC26 | Ketiadaan Penyimpanan Draf Lokal (Offline Storage) Saat Pengiriman Laporan Terputus Jaringan | **Medium** | Teridentifikasi |

---

## Rincian Temuan Bug

### 1. BUG-01: Tipe Kolom `dusun_lingkungan` Integer Memicu Error SQL 1366 Saat Diinput Nama Dusun/Teks
- **Test Case Terkait:** TC08 (Kirim Laporan Umum lengkap), TC13 (Input angka valid)
- **Tingkat Keparahan:** **High**
- **Komponen:** Backend API Laravel (`ReportController::storeLaporanUmum`) & Skema Database MySQL (`laporan_umum`)
- **Langkah Reproduksi:**
  1. Buka aplikasi mobile atau lakukan HTTP request ke endpoint `POST /api/report/laporan-umum`.
  2. Isi payload JSON laporan umum dengan parameter `dusun_lingkungan` berupa nama wilayah dusun (contoh: `"Dusun Krajan"` atau `"Dusun Barat"`).
  3. Kirimkan permintaan ke server.
- **Hasil yang Diharapkan:**
  Nama dusun/lingkungan tersimpan sebagai teks identitas wilayah, atau jika kolom tersebut dimaksudkan sebagai jumlah kuantitatif dusun, sistem memberikan validasi format yang jelas tanpa menyebabkan crash SQL.
- **Hasil Aktual:**
  Server mengembalikan respons HTTP 500 Internal Server Error dengan pesan galat database:
  ```json
  {
    "statusCode": 500,
    "message": "Gagal menyimpan laporan umum",
    "error": {
      "message": "SQLSTATE[22007]: Invalid datetime format: 1366 Incorrect integer value: 'Dusun Krajan' for column `pkklur`.`laporan_umum`.`dusun_lingkungan` at row 1"
    }
  }
  ```
- **Dugaan Lokasi Kode Penyebab:**
  1. Skema tabel database `laporan_umum`: kolom `dusun_lingkungan` didefinisikan sebagai `int(11)`.
  2. Controller [`app/Http/Controllers/Api/ReportController.php`](file:///c:/xampp/htdocs/Website_E-PKK/app/Http/Controllers/Api/ReportController.php#L233):
     ```php
     'dusun_lingkungan' => $request->dusun_lingkungan ?? '',
     ```
     Jika string teks diterima, MySQL mode strict menolak konversi string teks ke tipe integer.

---

### 2. BUG-02: Ketiadaan Validasi Logika Bisnis Demografi (Jumlah KK > Jumlah Jiwa)
- **Test Case Terkait:** TC16 (Jumlah warga lebih kecil dari jumlah KK)
- **Tingkat Keparahan:** **Low**
- **Komponen:** Validasi Form Flutter (`laporan_umum1_screen.dart`, `laporan_umum2_screen.dart`) & Backend API (`ReportController::storeLaporanUmum`)
- **Langkah Reproduksi:**
  1. Buka formulir Laporan Umum di aplikasi mobile.
  2. Pada tahap 1 (Jumlah Kelompok & Rumah Tangga), input nilai **KK = 100**.
  3. Lanjutkan ke tahap 2 (Jumlah Jiwa / Anggota), input nilai **Jiwa Laki-laki = 5** dan **Jiwa Perempuan = 5** (Total Jiwa = 10).
  4. Lanjutkan pengisian hingga selesai dan tekan tombol **Kirim**.
- **Hasil yang Diharapkan:**
  Aplikasi atau backend menampilkan pesan validasi peringatan logis, misalnya: *"Jumlah total jiwa/warga tidak boleh lebih kecil dari jumlah Kepala Keluarga (KK)"*, dan menahan pengiriman data anomali.
- **Hasil Aktual:**
  Tidak ada pemeriksaan komparatif sama sekali. Data dengan 100 KK dan 10 jiwa lolos validasi, terkirim ke server dengan status HTTP 200, dan tersimpan ke database.
- **Dugaan Lokasi Kode Penyebab:**
  - File validasi mobile: `ValidatorForm` pada [`lib/core/validators/validator_form.dart`](file:///d:/42.%20SEMESTER%203/project/Mobile_E-PKK/lib/core/validators/validator_form.dart) hanya memeriksa nilai non-kosong dan format angka (`^[0-9]+$`).
  - File validasi API: [`ReportController.php:220-224`](file:///c:/xampp/htdocs/Website_E-PKK/app/Http/Controllers/Api/ReportController.php#L220-L224) belum menerapkan aturan validasi bersyarat lintas atribut (misal: `'jiwa_laki' => 'required|numeric'`).

---

### 3. BUG-03: Layanan Push Notifikasi (FCM) Belum Terintegrasi Saat Perubahan Status Laporan di Web
- **Test Case Terkait:** TC25 (Notifikasi perubahan status laporan)
- **Tingkat Keparahan:** **Medium**
- **Komponen:** Backend Web Controller (`PenghayatanController.php`, `GotongRoyongController.php`, dsb.)
- **Langkah Reproduksi:**
  1. Kader mengirimkan laporan dari aplikasi mobile (status awal tersimpan sebagai `'Proses'`).
  2. Akun pemeriksa (Kecamatan atau Kabupaten) login ke dashboard web dan membuka halaman verifikasi laporan.
  3. Pemeriksa mengubah status laporan menjadi `'Disetujui1'` (Kecamatan) atau `'Disetujui2'` (Kabupaten) atau `'Revisi'` disertai catatan evaluasi.
  4. Periksa perangkat ponsel kader yang memiliki `fcm_token` aktif di tabel `users_mobile`.
- **Hasil yang Diharapkan:**
  Perangkat kader menerima notifikasi push (Firebase Cloud Messaging) yang memberitahukan pembaruan status laporan secara langsung.
- **Hasil Aktual:**
  Tidak ada notifikasi push yang terkirim ke perangkat kader. Perubahan status hanya tersimpan secara pasif di database lokal, dan kader baru mengetahui status laporannya jika berinisiatif membuka aplikasi dan memuat ulang menu Riwayat.
- **Dugaan Lokasi Kode Penyebab:**
  Method `update()` pada seluruh controller verifikasi backend (contoh: [`app/Http/Controllers/backend/PenghayatanController.php:83-103`](file:///c:/xampp/htdocs/Website_E-PKK/app/Http/Controllers/backend/PenghayatanController.php#L83-L103)) hanya menjalankan query database update:
  ```php
  $data->update([
      'status' => $status,
      'catatan' => $request->catatan,
  ]);
  ```
  Belum terdapat service helper FCM atau pengiriman notifikasi ke token `fcm_token` pengguna terkait.

---

### 4. BUG-04: Ketiadaan Penyimpanan Draf Lokal (Offline Storage) Saat Pengiriman Laporan Terputus Jaringan
- **Test Case Terkait:** TC26 (Kirim laporan saat internet terputus)
- **Tingkat Keparahan:** **Medium**
- **Komponen:** Arsitektur Mobile Flutter (`ApiHelper`, Controller Form Laporan)
- **Langkah Reproduksi:**
  1. Buka formulir laporan (contoh: Laporan Umum atau Laporan Pokja).
  2. Isi seluruh field formulir yang panjang.
  3. Matikan koneksi WiFi dan data seluler pada perangkat ponsel / emulator.
  4. Tekan tombol **Kirim**.
  5. Tutup aplikasi atau tekan tombol kembali (*Back*).
  6. Buka kembali halaman formulir.
- **Hasil yang Diharapkan:**
  Aplikasi menampilkan pesan gagal kirim koneksi dan menyimpan draf isian formulir ke penyimpanan lokal (SQLite/Hive/SharedPreferences), sehingga kader dapat mengirim ulang draf tanpa kehilangan input data.
- **Hasil Aktual:**
  Aplikasi hanya menampilkan snackbar error koneksi (`"Tidak ada koneksi internet"` / `DioException: connection error`). Tidak ada penyimpanan draf otomatis. Jika pengguna keluar dari layar form, seluruh data yang sudah diketik hilang total dan wajib diinput ulang dari awal.
- **Dugaan Lokasi Kode Penyebab:**
  Proyek Flutter `Mobile_E-PKK` belum mengadopsi mekanisme *Offline-First* atau *Draft Cache Repository*. Dependensi lokal storage yang tersedia di `pubspec.yaml` hanya `shared_preferences` untuk menyimpan profil user, belum ada implementasi tabel draf lokal (misal menggunakan package `sqflite` atau `hive`).
