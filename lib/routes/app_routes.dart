/// =======================================================
/// FILE : app_routes.dart
/// =======================================================

import 'package:epkk_nganjuk/features/pages/pokja4/inovasi/inovasi_screen.dart';
import 'package:epkk_nganjuk/features/pages/pokja4/inovasi/kegiatanpokja4/kegiatan1_pokja4_screen.dart';
import 'package:epkk_nganjuk/features/pages/pokja4/inovasi/kegiatanpokja4/kegiatan2_pokja4_screen.dart';
import 'package:epkk_nganjuk/features/pages/pokja4/inovasi/kegiatanpokja4/kegiatan3_pokja4_screen.dart';
import 'package:epkk_nganjuk/features/pages/pokja4/inovasi/kegiatanpokja4/kegiatan4_pokja4_screen.dart';
import 'package:epkk_nganjuk/features/pages/pokja4/inovasi/kegiatanpokja4/kegiatan5_pokja4_screen.dart';
import 'package:epkk_nganjuk/features/pages/pokja4/inovasi/posyandu/posyandu1_screen.dart';
import 'package:epkk_nganjuk/features/pages/pokja4/inovasi/posyandu/posyandu2_screen.dart';
import 'package:epkk_nganjuk/features/pages/pokja4/inovasi/posyandu/posyandu3_screen.dart';
import 'package:epkk_nganjuk/features/pages/pokja4/inovasi/posyandu/posyandu4_screen.dart';
import 'package:epkk_nganjuk/features/pages/pokja4/inovasi/posyandu/posyandu5_screen.dart';
import 'package:epkk_nganjuk/features/pages/pokja4/inovasi/rekap_bulan/rekap1_bulan_screen.dart';
import 'package:epkk_nganjuk/features/pages/pokja4/inovasi/rekap_bulan/rekap2_bulan_screen.dart';
import 'package:epkk_nganjuk/features/pages/pokja4/inovasi/rekap_bulan/rekap3_bulan_screen.dart';
import 'package:epkk_nganjuk/features/pages/pokja4/inovasi/rekap_tahun/rekap1_tahun_screen.dart';
import 'package:epkk_nganjuk/features/pages/pokja4/inovasi/rekap_tahun/rekap2_tahun_screen.dart';
import 'package:epkk_nganjuk/features/pages/pokja4/inovasi/rekap_tahun/rekap3_tahun_screen.dart';
import 'package:epkk_nganjuk/features/pages/pokja4/inovasi/rekap_tahun/rekap4_tahun_screen.dart';
import 'package:epkk_nganjuk/features/pages/pokja4/inovasi/rekap_tahun/rekap5_tahun_screen.dart';

import 'package:get/get.dart';

// ===== AUTH =====
import 'package:epkk_nganjuk/features/splash/splash_screen.dart';
import 'package:epkk_nganjuk/features/splash/intro_splash_screen.dart';
import 'package:epkk_nganjuk/welcome/welcome_screen.dart';
import 'package:epkk_nganjuk/features/auth/auth_screen.dart';
import 'package:epkk_nganjuk/features/auth/forgot_password/forget_password_screen.dart';
import 'package:epkk_nganjuk/features/register/register_screen.dart';
import 'package:epkk_nganjuk/features/register/pick_role_screen.dart';
import 'package:epkk_nganjuk/features/verifikasi/verifikasi_screen.dart';
import 'package:epkk_nganjuk/features/verifikasi/verifikasi_forget_password_screen.dart';
import 'package:epkk_nganjuk/features/verifikasi/reset_password_screen.dart';

// ===== MAIN =====
import 'package:epkk_nganjuk/main_screen.dart';
import 'package:epkk_nganjuk/features/home/home_screen.dart';

// ===== PROFILE =====
import 'package:epkk_nganjuk/features/akun/informasi_akun.dart';
import 'package:epkk_nganjuk/features/akun/edit_password.dart';
// [PERUBAHAN 08-10-2026] Import halaman Bantuan
import 'package:epkk_nganjuk/features/akun/bantuan_screen.dart';
// [PERUBAHAN 08-10-2026] Import halaman Riwayat Pengumuman
import 'package:epkk_nganjuk/features/pengumuman/riwayat_pengumuman_screen.dart';

// ===== POKJA 1 =====
import 'package:epkk_nganjuk/features/pages/pokja1/kaderpokja1/kader_pokja1_screen.dart';
import 'package:epkk_nganjuk/features/pages/pokja1/penghayatan/penghayatan_screen.dart';
import 'package:epkk_nganjuk/features/pages/pokja1/gotongroyong/gotong_royong_screen.dart';

// ===== POKJA 2 =====
import 'package:epkk_nganjuk/features/pages/pokja2/pendidikan/pendidikan1_screen.dart';
import 'package:epkk_nganjuk/features/pages/pokja2/pendidikan/pendidikan2_screen.dart';
import 'package:epkk_nganjuk/features/pages/pokja2/pendidikan/pendidikan3_screen.dart';
import 'package:epkk_nganjuk/features/pages/pokja2/pendidikan/pendidikan4_screen.dart';
import 'package:epkk_nganjuk/features/pages/pokja2/pendidikan/pendidikan5_screen.dart';
import 'package:epkk_nganjuk/features/pages/pokja2/pengembangan/pengembangan1_screen.dart';
import 'package:epkk_nganjuk/features/pages/pokja2/pengembangan/pengembangan2_screen.dart';
import 'package:epkk_nganjuk/features/pages/pokja2/pengembangan/pengembangan3_screen.dart';

// ===== POKJA 3 =====
import 'package:epkk_nganjuk/features/pages/pokja3/jumlah_kader/kader_pokja3_screen.dart';
import 'package:epkk_nganjuk/features/pages/pokja3/pangan/pangan1_screen.dart';
import 'package:epkk_nganjuk/features/pages/pokja3/pangan/pangan2_screen.dart';
import 'package:epkk_nganjuk/features/pages/pokja3/pangan/pangan3_screen.dart';
import 'package:epkk_nganjuk/features/pages/pokja3/sandang/sandang_screen.dart';
import 'package:epkk_nganjuk/features/pages/pokja3/perumahan/perumahan_screen.dart';

// ===== POKJA 4 =====
import 'package:epkk_nganjuk/features/pages/pokja4/kader_pokja4/kader_pokja4_screen.dart';
import 'package:epkk_nganjuk/features/pages/pokja4/kesehatan/kesehatan_screen.dart';
import 'package:epkk_nganjuk/features/pages/pokja4/jumlah_rumah/perencanaan_screen.dart';
import 'package:epkk_nganjuk/features/pages/pokja4/kelestarian/kelestarian1_screen.dart';
import 'package:epkk_nganjuk/features/pages/pokja4/kelestarian/kelestarian2_screen.dart';
import 'package:epkk_nganjuk/features/pages/pokja4/kelestarian/kelestarian3_screen.dart';

// ===== LAPORAN =====
import 'package:epkk_nganjuk/features/laporan/upload_laporan_screen.dart';
import 'package:epkk_nganjuk/features/laporan/upload_galeri/upload_galeri_screen.dart';
import 'package:epkk_nganjuk/features/laporan/laporan_umum/laporan_umum1_screen.dart';
import 'package:epkk_nganjuk/features/laporan/laporan_umum/laporan_umum2_screen.dart';
import 'package:epkk_nganjuk/features/laporan/laporan_umum/laporan_umum3_screen.dart';
import 'package:epkk_nganjuk/features/laporan/laporan_umum/laporan_umum4_screen.dart';

class Routes {
  // ===== AUTH =====

  static const INTRO_SPLASH = '/intro_splash';

  static const SPLASH = '/';

  static const WELCOME = '/welcome';

  static const AUTH_LOGIN = '/login';

  static const REGISTER = '/register';

  static const PICK_ROLE = '/pick_role';

  static const VERIFICATION = '/verification';

  static const VERIFICATION_FORGOT_PASSWORD = '/verification_forgot_password';

  static const RESET_PASSWORD = '/reset_password';

  static const RESET_PASSWORD_BARU = '/reset_password_baru';

  // ===== MAIN =====

  static const MAIN = '/main';

  static const HOME = '/home';

  // ===== PROFILE =====

  static const INFO_AKUN = '/info_akun';

  static const EDIT_PASSWORD = '/edit_password';

  // [PERUBAHAN 08-10-2026] Menambahkan route BANTUAN
  static const BANTUAN = '/bantuan';

  // [PERUBAHAN 08-10-2026] Menambahkan route RIWAYAT_PENGUMUMAN
  static const RIWAYAT_PENGUMUMAN = '/riwayat_pengumuman';

  // ===== POKJA 1 =====

  static const KADER_POKJA1 = '/kader_pokja1';

  static const PENGHAYATAN = '/penghayatan';

  static const GOTONG_ROYONG = '/gotong_royong';

  // ===== POKJA 2 =====

  static const PENDIDIKAN1 = '/pendidikan1';

  static const PENDIDIKAN2 = '/pendidikan2';

  static const PENDIDIKAN3 = '/pendidikan3';

  static const PENDIDIKAN4 = '/pendidikan4';

  static const PENDIDIKAN5 = '/pendidikan5';

  static const PENGEMBANGAN1 = '/pengembangan1';

  static const PENGEMBANGAN2 = '/pengembangan2';

  static const PENGEMBANGAN3 = '/pengembangan3';

  // ===== POKJA 3 =====

  static const KADER_POKJA3 = '/kader_pokja3';

  static const PANGAN1 = '/pangan1';

  static const PANGAN2 = '/pangan2';

  static const PANGAN3 = '/pangan3';

  static const SANDANG = '/sandang';

  static const PERUMAHAN = '/perumahan';

  // ===== POKJA 4 =====

  static const KADER_POKJA4 = '/kader_pokja4';

  static const KESEHATAN = '/kesehatan';

  static const PERENCANAAN = '/perencanaan';

  static const KELESTARIAN1 = '/kelestarian1';

  static const KELESTARIAN2 = '/kelestarian2';

  static const KELESTARIAN3 = '/kelestarian3';

  static const INOVASI = '/inovasi';

  /// ================= REKAP DESA =================

  static const REKAP_DESA_1 = '/rekap_desa_1';

  static const REKAP_DESA_2 = '/rekap_desa_2';

  static const REKAP_DESA_3 = '/rekap_desa_3';

  /// ======== REKAP DESA TAHUNAN ========
  static const REKAP_DESA_TAHUNAN_1 = '/rekap-desa-tahunan-1';

  static const REKAP_DESA_TAHUNAN_2 = '/rekap-desa-tahunan-2';

  static const REKAP_DESA_TAHUNAN_3 = '/rekap-desa-tahunan-3';

  static const REKAP_DESA_TAHUNAN_4 = '/rekap-desa-tahunan-4';

  static const REKAP_DESA_TAHUNAN_5 = '/rekap-desa-tahunan-5';

  // ====== POSYANDU =====
  static const POSYANDU_1 = '/posyandu-1';

  static const POSYANDU_2 = '/posyandu-2';

  static const POSYANDU_3 = '/posyandu-3';

  static const POSYANDU_4 = '/posyandu-4';

  static const POSYANDU_5 = '/posyandu-5';

  // ===== KEGIATAN POKJA 4 =====

  static const KEGIATAN_POKJA4_1 = '/kegiatan-pokja4-1';

  static const KEGIATAN_POKJA4_2 = '/kegiatan-pokja4-2';

  static const KEGIATAN_POKJA4_3 = '/kegiatan-pokja4-3';

  static const KEGIATAN_POKJA4_4 = '/kegiatan-pokja4-4';

  static const KEGIATAN_POKJA4_5 = '/kegiatan-pokja4-5';

  // ===== LAPORAN =====

  static const UPLOAD_LAPORAN = '/upload_laporan';

  static const UPLOAD_GALERI = '/upload_galeri';

  static const LAPORAN_UMUM1 = '/laporan_umum1';

  static const LAPORAN_UMUM2 = '/laporan_umum2';

  static const LAPORAN_UMUM3 = '/laporan_umum3';

  static const LAPORAN_UMUM4 = '/laporan_umum4';
}

class AppPages {
  static final List<GetPage> pages = [
    // ===== AUTH =====
    GetPage(name: Routes.INTRO_SPLASH, page: () => const IntroSplashScreen()),
    
    GetPage(name: Routes.SPLASH, page: () => const SplashScreen()),

    GetPage(name: Routes.WELCOME, page: () => WelcomeScreen()),

    GetPage(name: Routes.AUTH_LOGIN, page: () => AuthScreen()),

    GetPage(name: Routes.REGISTER, page: () => RegisterScreen()),

    GetPage(name: Routes.PICK_ROLE, page: () => PickRoleScreen()),

    GetPage(name: Routes.VERIFICATION, page: () => VerificationScreen()),

    GetPage(
      name: Routes.VERIFICATION_FORGOT_PASSWORD,
      page: () => VerificationForgotPasswordScreen(),
    ),

    GetPage(name: Routes.RESET_PASSWORD, page: () => ForgetPasswordScreen()),

    GetPage(
      name: Routes.RESET_PASSWORD_BARU,
      page: () => ResetPasswordScreen(),
    ),

    // ===== MAIN =====
    GetPage(name: Routes.MAIN, page: () => MainScreen()),

    GetPage(name: Routes.HOME, page: () => HomeScreen()),

    // ===== PROFILE =====
    GetPage(name: Routes.INFO_AKUN, page: () => InfoAkunScreen()),

    GetPage(name: Routes.EDIT_PASSWORD, page: () => EditPasswordScreen()),

    // [PERUBAHAN 08-10-2026] Menambahkan GetPage BANTUAN
    GetPage(name: Routes.BANTUAN, page: () => const BantuanScreen()),

    // [PERUBAHAN 08-10-2026] Menambahkan GetPage RIWAYAT_PENGUMUMAN
    // [CATATAN REVISI 08-10-2026] Rute halaman penuh ini tetap dipertahankan untuk kompatibilitas,
    // sedangkan ikon kalender pada halaman Pengumuman kini menggunakan popup zoom (RiwayatPengumumanPopup).
    GetPage(
      name: Routes.RIWAYAT_PENGUMUMAN,
      page: () => const RiwayatPengumumanScreen(),
    ),

    // ===== POKJA 1 =====
    GetPage(name: Routes.KADER_POKJA1, page: () => KaderPokja1Screen()),

    GetPage(
      name: Routes.PENGHAYATAN,
      page: () => PenghayatanPengamalanScreen(),
    ),

    GetPage(name: Routes.GOTONG_ROYONG, page: () => GotongRoyongScreen()),

    // ===== POKJA 2 =====
    GetPage(name: Routes.PENDIDIKAN1, page: () => Pendidikan1Screen()),

    GetPage(
      name: Routes.PENDIDIKAN2,
      page: () => PendidikanKetrampilan2Screen(),
    ),

    GetPage(
      name: Routes.PENDIDIKAN3,
      page: () => PendidikanKetrampilan3Screen(),
    ),

    GetPage(
      name: Routes.PENDIDIKAN4,
      page: () => PendidikanKetrampilan4Screen(),
    ),

    GetPage(
      name: Routes.PENDIDIKAN5,
      page: () => PendidikanKetrampilan5Screen(),
    ),

    GetPage(name: Routes.PENGEMBANGAN1, page: () => Pengembangan1()),

    GetPage(name: Routes.PENGEMBANGAN2, page: () => Pengembangan2()),

    GetPage(name: Routes.PENGEMBANGAN3, page: () => Pengembangan3()),

    // ===== POKJA 3 =====
    GetPage(name: Routes.KADER_POKJA3, page: () => KaderPokja3Screen()),

    GetPage(name: Routes.PANGAN1, page: () => Pangan1Screen()),

    GetPage(name: Routes.PANGAN2, page: () => Pangan2Screen()),

    GetPage(name: Routes.PANGAN3, page: () => Pangan3Screen()),

    GetPage(name: Routes.SANDANG, page: () => SandangScreen()),

    GetPage(name: Routes.PERUMAHAN, page: () => PerumahanScreen()),

    // ===== POKJA 4 =====
    GetPage(name: Routes.KADER_POKJA4, page: () => KaderPokja4Screen()),

    GetPage(name: Routes.KESEHATAN, page: () => KesehatanScreen()),

    GetPage(name: Routes.PERENCANAAN, page: () => PerencanaanSehatScreen()),

    GetPage(
      name: Routes.KELESTARIAN1,
      page: () => KelestarianLingkungan1Screen(),
    ),

    GetPage(
      name: Routes.KELESTARIAN2,
      page: () => KelestarianLingkungan2Screen(),
    ),

    GetPage(name: Routes.KELESTARIAN3, page: () => Kelestarian3Screen()),

    GetPage(name: Routes.INOVASI, page: () => InovasiScreen()),

    /// ================= REKAP DESA =================
    GetPage(
      name: Routes.REKAP_DESA_1,

      page: () => RekapDesa1Screen(kategori: Get.arguments['kategori']),
    ),

    GetPage(name: Routes.REKAP_DESA_2, page: () => RekapDesa2Screen()),

    GetPage(name: Routes.REKAP_DESA_3, page: () => RekapDesa3Screen()),

    /// ======== REKAP DESA TAHUNAN ========
    GetPage(
      name: Routes.REKAP_DESA_TAHUNAN_1,
      page: () => RekapDesaTahunan1Screen(kategori: Get.arguments['kategori']),
    ),
    GetPage(
      name: Routes.REKAP_DESA_TAHUNAN_2,
      page: () => RekapDesaTahunan2Screen(),
    ),
    GetPage(
      name: Routes.REKAP_DESA_TAHUNAN_3,
      page: () => RekapDesaTahunan3Screen(),
    ),
    GetPage(
      name: Routes.REKAP_DESA_TAHUNAN_4,
      page: () => RekapDesaTahunan4Screen(),
    ),
    GetPage(
      name: Routes.REKAP_DESA_TAHUNAN_5,
      page: () => RekapDesaTahunan5Screen(),
    ),

    /// ===============================
    /// POSYANDU
    /// ===============================
    GetPage(
      name: Routes.POSYANDU_1,

      page: () => Posyandu1Screen(kategori: Get.arguments['kategori']),
    ),

    GetPage(name: Routes.POSYANDU_2, page: () => const Posyandu2Screen()),

    GetPage(name: Routes.POSYANDU_3, page: () => const Posyandu3Screen()),

    GetPage(name: Routes.POSYANDU_4, page: () => const Posyandu4Screen()),

    GetPage(name: Routes.POSYANDU_5, page: () => const Posyandu5Screen()),

    /// ===============================
    /// KEGIATAN POKJA 4
    /// ===============================
    GetPage(
      name: Routes.KEGIATAN_POKJA4_1,
      page: () => KegiatanPokja41Screen(kategori: Get.arguments['kategori']),
    ),

    GetPage(
      name: Routes.KEGIATAN_POKJA4_2,

      page: () => const KegiatanPokja42Screen(),
    ),

    GetPage(
      name: Routes.KEGIATAN_POKJA4_3,

      page: () => const KegiatanPokja43Screen(),
    ),

    GetPage(
      name: Routes.KEGIATAN_POKJA4_4,

      page: () => const KegiatanPokja44Screen(),
    ),

    GetPage(
      name: Routes.KEGIATAN_POKJA4_5,

      page: () => const KegiatanPokja45Screen(),
    ),

    // ===== LAPORAN =====
    GetPage(name: Routes.UPLOAD_LAPORAN, page: () => UploadLaporanScreen()),

    GetPage(name: Routes.UPLOAD_GALERI, page: () => UploadGaleriPage()),

    GetPage(name: Routes.LAPORAN_UMUM1, page: () => LaporanUmum1Screen()),

    GetPage(name: Routes.LAPORAN_UMUM2, page: () => LaporanUmum2Screen()),

    GetPage(name: Routes.LAPORAN_UMUM3, page: () => LaporanUmum3Screen()),

    GetPage(name: Routes.LAPORAN_UMUM4, page: () => LaporanUmum4Screen()),
  ];
}
