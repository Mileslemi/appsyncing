import 'package:appsyncing/repository/authentication/authentication_controller.dart';
import 'package:appsyncing/views/notes/conflict_notes_screen.dart';
import 'package:appsyncing/views/notes/local_notes.dart';
import 'package:appsyncing/views/notes/unsynced_notes_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../notes/allnotes.dart';

class DashBoardController extends GetxController {
  static DashBoardController get instance => Get.find();

  final authController = Get.find<AuthenticationController>();

  RxInt currentPage = 0.obs;

  late Rx<Widget> currentPageWidget;

  List<Widget> pages = <Widget>[
    const AllNotes(),
    const LocalNotes(),
    const ConflictNotesScreen(),
    const UnSyncedNotesScreen()
  ];
  @override
  void onInit() async {
    currentPageWidget = Rx<Widget>(pages[currentPage.value]);
    ever(currentPage, (val) => changePage(toPage: val));
    super.onInit();
  }

  void changePage({required int toPage}) {
    currentPageWidget.value = pages[toPage];
  }
}
