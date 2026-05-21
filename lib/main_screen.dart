import 'package:epkk_nganjuk/features/Riwayat/riwayat_screen.dart';
import 'package:epkk_nganjuk/features/akun/profile_controller.dart';
import 'package:epkk_nganjuk/features/akun/profile_screen.dart';
import 'package:epkk_nganjuk/features/home/home_screen.dart';
import 'package:epkk_nganjuk/features/home/nav_controller.dart';
import 'package:epkk_nganjuk/features/pengumuman/pengumuman_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class MainScreen extends StatelessWidget {
  final NavController controller = Get.find<NavController>();
  final ProfilController profilController = Get.find<ProfilController>();

  MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final Map<String, dynamic> args = Get.arguments ?? {};
    // final String? role = args['role'];

    final List<Widget> pages = [
      HomeScreen(),
      RiwayatScreen(),
      PengumumanScreen(),
      AkunPage(),
    ];

    return Obx(() => Scaffold(
          body: pages[controller.selectedIndex.value],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: controller.selectedIndex.value,
            onTap: controller.changeTabIndex,
            elevation: 8,
            backgroundColor: Colors.white,
            selectedItemColor: const Color(0xFF3F8FC1),
            unselectedItemColor: Colors.grey,
            type: BottomNavigationBarType.fixed,
            selectedFontSize: 14, // ukuran teks aktif
            unselectedFontSize: 12,
            selectedIconTheme: IconThemeData(
              size: 30,
              color: const Color(0xFF3F8FC1), // warna ikon aktif
            ),
            unselectedIconTheme: IconThemeData(
              size: 22,
              color: Colors.grey, // warna ikon tidak aktif
            ), // ukuran teks non-aktif
            
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded),
                label: 'Beranda',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list_alt_rounded),
                label: 'Riwayat',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.campaign_rounded),
                label: 'Pengumuman',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_rounded),
                label: 'Akun',
              ),
            ],
          ),
        ));
  }
}
