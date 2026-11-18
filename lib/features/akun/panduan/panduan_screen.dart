import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'content/hubungi_admin_content.dart';
import 'content/panduan_cepat_content.dart';
import 'content/pertanyaan_umum_content.dart';
import 'content/status_laporan_content.dart';
import 'content/tentang_aplikasi_content.dart';
import 'panduan_style.dart';
import 'widgets/bantuan_banner.dart';
import 'widgets/panduan_header.dart';
import 'widgets/panduan_menu_card.dart';
import 'widgets/panduan_shapes.dart';

/// Layar "Panduan E-PKK Kabupaten Nganjuk" (fitur Bantuan).
///
/// Setiap kartu menu mengimplementasikan pola accordion:
/// mengetuk kartu akan membuka konten di tempat dengan animasi halus,
/// dan chevron akan berputar 180 derajat.
class PanduanScreen extends StatelessWidget {
  const PanduanScreen({super.key, this.onBack});

  /// Jika null, tombol kembali memakai Get.back() via PanduanHeader.
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      // Header terang: ikon status bar gelap, latar transparan.
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: PanduanStyle.pageBackground,
        body: LayoutBuilder(
          builder: (context, constraints) {
            final s = constraints.maxWidth / PanduanStyle.designWidth;

            return Stack(
              fit: StackFit.expand,
              children: [
                // Gelombang dasar diletakkan di belakang konten supaya
                // tidak menutupi kartu saat di-scroll.
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: IgnorePointer(child: PanduanBottomWaves(scale: s)),
                ),
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      PanduanHeader(onBack: onBack),
                      const SizedBox(height: 8),
                      const BantuanBanner(),
                      const SizedBox(height: 19),
                      const _SectionTitle('Menu Utama'),
                      const SizedBox(height: 7),
                      const PanduanMenuCard(
                        iconAsset: 'assets/icons/ic_panduan_cepat.png',
                        title: 'Panduan Cepat',
                        description:
                            'Masuk ke akun, mengirim laporan, dan fitur lainnya.',
                        child: PanduanCepatContent(),
                      ),
                      const SizedBox(height: 4),
                      const PanduanMenuCard(
                        iconAsset: 'assets/icons/ic_status_laporan.png',
                        title: 'Arti Status Laporan',
                        description: 'Pahami arti setiap status laporan Anda.',
                        child: StatusLaporanContent(),
                      ),
                      const SizedBox(height: 4),
                      const PanduanMenuCard(
                        iconAsset: 'assets/icons/ic_pertanyaan_umum.png',
                        title: 'Pertanyaan Umum',
                        description:
                            'Jawaban dari pertanyaan yang sering ditanyakan.',
                        child: PertanyaanUmumContent(),
                      ),
                      const SizedBox(height: 4),
                      const PanduanMenuCard(
                        iconAsset: 'assets/icons/ic_hubungi_admin.png',
                        title: 'Hubungi Admin',
                        description:
                            'Jika mengalami kendala, hubungi admin kami.',
                        child: HubungiAdminContent(),
                      ),
                      // Di Figma jarak ke kartu terakhir 11 (bukan 4).
                      const SizedBox(height: 11),
                      const PanduanMenuCard(
                        iconAsset: 'assets/icons/ic_tentang_aplikasi.png',
                        title: 'Tentang Aplikasi',
                        description:
                            'Informasi versi dan detail aplikasi E-PKK.',
                        child: TentangAplikasiContent(),
                      ),
                      SizedBox(height: 40 * s + bottomInset),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 16,
            decoration: BoxDecoration(
              color: PanduanStyle.accentBlue,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 10),
          Semantics(
            header: true,
            child: Text(text, style: PanduanStyle.sectionTitle),
          ),
        ],
      ),
    );
  }
}
