import 'package:crud_test/worker.dart';
import 'package:get/get.dart';

class MysqlBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MysqlController>(() => MysqlController());
  }
}

class MysqlController extends GetxController {
  final userList = [].obs;
  final isUpdate = false.obs;

  @override
  void onInit() {
    super.onInit();
    getAll();
    ever(isUpdate, (value) async {
      if (value == true) {
        getAll();
        isUpdate.value = false;
      }
    });
  }

  Future getAll() async {
    return userList.value = await selectAllMysql()
        .then((value) => value)
        .onError((error, stackTrace) => error);
  }

  Future deleteUser(int uid) async {
    return await deleteUserMysql(uid)
        .then((value) => value)
        .onError((error, stackTrace) => error);
  }

  Future updateUser(
    int uid,
    String username,
    String userpass,
    String userfullname,
  ) async {
    return await updateMysql(
      uid,
      username,
      userpass,
      userfullname,
    ).then((value) => value).onError((error, stackTrace) => error);
  }
}
