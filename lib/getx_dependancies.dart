import 'package:appsyncing/repository/Network/network_controller.dart';
import 'package:appsyncing/repository/authentication/authentication_controller.dart';
import 'package:appsyncing/repository/syncing/sync_controller.dart';
import 'package:appsyncing/views/notes/notes_controller.dart';
import 'package:appsyncing/views/home/dashboard_controller.dart';
import 'package:appsyncing/views/login/login_controller.dart';
import 'package:get/get.dart';

import 'views/addEditNote/add_edit_ctrl.dart';
import 'views/conflict/resolve_conflict_ctrl.dart';

class ProjectBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(AuthenticationController(), permanent: true);
    Get.put(NetworkController(), permanent: true);
    Get.put(SyncController(), permanent: true);
    Get.put(NotesController(), permanent: true);
    Get.lazyPut(() => LoginController(), fenix: true);
    Get.lazyPut(() => DashBoardController(), fenix: true);
    Get.lazyPut(() => ResolveConflictController(), fenix: true);
    Get.lazyPut(() => AddEditController(), fenix: true);
  }
}
