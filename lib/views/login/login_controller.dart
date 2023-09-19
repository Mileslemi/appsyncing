import 'package:appsyncing/models/branch_model.dart';
import 'package:appsyncing/repository/authentication/authentication_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  final authController = Get.find<AuthenticationController>();

  RxBool logginIn = false.obs;

  RxList<FetchedOnlineBranch> fetchedOnlineBranches = RxList([]);

  late Rx<LocalBranch> localBranch;

  Rx<FetchedOnlineBranch> selectedOnlineBranch = Rx(FetchedOnlineBranch());

  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController localBranchText = TextEditingController();

  // find branch name in server

  @override
  void onInit() {
    fetchedOnlineBranches.value = authController.fetchedOnlineBranches;
    localBranch = authController.localBranch;
    ever(localBranch, (callback) => changeLocalBranch());
    super.onInit();
  }

  void changeLocalBranch() {
    localBranchText.text = localBranch.value.branchName ?? '';
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
      required FetchedOnlineBranch selectedBranch}) async {
    logginIn.value = true;
    bool isUserAuthenticated = await authController.authenticateUserOnline(
        username: username, password: password);

    if (isUserAuthenticated) {
      bool addSuccess = await addBranch(branch: selectedBranch);
      if (addSuccess) {
        print("all done succesfully");
        // add that user
        // Get.offAndToNamed(AppRoutes.dashboard);
      } else {
        // maybe that branch was taken online by another branch that same second
        // reload page to reflect changes
        Get.snackbar("Error!", "Try Again");
      }
    } else {
      Get.snackbar("Invalid!", "Wrong Credentials");
    }
    logginIn.value = false;
  }

  Future<bool> addBranch({required FetchedOnlineBranch branch}) async {
    bool result = await authController.addBranchToLocalTableAndUpdateOnline(
        branch: branch);

    return result;
  }
}
