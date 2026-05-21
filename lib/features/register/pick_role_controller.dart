import 'package:epkk_nganjuk/features/register/role/dropdown_model.dart';
import 'package:epkk_nganjuk/features/register/role/role_bidang_list.dart';
import 'package:get/get.dart';

class PickRoleController extends GetxController {
  /// 🔹 STATE
  var kecamatanSelected = ''.obs;
  var selectedDesa = ''.obs;
  var selectedRoleBidang = ''.obs;
  var selectedRoleBidangID = 0.obs;

  var desaList = <String>[].obs;
  var roleBidang = <String>[].obs;

  String randomNumber = "1000";

  @override
  void onInit() {
    super.onInit();
    roleBidang.assignAll(RoleBidangList.roleBidangList);
  }

  /// 🔥 UPDATE KECAMATAN (FIX DISINI)
  void updateKecamatan(String kecamatan) {
    kecamatanSelected.value = kecamatan;

    print("Dipilih: [$kecamatan]");

    final kec = kecamatanList.firstWhereOrNull(
      (k) =>
          k.name.toLowerCase().contains(kecamatan.toLowerCase()) ||
          kecamatan.toLowerCase().contains(k.name.toLowerCase()),
    );

    print("Match: ${kec?.name}");

    if (kec != null) {
      desaList.assignAll(kec.desaList);
    } else {
      desaList.clear();
    }

    selectedDesa.value = '';
  }

  /// 🔥 UPDATE DESA
  void updateDesa(String desa) {
    selectedDesa.value = desa;
  }

  /// 🔥 UPDATE ROLE BIDANG
  void updateSelectedRole(String selectedRole) {
    selectedRoleBidang.value = selectedRole;

    final index = RoleBidangList.roleBidangList.indexOf(selectedRole);

    if (index != -1 &&
        index < RoleBidangList.roleBidangIDList.length) {
      selectedRoleBidangID.value =
          RoleBidangList.roleBidangIDList[index];
    } else {
      selectedRoleBidangID.value = 0;
    }

    print(
        'Role bidang: $selectedRole (${selectedRoleBidangID.value})');
  }
}