import 'package:epkk_nganjuk/features/auth/button/button_file.dart';
import 'package:epkk_nganjuk/routes/app_routes.dart';
import 'package:epkk_nganjuk/welcome/welcome_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({super.key});

  final WelcomeController welcomeController =
      Get.put(WelcomeController());

  final String id1 = '1';
  final String id2 = '2';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,

      body: Stack(
        children: [
          /// BACKGROUND LEFT
          Positioned(
            top: -size.height * 0.10,
            left: -size.width * 0.18,
            child: Container(
              width: size.width * 0.65,
              height: size.width * 0.65,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF3FF),
                borderRadius: BorderRadius.circular(300),
              ),
            ),
          ),

          /// BACKGROUND RIGHT
          Positioned(
            top: -size.height * 0.07,
            right: -size.width * 0.22,
            child: Container(
              width: size.width * 0.60,
              height: size.width * 0.60,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F7FF),
                borderRadius: BorderRadius.circular(300),
              ),
            ),
          ),

          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final maxW = constraints.maxWidth;
                final maxH = constraints.maxHeight;
                final isWide = maxW > 600;

                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: maxH,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isWide ? maxW * 0.2 : maxW * 0.05,
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: maxH * 0.04),

                          /// LOGO
                          Image.asset(
                            'assets/images/logo_pkk.png',
                            width: (isWide ? 150.0 : maxW * 0.30).clamp(72.0, 150.0),
                          ),

                          SizedBox(height: 12),

                          /// TITLE
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Selamat Datang\n',
                                  style: TextStyle(
                                    fontSize: (isWide ? 32.0 : maxW * 0.065)
                                        .clamp(22.0, 32.0),
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF0B1F44),
                                    height: 1.2,
                                  ),
                                ),
                                TextSpan(
                                  text: 'di Aplikasi PKK',
                                  style: TextStyle(
                                    fontSize: (isWide ? 28.0 : maxW * 0.055)
                                        .clamp(18.0, 28.0),
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF3F8FC1),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 12),

                          /// DESCRIPTION
                          Text(
                            'Pilih akses pengguna untuk\nmelanjutkan ke aplikasi',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: (isWide ? 18.0 : maxW * 0.045)
                                  .clamp(13.0, 18.0),
                              color: Colors.grey.shade600,
                              height: 1.5,
                            ),
                          ),

                          SizedBox(height: 16),

                          /// ILLUSTRATION
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: (maxH * 0.32).clamp(140.0, 280.0),
                              maxWidth: isWide ? 300 : maxW * 0.80,
                            ),
                            child: Image.asset(
                              'assets/images/ic_welcome.png',
                              fit: BoxFit.contain,
                            ),
                          ),

                          SizedBox(height: 16),

                          /// TITLE ROLE
                          Text(
                            "Pilih Role Anda",
                            style: TextStyle(
                              fontSize: (isWide ? 24.0 : maxW * 0.055)
                                  .clamp(16.0, 24.0),
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1B2A4A),
                            ),
                          ),

                          SizedBox(height: 16),

                          /// ROLE BUTTON
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Obx(
                                  () => _roleItem(
                                    context: context,
                                    title: "Desa",
                                    icon: Icons.home_rounded,
                                    selected: welcomeController.selectedRole.value == id1,
                                    activeColor: const Color(0xFF3F8FC1),
                                    onTap: () {
                                      welcomeController.selectedRole.value = id1;
                                    },
                                  ),
                                ),
                                const SizedBox(width: 34),
                                Obx(
                                  () => _roleItem(
                                    context: context,
                                    title: "Kecamatan",
                                    icon: Icons.apartment_rounded,
                                    selected: welcomeController.selectedRole.value == id2,
                                    activeColor: const Color(0xFF3F8FC1),
                                    onTap: () {
                                      welcomeController.selectedRole.value = id2;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 28),

                          /// BUTTON
                          ZoomTapAnimation(
                            child: ButtonFill(
                              text: "Lanjutkan",
                              textColor: Colors.white,
                              onPressed: () async {
                                final selectedRole = welcomeController.selectedRole.value;

                                if (selectedRole.isEmpty) {
                                  Get.snackbar(
                                    "Peringatan",
                                    "Pilih role terlebih dahulu",
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                  );
                                  return;
                                }

                                Get.toNamed(
                                  Routes.AUTH_LOGIN,
                                  arguments: {
                                    'roleID': selectedRole,
                                    'roleName': selectedRole == '1' ? 'Desa' : 'Kecamatan',
                                  },
                                );
                              },
                            ),
                          ),

                          SizedBox(height: maxH * 0.03),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _roleItem({
    required BuildContext context,
    required String title,
    required IconData icon,
    required bool selected,
    required Color activeColor,
    required VoidCallback onTap,
  }) {
    final size = MediaQuery.of(context).size;
    final circle = (size.width * 0.16).clamp(56.0, 76.0);
    final iconSize = (size.width * 0.08).clamp(22.0, 32.0);
    final fontSize = (size.width * 0.040).clamp(12.0, 16.0);

    return GestureDetector(
      onTap: onTap,

      child: Column(
        children: [
          AnimatedContainer(
            duration:
                const Duration(milliseconds: 250),

            width: circle,
            height: circle,

            decoration: BoxDecoration(
              shape: BoxShape.circle,

              border: Border.all(
                color: selected
                    ? activeColor
                    : Colors.grey.shade300,
                width: 2,
              ),

              color: selected
                  ? activeColor.withOpacity(0.05)
                  : Colors.grey.shade100,
            ),

            child: Icon(
              icon,
              size: iconSize,
              color: selected
                  ? activeColor
                  : Colors.grey.shade400,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            title,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              color: selected
                  ? activeColor
                  : Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}
