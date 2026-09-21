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
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width > 600 ? size.width * 0.2 : size.width * 0.05, // Responsif untuk web
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          children: [
                            SizedBox(height: size.height * 0.050),
          
                            /// LOGO
                            Image.asset(
                              'assets/images/logo_pkk.png',
                              width: size.width > 600 ? 150 : size.width * 0.30,
                            ),
          
                            SizedBox(height: size.height * 0.02),
          
                            /// TITLE
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Selamat Datang\n',
                                    style: TextStyle(
                                      fontSize: size.width > 600 ? 32 : size.width * 0.065,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF0B1F44),
                                      height: 1.2,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'di Aplikasi PKK',
                                    style: TextStyle(
                                      fontSize: size.width > 600 ? 28 : size.width * 0.055,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF3F8FC1),
                                    ),
                                  ),
                                ],
                              ),
                            ),
          
                            SizedBox(height: size.height * 0.02),
          
                            /// DESCRIPTION
                            Text(
                              'Pilih akses pengguna untuk\nmelanjutkan ke aplikasi',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: size.width > 600 ? 18 : size.width * 0.045,
                                color: Colors.grey.shade600,
                                height: 1.5,
                              ),
                            ),
          
                            SizedBox(height: size.height * 0.03),
          
                            /// ILLUSTRATION
                            Expanded(
                              flex: 4,
                              child: Image.asset(
                                'assets/images/ic_welcome.png',
                                width: size.width > 600 ? 300 : size.width * 0.80,
                                fit: BoxFit.contain,
                              ),
                            ),
          
                            SizedBox(height: size.height * 0.02),
          
                            /// TITLE ROLE
                            Text(
                              "Pilih Role Anda",
                              style: TextStyle(
                                fontSize: size.width > 600 ? 24 : size.width * 0.055,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF1B2A4A),
                              ),
                            ),
          
                            SizedBox(height: size.height * 0.025),
          
                            /// ROLE BUTTON
                            Row(
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
          
                            const Spacer(),
          
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
          
                            SizedBox(height: size.height * 0.03),
                          ],
                        ),
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

    return GestureDetector(
      onTap: onTap,

      child: Column(
        children: [
          AnimatedContainer(
            duration:
                const Duration(milliseconds: 250),

            width: size.width * 0.16,
            height: size.width * 0.16,

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
              size: size.width * 0.08,
              color: selected
                  ? activeColor
                  : Colors.grey.shade400,
            ),
          ),

          SizedBox(height: size.height * 0.010),

          Text(
            title,
            style: TextStyle(
              fontSize: size.width * 0.040,
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