import 'package:appsyncing/repository/authentication/authentication_controller.dart';
import 'package:appsyncing/views/login/login_controller.dart';
import 'package:get/get.dart';

class ProjectBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(AuthenticationController(), permanent: true);
    Get.lazyPut(() => LoginController(), fenix: true);
  }
}
