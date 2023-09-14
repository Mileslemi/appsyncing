import 'package:appsyncing/models/branch_model.dart';
import 'package:appsyncing/repository/authentication/authentication_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app_routing/app_routes.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  final authController = Get.find<AuthenticationController>();

  List<Branch> branches = [];

  Rx<Branch> thisBranch = Rx(Branch());

  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  // find branch name in server

  @override
  void onInit() {
    branches = authController.branches;

    thisBranch.value = authController.branch.value;
    super.onInit();
  }

  void login(String username, String password) {
    if (username == authController.user.value.username &&
        password == authController.user.value.password) {
      Get.offAndToNamed(AppRoutes.dashboard);
    } else {
      Get.snackbar("Invalid!", "Wrong Credentials");
    }
  }
}
