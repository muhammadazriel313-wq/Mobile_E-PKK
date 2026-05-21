import 'package:get/get.dart';

class NavController extends GetxController {
  var selectedIndex = 0.obs; // Default aktif di 'Pengumuman'

  void changeTabIndex(int index) {
    selectedIndex.value = index;
  }
}
