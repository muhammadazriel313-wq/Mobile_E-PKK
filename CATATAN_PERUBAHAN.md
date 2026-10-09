# Catatan Perubahan - Mobile E-PKK

Dokumen ini mencatat seluruh perubahan pada aplikasi Mobile E-PKK sesuai ketentuan Prompt 0 dan arahan pengembangan fitur Bantuan.

---

## [08-10-2026] - Penambahan Fitur Bantuan pada Halaman Akun

### 1. Tujuan
Menambahkan halaman statis "Bantuan" yang dapat diakses melalui menu Akun/Profil untuk memandu kader dan pengguna aplikasi Mobile E-PKK dalam memahami alur pelaporan, arti status, solusi kendala umum, informasi kontak admin resmi, dan spesifikasi versi aplikasi.

### 2. File yang Ditambahkan / Dimodifikasi

#### A. `pubspec.yaml`
- **Perubahan**: Menambahkan dependency `url_launcher: ^6.3.0` pada bagian `dependencies`.
- **Alasan**: Mendukung pembukaan tautan WhatsApp secara eksternal (`https://wa.me/...`) dari aplikasi Flutter.
- **Kesesuaian**: Kompatibel dengan Flutter SDK `>=3.0.0` dan Dart SDK `^3.1.0` yang digunakan pada proyek ini. Perintah `flutter pub get` dijalankan dengan sukses.

#### B. `android/app/src/main/AndroidManifest.xml`
- **Perubahan**: Menambahkan blok `<queries>` di dalam tag `<manifest>`:
  - Skema `https` dengan host `api.whatsapp.com` dan `wa.me`
  - Skema `tel`
  - Paket aplikasi WhatsApp resmi (`com.whatsapp`) dan WhatsApp Business (`com.whatsapp.w4b`)
- **Alasan**: Memenuhi persyaratan visibilitas paket (Package Visibility) pada Android 11 (API level 30) ke atas agar fungsi `canLaunchUrl` dan `launchUrl` dapat mendeteksi dan membuka aplikasi WhatsApp.

#### C. `lib/features/akun/bantuan_screen.dart` (File Baru)
- **Perubahan**: Membuat layar Bantuan statis (`BantuanScreen`) dengan komponen desain yang selaras dengan tema aplikasi (warna utama `#3F8FC1`, latar belakang `#F8FAFC`, `AppBarPrimary`, kontainer kartu berbayang halus, dan `ExpansionTile`).
- **Isi Konten**:
  1. **Konstanta Data Pengembang & Layanan**:
     - `adminWhatsAppNumber`: bernilai `'[belum diisi]'` (konstanta mudah diganti).
     - `serviceHours`: bernilai `'[belum diisi]'`.
     - `developerName`: bernilai `'[belum diisi]'`.
     - `appVersion`: diselaraskan dengan `pubspec.yaml` yaitu `'1.0.0+1'`, disertai komentar agar diperbarui bersamaan.
  2. **Panduan Cepat**:
     - 6 langkah urut: Masuk ke akun, Memilih bidang, Mengisi dan mengirim laporan, Menambah foto kegiatan, Melihat riwayat, dan Mengubah kata sandi.
     - Penjelasan alur verifikasi peran: laporan kader Desa diverifikasi bertahap oleh pihak Kecamatan lalu Kabupaten, sedangkan laporan kader Kecamatan langsung diverifikasi Kabupaten.
  3. **Arti Status Laporan**:
     - Nama status diselaraskan sama persis dengan yang tampil pada `riwayat_screen.dart` dan `detail_laporan_screen.dart`:
       - `Sedang Diproses`
       - `Disetujui Kecamatan`
       - `Disetujui Kabupaten`
       - `Dibatalkan`
       - `Revisi`
  4. **Pertanyaan Umum (FAQ)**:
     - Verifikasi filter Riwayat: tab filter `Proses`, `Revisi`, dan `Selesai` sesuai implementasi di `riwayat_screen.dart`.
     - Ketentuan edit & batal laporan: hanya dapat dilakukan ketika laporan berstatus `Sedang Diproses`.
     - Laporan dengan revisi: dijelaskan bahwa laporan berstatus revisi tidak dapat diedit ulang langsung di formulir lama, melainkan kader membaca catatan revisi lalu membuat dan mengirimkan laporan baru.
     - Pengubahan nomor HP: diverifikasi benar ada pada menu `Profil > Informasi Akun > Nomor HP > Simpan Perubahan`.
     - Solusi lupa kata sandi dan kendala unggah foto kegiatan.
  5. **Hubungi Admin WhatsApp**:
     - Membuka tautan WhatsApp dengan pesan pembuka otomatis memuat nama kader, nomor HP, dan peran.
     - Penanganan kesalahan (fallback): jika WhatsApp tidak terpasang atau gagal dibuka, aplikasi menampilkan dialog informatif dan tombol `Salin Nomor` ke papan klip (*clipboard*).
     - Jika konstanta nomor bernilai `'[belum diisi]'`, aplikasi menampilkan dialog pemberitahuan bahwa kontak belum diatur, tanpa memicu error crash.
  6. **Tentang Aplikasi**:
     - Menampilkan nama aplikasi (E-PKK Kabupaten Nganjuk), versi aplikasi, dan nama pengembang.
  7. **Kepatuhan Penulisan**:
     - Seluruh teks bahasa Indonesia ditulis tanpa tanda seru (`!`), menggunakan kalimat aktif yang ringkas, dan kapitalisasi huruf yang tepat.

#### D. `lib/routes/app_routes.dart`
- **Perubahan**:
  - Mengimpor `bantuan_screen.dart` pada kelompok `// ===== PROFILE =====`.
  - Mendaftarkan rute `static const BANTUAN = '/bantuan';`.
  - Menambahkan `GetPage(name: Routes.BANTUAN, page: () => const BantuanScreen())` ke daftar `AppPages.pages`.
- **Alasan**: Memungkinkan navigasi berbasis nama menggunakan GetX (`Get.toNamed(Routes.BANTUAN)`).

#### E. `lib/features/akun/profile_screen.dart`
- **Perubahan**: Menambahkan `CardButtonRow` untuk menu "Bantuan" dengan ikon `Icons.help_outline_rounded` di antara tombol "Ubah Kata Sandi" dan tombol "Keluar".
- **Alasan**: Menempatkan menu Bantuan pada posisi yang mudah dijangkau pengguna di halaman Akun/Profil sesuai spesifikasi rancangan.

---

### 3. Integritas Kode & Aturan Prompt 0
- Tidak menghapus kode lama; penambahan diberi anotasi `[PERUBAHAN 08-10-2026]`.
- Tidak mengubah struktur atau nama rute yang sudah ada sebelumnya.
- Tidak mengekspos token, password, maupun nilai `.env`.

---

## [08-10-2026] - Penambahan Fitur Foto Profil Pengguna (Desa & Kecamatan)

### 1. Tujuan
Memungkinkan kader dan pengguna mobile (Desa dan Kecamatan) untuk menambah, melihat, dan mengganti foto profil akun mereka melalui halaman Informasi Akun, yang secara langsung tampil pada kartu profil di halaman Akun dan avatar halaman Informasi Akun.

### 2. Basis Data (Database)
- **Cadangan (Backup)**: Dibuat menggunakan `mysqldump` sebelum migrasi ke berkas luar proyek `C:\backup_db\pkklur_backup_20261008_1521.sql` (ukuran 257.028 byte).
- **Perubahan Skema**:
  ```sql
  ALTER TABLE `users_mobile` ADD COLUMN `foto` VARCHAR(255) NULL AFTER `full_name`;
  ```
- **Integritas**: Seluruh data pengguna lama (26 baris) bernilai `NULL` secara otomatis tanpa ada perubahan pada kolom lain.

### 3. Backend API (`Website_E-PKK`)
- **`routes/api.php`**:
  - Mendaftarkan rute `POST /api/profile/photo` memanggil `ProfileController@updatePhoto`.
- **`app/Http/Controllers/Api/ProfileController.php`**:
  - `getProfile`: Menambahkan kolom `foto` pada query SELECT dan mengonversinya menjadi URL penuh (`$request->getSchemeAndHttpHost() . '/storage/profile/' . $data->foto`) atau `null` jika belum ada.
  - `updatePhoto`: Endpoint multipart baru menerima `id_user` dan `foto`. Dilengkapi validasi berkas gambar (jpeg, jpg, png, webp) maksimal 2 MB. Menghapus berkas foto lama pengguna saat diganti, menyimpan berkas baru secara acak aman ke `public/storage/profile/`, dan memperbarui basis data.
  - Endpoint `updateProfile` dibiarkan utuh tanpa perubahan.

### 4. Aplikasi Mobile Flutter (`Mobile_E-PKK`)
- **`lib/features/akun/profile_model.dart`**:
  - Menambahkan field `final String? foto;` pada model `Profil`.
  - Memperbarui `Profil.fromJson` dan method `copyWith`.
- **`lib/features/akun/profile_controller.dart`**:
  - Menambahkan observable `isUploadingPhoto`.
  - Menambahkan fungsi `uploadProfilePhoto()` menggunakan Dio multipart ke `/profile/photo`.
  - Menerapkan cache busting query parameter (`?v={timestamp}`) pada URL foto agar antarmuka seketika menampilkan foto baru.
- **`lib/features/akun/informasi_akun.dart`**:
  - Avatar reaktif menampilkan foto via `Image.network` (dengan `loadingBuilder` dan `errorBuilder` fallback ke ikon `Icons.person`).
  - Menambahkan tombol kamera di sudut kanan bawah avatar dengan dialog pemilihan "Kamera" dan "Galeri" (`image_picker`, kualitas 70, lebar maks 800).
  - Dilengkapi indikator pemuatan melingkar saat proses unggah berlangsung.
- **`lib/features/akun/profile_screen.dart`**:
  - Menampilkan foto profil pengguna pada kartu profil utama dengan fallback ke ikon `Icons.account_circle`.
- **Kaidah Bahasa**: Kalimat ringkas bahasa Indonesia, tanpa tanda seru (`!`).

---

## [08-10-2026] - Perbaikan Pratinjau Foto Profil & Integrasi Tombol Simpan Perubahan

### 1. Masalah yang Ditemukan
1. **Foto Tidak Muncul Saat Dipilih dari Galeri**:
   - Pemilihan foto tidak menyimpan state lokal (`Uint8List` / `XFile`) pada widget, sehingga tampilan avatar tetap kosong / memakai ikon default.
   - Pada browser Chrome (`flutter run -d chrome`), pemanggilan berkas statis `/storage/profile/...` melalui `php artisan serve` diblokir oleh kebijakan CORS (tidak ada header `Access-Control-Allow-Origin`), sehingga `Image.network` gagal memuat dan beralih ke ikon fallback.
2. **Foto Tidak Tersimpan Saat Klik "Simpan Perubahan"**:
   - Tombol "Simpan Perubahan" sebelumnya hanya memanggil `updateProfileInfo` (nama dan nomor telepon) tanpa mengunggah berkas foto yang telah dipilih pengguna.

### 2. Solusi & Perubahan yang Diterapkan

#### A. Backend API (`Website_E-PKK`)
- **`routes/api.php`**:
  - Menambahkan route `Route::get('/profile/photo/{filename}', [ProfileController::class, 'getPhoto'])`.
- **`app/Http/Controllers/Api/ProfileController.php`**:
  - Menambahkan method `getPhoto($filename)` yang melayani berkas gambar dari `public/storage/profile/` lengkap dengan header CORS:
    - `Access-Control-Allow-Origin: *`
    - `Access-Control-Allow-Methods: GET, OPTIONS`
  - Memperbarui `getProfile` dan `updatePhoto` agar URL foto mengarah ke `/api/profile/photo/{filename}` dengan jaminan kompatibilitas di Chrome maupun Android Emulator.

#### B. Frontend Mobile Flutter (`Mobile_E-PKK`)
- **`lib/features/akun/informasi_akun.dart`**:
  - Menambahkan state `_selectedImageFile` dan `_selectedImageBytes` pada `_InfoAkunScreenState`.
  - Fungsi `_ambilFoto` seketika membaca bytes gambar (`await pickedFile.readAsBytes()`) dan memicu `setState`, sehingga avatar menampilkan `Image.memory(_selectedImageBytes!)` secara instan tanpa menunggu jaringan.
  - Tombol "Simpan Perubahan" diintegrasikan untuk mengunggah `_selectedImageFile` melalui `controller.uploadProfilePhoto()` terlebih dahulu, kemudian menyimpan data nama dan nomor telepon via `updateProfileInfo()`.
  - Mengosongkan state foto lokal setelah penyimpanan berhasil dan menampilkan umpan balik keberhasilan.
- **`lib/features/akun/profile_controller.dart`**:
  - `uploadProfilePhoto` kini mendukung pembacaan byte data (`dio.MultipartFile.fromBytes`) lintas platform (Web dan Mobile).
  - Mengambil ID pengguna secara tangguh melalui `PreferencesService` bila ID pada state observable belum terisi.
  - Menambahkan parameter `showSuccessSnackbar` untuk mencegah penumpukan snackbar ganda saat disimpan bersamaan melalui tombol "Simpan Perubahan".

---

## [08-10-2026] - Penambahan Fitur Hapus Foto Profil (Model WhatsApp)

### 1. Tujuan
Memungkinkan pengguna untuk menghapus foto profil yang sedang terpasang atau membatalkan pilihan foto baru, sehingga profil dapat kembali tanpa foto profil (ikon default) seperti pada aplikasi WhatsApp.

### 2. File yang Dimodifikasi

#### A. Backend API (`Website_E-PKK`)
- **`routes/api.php`**:
  - Mendaftarkan rute `POST /api/profile/photo/delete` dan `DELETE /api/profile/photo` memanggil `ProfileController@deletePhoto`.
- **`app/Http/Controllers/Api/ProfileController.php`**:
  - Menambahkan metode `deletePhoto(Request $request)`:
    - Memvalidasi ID pengguna.
    - Menghapus berkas gambar fisik dari folder `public/storage/profile/` jika berkas lama ada di server.
    - Memperbarui kolom `foto` pada tabel `users_mobile` menjadi `NULL`.
    - Mengembalikan respons JSON status 200 dengan data foto `null`.

#### B. Frontend Mobile Flutter (`Mobile_E-PKK`)
- **`lib/features/akun/profile_controller.dart`**:
  - Menambahkan metode `deleteProfilePhoto()`:
    - Mengirim permintaan POST ke `/profile/photo/delete`.
    - Memperbarui data reaktif `profilData.value` lokal dengan `foto = null`.
    - Menampilkan notifikasi snackbar 'Foto profil berhasil dihapus'.
- **`lib/features/akun/informasi_akun.dart`**:
  - Pada dialog **Ganti Foto Profil** (`_pilihSumberFoto`), menambahkan opsi **Hapus Foto** di bagian paling bawah dengan ikon tempat sampah merah (`Icons.delete_outline_rounded`), yang tampil ketika pengguna memiliki foto profil (baik foto tersimpan di server maupun pratinjau lokal yang baru dipilih).
  - Menambahkan dialog konfirmasi `_konfirmasiHapusFoto()` ("Hapus Foto Profil? Apakah Anda yakin ingin menghapus foto profil?") dengan tombol Batal dan Hapus.
  - Saat dikonfirmasi, pratinjau lokal seketika dibersihkan dan foto di server dihapus, mengembalikan tampilan avatar ke ikon orang bawaan.

---

## [08-10-2026] - Pengumuman Mingguan (Beranda & Tab) dan Kalender Riwayat Pengumuman

### 1. Tujuan
1. **Beranda Mobile & Tab Pengumuman**: Bagian pengumuman hanya menampilkan pengumuman "Minggu Ini" (Senin 00:00 s.d. Minggu 23:59 WIB). Pergantian minggu terjadi otomatis pada hari Senin pukul 00:00 WIB tanpa memerlukan tindakan dari pengguna. Pengumuman minggu-minggu sebelumnya tetap tersimpan di basis data.
2. **Kalender Riwayat Pengumuman**: Menyediakan halaman riwayat dengan tampilan kalender bulanan (dimulai hari Senin). Tanggal yang memiliki agenda pengumuman ditandai dengan ikon pengumuman kecil pudar (gaya arsip Instagram). Menekan tanggal menampilkan daftar pengumuman pada hari tersebut, dan kartu pengumuman dapat ditekan untuk melihat detail melalui dialog yang sudah ada.
3. **Penyempurnaan API Pengumuman**: Mendukung parameter opsional `dari`, `sampai` (rentang tanggal format `YYYY-MM-DD`), dan `bulan` (format `YYYY-MM`). Pemanggilan tanpa parameter tetap berperilaku sama persis seperti semula. Pemanggilan berfilter yang tidak menghasilkan data mengembalikan HTTP 200 dengan `data: []`.
4. **Aturan "Minggu Ini" (Opsi C)**: Pengumuman tampil bila `tanggalPengumuman` berada di minggu berjalan ATAU `created_at` berada di minggu berjalan setelah dikonversi dari UTC ke WIB (`DATE_ADD(created_at, INTERVAL 7 HOUR)`). Kalender riwayat secara murni memakai `tanggalPengumuman`.

---

### 2. File yang Dimodifikasi & Ditambahkan

#### A. Backend API (`Website_E-PKK`)
- **`app/Http/Controllers/Api/AnnouncementController.php`**:
  - Menambahkan dukungan parameter opsional `dari`, `sampai`, dan `bulan` pada method `index(Request $request)`.
  - Menerapkan validasi format `YYYY-MM-DD` untuk `dari` dan `sampai`, serta `YYYY-MM` untuk `bulan`.
  - Mengimplementasikan filter rentang tanggal (Opsi C):
    ```sql
    WHERE tanggalPengumuman BETWEEN ? AND ?
       OR DATE(DATE_ADD(created_at, INTERVAL 7 HOUR)) BETWEEN ? AND ?
    ```
  - Mengimplementasikan filter bulan khusus kalender:
    ```sql
    WHERE DATE_FORMAT(tanggalPengumuman, '%Y-%m') = ?
    ```
  - Penanganan respons:
    - Jika berfilter dan data kosong: mengembalikan status 200 dengan `data: []`.
    - Jika tanpa filter dan data kosong: tetap mengembalikan status 404 (perilaku asli tidak berubah).

#### B. Frontend Mobile Flutter (`Mobile_E-PKK`)
- **`lib/features/pengumuman/pengumuman_controller.dart`**:
  - Menambahkan method utilitas `getWeeklyDateRange([DateTime? referenceDate])` untuk menghitung batas Senin 00:00:00 WIB s.d. Minggu 23:59:59 WIB secara presisi.
  - Menambahkan method `loadWeeklyPengumuman({bool isRefresh = false})` yang memanggil `GET /api/announcement?dari={senin}&sampai={minggu}&limit=50`.
  - Menangani `DioException` status 404 maupun respons `data: []` sebagai daftar kosong (`[]`), bukan sebagai pesan error.
  - Menambahkan method `loadPengumumanBulan(DateTime monthDate)` untuk mengambil seluruh agenda pengumuman pada bulan terkait (`GET /api/announcement?bulan={YYYY-MM}&limit=100`).
  - Menambahkan observable: `weeklyPengumumanList`, `isWeeklyLoading`, `weeklyErrorMessage`, `monthlyPengumumanList`, `isMonthlyLoading`, `monthlyErrorMessage`.
- **`lib/common/appbar/custom_appbar.dart`**:
  - Menambahkan parameter opsional `actionIcon` (default `Icons.filter_alt_rounded`) dan `actionWidget` pada `CustomeAppBar` dan `AppBarPrimary` dengan backward compatibility 100% tanpa merusak halaman lain.
- **`lib/features/pengumuman/pengumuman_screen.dart`**:
  - Mengubah tampilan utama agar menyajikan daftar pengumuman mingguan (`weeklyPengumumanList`).
  - Mengarahkan tombol aksi kanan atas `AppBarPrimary` dengan ikon `Icons.calendar_month_outlined` untuk membuka halaman Riwayat Pengumuman (`Routes.RIWAYAT_PENGUMUMAN`).
  - Menyediakan tampilan kosong (*soft empty state*) dengan pesan ramah "Belum ada pengumuman minggu ini" serta tombol navigasi cepat ke Riwayat Pengumuman.
- **`lib/features/pengumuman/riwayat_pengumuman_screen.dart`** (File Baru):
  - Membangun kalender bulanan kustom tanpa penambahan package eksternal (menggunakan `intl` yang sudah terpasang).
  - Tampilan grid hari dimulai dari Senin, dengan nama hari dan bulan berbahasa Indonesia.
  - Tanggal dengan agenda pengumuman menampilkan ikon megafon kecil pudar (`Icons.campaign_outlined`, opacity 0.45).
  - Menampilkan daftar kartu pengumuman untuk tanggal yang dipilih di bawah kalender.
  - Membuka dialog detail pengumuman yang sudah ada saat kartu ditekan.
- **`lib/routes/app_routes.dart`**:
  - Mendaftarkan rute `Routes.RIWAYAT_PENGUMUMAN = '/riwayat_pengumuman'` dan `GetPage(name: Routes.RIWAYAT_PENGUMUMAN, page: () => const RiwayatPengumumanScreen())`.
- **`lib/features/home/home_screen.dart`**:
  - Menerapkan `WidgetsBindingObserver` pada `_HomeScreenState` untuk memuat ulang pengumuman mingguan secara otomatis ketika aplikasi dilanjutkan dari latar belakang (*resume*).
  - Menambahkan pewaktu pergantian hari (`_scheduleMidnightTimer`) yang otomatis memicu pembaruan data tepat pada Senin 00:00:01 WIB saat terjadi pergantian minggu.
  - Menambahkan `RefreshIndicator` pada `SingleChildScrollView` untuk mendukung tarik ke bawah (*pull to refresh*).
  - Mengganti daftar pengumuman beranda ke `weeklyPengumumanList`, dengan status kosong lembut dan tombol tautan ke Riwayat Pengumuman jika belum ada pengumuman minggu ini.

---

### 3. Pengujian Batas Waktu & Integritas Basis Data
1. **Uji Batas Waktu UTC ke WIB**:
   - Minggu malam 16:59:59 UTC (= Minggu 23:59:59 WIB): terverifikasi masuk ke minggu lama dan tidak masuk ke minggu baru.
   - Minggu malam 17:00:00 UTC (= Senin 00:00:00 WIB): terverifikasi tidak masuk ke minggu lama dan tepat masuk ke minggu baru.
   - Akhir minggu 16:59:59 UTC (= Minggu 23:59:59 WIB): terverifikasi masuk ke minggu berjalan.
   - Akhir minggu 17:00:00 UTC (= Senin 00:00:00 WIB): terverifikasi berpindah ke minggu berikutnya.
2. **Uji Filter Kalender Riwayat**:
   - Pengumuman dengan `tanggalPengumuman` bulan November dan `created_at` bulan Oktober hanya muncul pada kalender November 2026, membuktikan kalender hanya menggunakan `tanggalPengumuman`.
3. **Uji Filter Kosong**:
   - Rentang tanggal tanpa pengumuman mengembalikan status HTTP 200 dengan `data: []`.
4. **Pembersihan Data Uji**:
   - Seluruh data uji berawalan `TEST:` dihapus secara tuntas setelah pengujian selesai.
   - Jumlah baris pada tabel `pengumumen` terverifikasi tetap 16 baris (tidak ada data asli yang hilang atau terhapus).

---

## [08-10-2026] - Revisi Kalender Pengumuman (Popup Zoom & Penyelarasan Ikon)

### 1. Tujuan
1. **Revisi 1 (Kalender Muncul sebagai Popup Zoom)**: Mengubah pemanggilan kalender dari ikon kalender di kanan atas halaman Pengumuman agar tidak berpindah ke halaman penuh, melainkan membuka jendela modal dialog (*popup*) di tengah layar dengan efek animasi zoom (*ScaleTransition* dan *FadeTransition*, kurva *easeOutBack*, durasi 220 ms). Popup dapat ditutup melalui ikon X, penekanan area luar latar belakang, atau tombol kembali Android.
2. **Revisi 2 (Penyelarasan Ikon Kalender dengan Kartu Pengumuman)**: Mengubah ikon pengumuman pada sel tanggal kalender yang memiliki agenda agar menggunakan ikon yang sama persis dengan yang ada pada `CardPengumuman` (`Icons.campaign_rounded`, warna `#3F8FC1` dengan tingkat transparansi/opacity 0.45 bergaya arsip cerita Instagram), menggantikan `Icons.campaign_outlined`.

---

### 2. File yang Dimodifikasi & Ditambahkan

#### A. `lib/features/pengumuman/riwayat_pengumuman_popup.dart` (File Baru)
- Membuat komponen modal dialog `RiwayatPengumumanPopup` dengan method statis `RiwayatPengumumanPopup.show(context)`.
- Menggunakan `showGeneralDialog` dengan latar belakang semi-transparan (`barrierColor: Colors.black.withOpacity(0.5)`), animasi membesar (*zoom*) dari skala 0.8 ke 1.0 dengan `Curves.easeOutBack`, serta efek memudar (*fade*).
- Menata tata letak kartu kalender dengan sudut melengkung 20.r, bayangan halus, batas tinggi maksimal layar (85% tinggi layar), dan dapat digulir (*SingleChildScrollView*).
- Bagian kepala dialog (*header*) memuat tombol bulan sebelumnya, nama bulan berbahasa Indonesia dan tahun, tombol bulan berikutnya, garis pemisah vertikal, serta tombol tutup (ikon X).
- Baris nama hari: Sen, Sel, Rab, Kam, Jum, Sab, Min (pekan berawal Senin).
- Kisi tanggal:
  - Hari ini ditandai dengan lingkaran garis tepi warna primer.
  - Tanggal yang dipilih disorot dengan warna primer penuh dan teks putih.
  - Tanggal dengan pengumuman menampilkan ikon `Icons.campaign_rounded` pudar (opacity 0.45).
- Pemilihan tanggal:
  - Menekan tanggal dengan pengumuman akan menampilkan kartu pengumuman pada tanggal tersebut di dalam popup di bawah kalender.
  - Menekan tanggal tanpa pengumuman menampilkan keterangan lembut "Tidak ada pengumuman pada tanggal ini".
  - Menekan kartu pengumuman membuka dialog detail pengumuman yang sudah ada; setelah dialog detail ditutup, popup kalender tetap terbuka.

#### B. `lib/features/pengumuman/pengumuman_screen.dart`
- Mengimpor `riwayat_pengumuman_popup.dart`.
- Memperbarui event `onTab2` pada `AppBarPrimary` dan tombol pada kondisi kosong agar memanggil `RiwayatPengumumanPopup.show(context)` alih-alih melakukan navigasi penuh `Get.toNamed(Routes.RIWAYAT_PENGUMUMAN)`.
- Membersihkan import rute yang tidak lagi terpakai.

#### C. `lib/features/pengumuman/riwayat_pengumuman_screen.dart`
- Memperbarui ikon tanggal dengan pengumuman menjadi `Icons.campaign_rounded` (opacity 0.45) agar konsisten dengan `CardPengumuman`.
- Menambahkan komentar penjelasan bahwa berkas halaman penuh ini tetap dipertahankan untuk kompatibilitas rute.

#### D. `lib/routes/app_routes.dart`
- Menambahkan komentar penjelasan pada `Routes.RIWAYAT_PENGUMUMAN` dan `GetPage` bahwa rute halaman penuh tetap dipertahankan untuk kompatibilitas, sementara pemanggilan utama telah dialihkan ke popup zoom.

#### E. `lib/features/pengumuman/pengumuman_controller.dart`
- Membersihkan import `dart:io` dan `package:flutter/foundation.dart` yang tidak digunakan.

---

### 3. Pengujian & Integritas Basis Data
1. **Pengujian Tanggal 13 & Dua Pengumuman dalam Satu Hari**:
   - Memasukkan data uji pada tanggal 13 Oktober 2026 (2 pengumuman) dan tanggal 20 Oktober 2026 (1 pengumuman).
   - Terverifikasi API `GET /api/announcement?bulan=2026-10` mengembalikan 2 pengumuman pada tanggal 13 dan 1 pengumuman pada tanggal 20.
   - Tanggal tanpa pengumuman (misal 14 Oktober) terverifikasi mengembalikan 0 pengumuman.
2. **Pengecekan Kalender 1 Oktober 2026**:
   - Terverifikasi 1 Oktober 2026 jatuh pada hari Kamis (ISO weekday 4), dengan 3 sel kosong di awal grid (Senin, Selasa, Rabu).
3. **Penyelarasan Ikon & Tampilan Sel**:
   - `CardPengumuman` menggunakan `Icons.campaign_rounded`.
   - Kalender kini menggunakan `Icons.campaign_rounded` diperbesar (size: 26.sp) di latar belakang angka tanggal secara pudar (opacity 0.30 - 0.40) menggunakan `Stack`, sehingga angka tanggal tetap terbaca jelas di atasnya.
4. **Pembersihan Data Uji**:
   - Seluruh data uji berawalan `TEST:` telah dibersihkan secara tuntas.
   - Jumlah baris basis data tabel `pengumumen` tetap 16 baris (tidak ada data asli yang hilang atau terhapus).

---

## [08-10-2026] - Penyempurnaan Tampilan Kalender (Ikon Tanggal Diperbesar & Card Kecil Interaktif)

### 1. Tujuan
1. **Ikon Pengumuman di Tanggalan Diperbesar & Pudar**: Mengubah tampilan sel kalender agar ikon pengumuman diperbesar menutupi area angka dengan tingkat transparansi halus (opacity 0.30) menggunakan `Stack`. Angka tanggal tetap berada di lapisan atas dengan kontras tajam sehingga tetap terbaca dengan mudah.
2. **Penghapusan Daftar Pengumuman Bulanan Menumpuk**: Menghapus daftar default seluruh pengumuman bulanan yang sebelumnya tampil di bawah kalender, mencegah tampilan bertumpuk banyak saat ada banyak pengumuman dalam sebulan.
3. **Card Kecil Ringkas saat Tanggal Berikon Diklik**: Ketika pengguna menekan tanggal yang memiliki pengumuman, muncul kartu ringkas (*card kecil*) untuk pengumuman tanggal tersebut di bawah kalender secara interaktif, lengkap dengan tombol tutup [X] atau dapat ditutup kembali dengan menekan ulang tanggal tersebut. Menekan kartu kecil tetap membuka dialog detail pengumuman.

### 2. File yang Dimodifikasi
- **`lib/features/pengumuman/riwayat_pengumuman_popup.dart`**:
  - Mengubah sel tanggal kalender menjadi `Stack(alignment: Alignment.center)` dengan `Icon(Icons.campaign_rounded, size: 26.sp, color: primaryColor.withOpacity(0.30))` di belakang angka tanggal berbobot tebal.
  - Menghapus daftar default pengumuman bulanan saat belum ada tanggal yang dipilih (`SizedBox.shrink()`).
  - Menambahkan method `_buildSmallCardItem()` dengan tata letak kompak (ikon kecil, judul satu baris, lokasi, dan chevron navigasi).
  - Menambahkan tombol tutup cepat [X] pada header tanggal terpilih.
- **`lib/features/pengumuman/riwayat_pengumuman_screen.dart`**:
  - Menyelaraskan sel kalender pada layar penuh dengan `Stack` dan ikon pengumuman besar pudar yang sama demi konsistensi visual.

---

## [08-10-2026] - Penambahan Fitur Pemilih Bulan & Tahun Cepat pada Kalender

### 1. Tujuan
Mempermudah pengguna dalam mencari riwayat pengumuman bertahun-tahun sebelumnya (misalnya tahun lalu atau beberapa tahun ke belakang) tanpa perlu menekan tombol panah kiri `<` berulang kali secara manual satu demi satu. Pengguna cukup menekan judul bulan dan tahun pada header kalender untuk membuka panel pemilih bulan dan tahun secara langsung.

### 2. File yang Dimodifikasi
- **`lib/features/pengumuman/riwayat_pengumuman_popup.dart`** & **`lib/features/pengumuman/riwayat_pengumuman_screen.dart`**:
  - **Header Interaktif**: Judul bulan dan tahun kini berupa tombol interaktif dengan ikon drop-down (`Icons.arrow_drop_down_rounded` / `Icons.arrow_drop_up_rounded`).
  - **Panel Pemilih Bulan & Tahun (`_buildMonthYearPicker`)**:
    - **Pengatur Tahun**: Dilengkapi tombol panah kiri/kanan (`<` dan `>`) untuk beralih tahun serta dropdown pemilihan tahun langsung (rentang tahun 2020 hingga tahun berjalan + 2).
    - **Kisi 12 Bulan**: Menampilkan 12 tombol bulan (Januari s.d. Desember) dalam format kisi 4 baris x 3 kolom yang rapi. Bulan yang sedang aktif disorot dengan warna primer penuh, dan bulan berjalan diberi garis batas penanda.
    - **Peralihan Otomatis**: Menekan salah satu bulan akan langsung memuat data pengumuman untuk bulan dan tahun yang dipilih (`controller.loadPengumumanBulan`), menutup panel pemilih, dan menampilkan grid kalender tanggal secara instan.

---

## [08-10-2026] - Perbaikan RenderFlex Overflow & Penyempurnaan Visual Kalender

### 1. Masalah yang Ditemukan
1. **RenderFlex Overflow (6.4 Pixels)**:
   - Terjadi garis kuning-hitam overflow sebesar 6.4 pixels di sisi kanan header `● Pengumuman Tanggal [Tanggal] [X]` pada popup kalender.
   - Penyebab: Komponen `Row` di dalam `Row` tidak memiliki pembatas lebar (`Expanded` / `Flexible`), sehingga teks tanggal panjang (seperti "18 September 2024") bersama tombol tutup [X] melebihi lebar dialog pada resolusi ponsel.
2. **Keterbacaan Angka Tanggal dengan Ikon Pengumuman**:
   - Ikon `Icons.campaign_rounded` dengan opasitas 0.30 sebelumnya menimbulkan garis-garis gelombang suara yang sedikit menabrak angka tanggal (seperti 18, 21, 25, 30).

### 2. Solusi & Perbaikan yang Diterapkan
1. **Perbaikan Tata Letak Header Tanggal**:
   - Menghapus nested row tanpa pembatas pada `riwayat_pengumuman_popup.dart` dan membungkus `Text` dengan `Expanded` serta `TextOverflow.ellipsis`.
   - Menambahkan indikator jumlah pengumuman jika terdapat lebih dari satu pengumuman pada tanggal tersebut (misal `Pengumuman Tanggal 18 September 2024 (5)`).
   - Menambahkan perlindungan `Flexible` pada judul bulan header di kedua berkas agar aman dari potensi overflow.
2. **Penyempurnaan Visual Ikon Kalender**:
   - Menyesuaikan ukuran ikon menjadi `24.sp` dengan opasitas pudar halus `0.18` pada status biasa dan `0.28` pada status terpilih (`isSelected`).
   - Angka tanggal kini terbaca sangat kontras, tegas, dan jernih, sementara siluet ikon pengumuman tetap terlihat sebagai watermark latar belakang.
3. **Penyelarasan pada Layar Penuh (`riwayat_pengumuman_screen.dart`)**:
   - Menerapkan perlindungan `Expanded` pada baris tanggal dan penyesuaian opasitas ikon yang sama demi konsistensi tampilan di seluruh aplikasi.



