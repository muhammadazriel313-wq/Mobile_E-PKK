import 'package:epkk_nganjuk/common/appbar/custom_appbar.dart';
import 'package:epkk_nganjuk/features/auth/button/card_button_actions.dart';
import 'package:epkk_nganjuk/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class UploadLaporanScreen extends StatelessWidget {
  const UploadLaporanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments ?? {};

    final String idUser = args['id_user'] ?? '';
    final String fullName = args['full_name'] ?? '';
    final String idRole = args['id_role'] ?? '';
    final String role = args['name_role'] ?? '';
    final String idOrganization = args['id_organization'] ?? '';
    final String roleBidang = (args['name_organization'] ?? '')
        .toString()
        .toLowerCase();

    final media = MediaQuery.of(context);
    final isTablet = media.size.width >= 600;

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBarPrimary(title: 'Upload Laporan', onBack: () => Get.back()),

      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),

              padding: EdgeInsets.only(
                left: isTablet ? 40.w : 16.w,
                right: isTablet ? 40.w : 16.w,
                top: 16.h,
                bottom: 24.h,
              ),

              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: isTablet ? 700 : double.infinity,
                    minHeight: constraints.maxHeight,
                  ),

                  child: Column(
                    children: [
                      /// ================= IMAGE =================
                      Image.asset(
                        'assets/images/upload_laporan.png',
                        width: double.infinity,
                        fit: BoxFit.contain,
                      ),

                      SizedBox(height: 32.h),

                      /// ================= POKJA I =================
                      if (roleBidang == 'kader pokja i') ...[
                        _buildMenu(
                          title: 'Kader Pokja 1',
                          route: Routes.KADER_POKJA1,
                          color1: const Color(0xFFE3F2FD),
                          color2: const Color.fromARGB(250, 151, 196, 225),
                          image: 'assets/images/ic_pokja1.png',
                          args: _args(
                            idUser,
                            fullName,
                            idRole,
                            role,
                            idOrganization,
                            'Kader Pokja I',
                          ),
                        ),

                        _space(),

                        _buildMenu(
                          title: 'Penghayatan & Pengamalan Pancasila',
                          route: Routes.PENGHAYATAN,
                          color1: const Color(0xFFFFF4C6),
                          color2: const Color(0xFFFFE990),
                          image: 'assets/images/ic_garuda.png',
                          args: _args(
                            idUser,
                            fullName,
                            idRole,
                            role,
                            idOrganization,
                            'Kader Pokja I',
                          ),
                        ),

                        _space(),

                        _buildMenu(
                          title: 'Gotong Royong',
                          route: Routes.GOTONG_ROYONG,
                          color1: const Color(0xFFFFEED5),
                          color2: const Color(0xFFFFDAAA),
                          image: 'assets/images/ic_gotong_royong.png',
                          args: _args(
                            idUser,
                            fullName,
                            idRole,
                            role,
                            idOrganization,
                            'Kader Pokja I',
                          ),
                        ),
                      ]
                      /// ================= POKJA II =================
                      else if (roleBidang == 'kader pokja ii') ...[
                        _buildMenu(
                          title: 'Pendidikan Ketrampilan',
                          route: Routes.PENDIDIKAN1,
                          color1: const Color(0xFFFFF4C6),
                          color2: const Color(0xFFFFE990),
                          image: 'assets/images/ic_pendidikan.png',
                          args: _args(
                            idUser,
                            fullName,
                            idRole,
                            role,
                            idOrganization,
                            'Kader Pokja II',
                          ),
                        ),

                        _space(),

                        _buildMenu(
                          title: 'Pengembangan Kehidupan Berkoperasi',
                          route: Routes.PENGEMBANGAN1,
                          color1: const Color(0xFFFFEED5),
                          color2: const Color(0xFFFFDAAA),
                          image: 'assets/images/ic_pengembangan.png',
                          args: _args(
                            idUser,
                            fullName,
                            idRole,
                            role,
                            idOrganization,
                            'Kader Pokja II',
                          ),
                        ),
                      ]
                      /// ================= POKJA III =================
                      else if (roleBidang == 'kader pokja iii') ...[
                        _buildMenu(
                          title: 'Kader Pokja III',
                          route: Routes.KADER_POKJA3,
                          color1: const Color(0xFFFFF4C6),
                          color2: const Color(0xFFFFE990),
                          image: 'assets/images/ic_pokja1.png',
                          args: _args(
                            idUser,
                            fullName,
                            idRole,
                            role,
                            idOrganization,
                            'Kader Pokja III',
                          ),
                        ),

                        _space(),

                        _buildMenu(
                          title: 'Pangan',
                          route: Routes.PANGAN1,
                          color1: const Color(0xFFFFF4C6),
                          color2: const Color(0xFFFFE990),
                          image: 'assets/images/ic_pangan.png',
                          args: _args(
                            idUser,
                            fullName,
                            idRole,
                            role,
                            idOrganization,
                            'Kader Pokja III',
                          ),
                        ),

                        _space(),

                        _buildMenu(
                          title: 'Industri Rumah Tangga',
                          route: Routes.SANDANG,
                          color1: const Color(0xFFFFEED5),
                          color2: const Color(0xFFFFDAAA),
                          image: 'assets/images/ic_industri.png',
                          args: _args(
                            idUser,
                            fullName,
                            idRole,
                            role,
                            idOrganization,
                            'Kader Pokja III',
                          ),
                        ),

                        _space(),

                        _buildMenu(
                          title: 'Perumahan & Tata Laksana',
                          route: Routes.PERUMAHAN,
                          color1: const Color(0xFFFFEED5),
                          color2: const Color(0xFFFFDAAA),
                          image: 'assets/images/ic_perumahan.png',
                          args: _args(
                            idUser,
                            fullName,
                            idRole,
                            role,
                            idOrganization,
                            'Kader Pokja III',
                          ),
                        ),
                      ]
                      /// ================= POKJA IV =================
                      else if (roleBidang == 'kader pokja iv') ...[
                        _buildMenu(
                          title: 'Kader Pokja IV',
                          route: Routes.KADER_POKJA4,
                          color1: const Color(0xFFFFF4C6),
                          color2: const Color(0xFFFFE990),
                          image: 'assets/images/ic_pokja1.png',
                          args: _args(
                            idUser,
                            fullName,
                            idRole,
                            role,
                            idOrganization,
                            'Kader Pokja IV',
                          ),
                        ),

                        _space(),

                        _buildMenu(
                          title: 'Kesehatan',
                          route: Routes.KESEHATAN,
                          color1: const Color(0xFFFFF4C6),
                          color2: const Color(0xFFFFE990),
                          image: 'assets/images/ic_kesehatan.png',
                          args: _args(
                            idUser,
                            fullName,
                            idRole,
                            role,
                            idOrganization,
                            'Kader Pokja IV',
                          ),
                        ),

                        _space(),

                        _buildMenu(
                          title: 'Kelestarian Lingkungan',
                          route: Routes.KELESTARIAN1,
                          color1: const Color(0xFFFFEED5),
                          color2: const Color(0xFFFFDAAA),
                          image: 'assets/images/ic_kelestarian.png',
                          args: _args(
                            idUser,
                            fullName,
                            idRole,
                            role,
                            idOrganization,
                            'Kader Pokja IV',
                          ),
                        ),

                        _space(),

                        _buildMenu(
                          title: 'Jumlah Rumah Yang Memiliki',
                          route: Routes.PERENCANAAN,
                          color1: const Color(0xFFFFEED5),
                          color2: const Color(0xFFFFDAAA),
                          image: 'assets/images/ic_industri.png',
                          args: _args(
                            idUser,
                            fullName,
                            idRole,
                            role,
                            idOrganization,
                            'Kader Pokja IV',
                          ),
                        ),

                        _space(),

                        _buildMenu(
                          title: 'Inovasi',
                          route: Routes.INOVASI,
                          color1: const Color(0xFFFFEED5),
                          color2: const Color(0xFFFFDAAA),
                          image: 'assets/images/ic_inovasi.png',
                          args: _args(
                            idUser,
                            fullName,
                            idRole,
                            role,
                            idOrganization,
                            'Kader Pokja IV',
                          ),
                        ),
                      ],

                      SizedBox(height: 10.h),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// ================= MENU =================
  Widget _buildMenu({
    required String title,
    required String route,
    required Color color1,
    required Color color2,
    required String image,
    required Map<String, dynamic> args,
  }) {
    return CardButtonActions(
      backroundColor: color1,
      strokeColor: color2,
      titleText: title,
      subTitle: 'Klik untuk melanjutkan',
      onTab: () => Get.toNamed(route, arguments: args),
      imageAssets: image,
    );
  }

  /// ================= SPACE =================
  Widget _space() => SizedBox(height: 16.h);

  /// ================= ARGUMENTS =================
  Map<String, dynamic> _args(
    String idUser,
    String fullName,
    String idRole,
    String role,
    String idOrganization,
    String roleBidang,
  ) {
    return {
      'id_user': idUser,
      'full_name': fullName,
      'id_role': idRole,
      'name_role': role,
      'id_organization': idOrganization,
      'name_organization': roleBidang,
    };
  }
}
