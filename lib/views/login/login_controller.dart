import 'package:appsyncing/models/branch_model.dart';
import 'package:appsyncing/repository/authentication/authentication_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app_routing/app_routes.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  final authController = Get.find<AuthenticationController>();

  RxBool logginIn = false.obs;

  RxList<FetchedOnlineBranch> fetchedOnlineBranches = RxList([]);

  Rx<LocalBranch> localBranch = Rx(LocalBranch());

  Rx<FetchedOnlineBranch> selectedOnlineBranch = Rx(FetchedOnlineBranch());

  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  // find branch name in server

  @override
  void onInit() {
    fetchedOnlineBranches.value = authController.fetchedOnlineBranches;

    localBranch.value = authController.localBranch.value;
    super.onInit();
  }

  void localLogin({
    required String username,
    required String password,
  }) async {
    print('local login');
  }

  void onlineLogin(
      {required String username,
      required String password,
      required int branchId}) async {
    logginIn.value = true;
    bool isUserAuthenticated = await authController.authenticateUserOnline(
        username: username, password: password);

    if (isUserAuthenticated) {
      //addBranchToLocal(id: branchId);
      print(authController.user.value);
      // Get.offAndToNamed(AppRoutes.dashboard);
    } else {
      Get.snackbar("Invalid!", "Wrong Credentials");
    }
    logginIn.value = false;
  }

  void addBranchToLocal({required int id}) async {
    // should be performed by authenticated user,
    // so first check user is admin,
    // if true add branch, if result is 1, add user to table also
    int result = await authController.addBranchToLocalTable(id: id);
  }
}
