import 'package:appsyncing/repository/authentication/authentication_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashBoardController extends GetxController {
  static DashBoardController get instance => Get.find();

  final authController = Get.find<AuthenticationController>();

  RxInt currentPage = 0.obs;

  late Rx<Widget> currentPageWidget;

  RxString branchName = "".obs;

  RxString lastSync = "2023-09-13 ...".obs;

  List<Widget> pages = <Widget>[];
  @override
  void onInit() {
    // currentPageWidget = Rx<Widget>(pages[currentPage.value]);
    branchName.value = authController.branch.value.branchName ?? '';

    ever(currentPage, (val) => changePage(toPage: val));
    super.onInit();
  }

  void changePage({required int toPage}) {
    currentPageWidget.value = pages[toPage];
  }
}
