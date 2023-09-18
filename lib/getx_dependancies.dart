import 'package:appsyncing/repository/Network/network_controller.dart';
import 'package:appsyncing/repository/authentication/authentication_controller.dart';
import 'package:appsyncing/views/allnotes/allnotes_controller.dart';
import 'package:appsyncing/views/home/dashboard_controller.dart';
import 'package:appsyncing/views/login/login_controller.dart';
import 'package:get/get.dart';

class ProjectBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(AuthenticationController(), permanent: true);
    Get.put(NetworkController(), permanent: true);
    Get.lazyPut(() => LoginController(), fenix: true);
    Get.lazyPut(() => DashBoardController(), fenix: true);
    Get.lazyPut(() => AllNotesController(), fenix: true);
  }
}
