import 'package:epkk_nganjuk/core/api_helper.dart';
import 'package:epkk_nganjuk/welcome/role_user_model.dart';
import 'package:get/get.dart';

class WelcomeController extends GetxController {
  final ApiHelper apiHelper = ApiHelper();

  var getRoleUser = Rxn<RoleUserResponse>();

  var isGetRole = false.obs;

  var roleName = ''.obs;
  var roleID = ''.obs;

  /// TAMBAHAN
  var selectedRole = ''.obs;

  var errorMessage = ''.obs;

  Future<void> getRoleUserController(String id) async {
    // kalau sudah ada data, jangan hit API lagi
    if (roleName.value.isNotEmpty &&
        roleID.value == id) {
      return;
    }

    isGetRole.value = true;
    errorMessage.value = '';

    try {
      final response = await apiHelper.get(
        '/auth/role',
        queryParameters: {"id": id},
      );

      if (response.data != null &&
          response.data['data'] != null) {
        final list = response.data['data'];

        if (list.isNotEmpty) {
          roleID.value =
              list[0]['id'].toString();

          roleName.value =
              list[0]['name'];
        }
      } else {
        errorMessage.value = "Data kosong";
      }
    } catch (e) {
      errorMessage.value =
          'Failed to fetch role';
    } finally {
      isGetRole.value = false;
    }
  }
}