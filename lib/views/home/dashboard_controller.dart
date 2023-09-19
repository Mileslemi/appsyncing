import 'package:appsyncing/repository/authentication/authentication_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../allnotes/allnotes.dart';

class DashBoardController extends GetxController {
  static DashBoardController get instance => Get.find();

  final authController = Get.find<AuthenticationController>();

  RxInt currentPage = 0.obs;

  late Rx<Widget> currentPageWidget;

  RxString branchName = "".obs;

  List<Widget> pages = <Widget>[
    const AllNotes(),
  ];
  @override
  void onInit() {
    currentPageWidget = Rx<Widget>(pages[currentPage.value]);
    branchName.value = authController.localBranch.value.branchName ?? '';

    ever(currentPage, (val) => changePage(toPage: val));
    super.onInit();
  }

  void changePage({required int toPage}) {
    currentPageWidget.value = pages[toPage];
  }
}
