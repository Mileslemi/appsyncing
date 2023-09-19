import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app_routing/app_routes.dart';

class NetworkController extends GetxController {
  static NetworkController get instance => Get.find();
  //let's try to put it this way,
  //instead of showing no connection when connectivty switches,
  //show no connection if user tries to fetch something and fetching
  //is failing because of socket exception
  //this is better as the other option will render the app unusable
  //unless someone has a working innternet
  //even if internet is not required

  //a late network variable that will be initialized
  //if connection lost,
  //show an undissmissable alert dialog with a dismmis btn
  //on dismmiss checkInternet

  //late Rx<ConnectivityResult> connection;

  //assuming hasInternet on startup
  static RxBool hasInternet = true.obs;

  //basic auth token need to be updated
  @override
  void onInit() async {
    ever(hasInternet, onInternetLookUp);
    super.onInit();
  }

  String decryptString(
      {required String encodedString,
      required int pos,
      required String insertedSalt}) {
    int insertedSaltLength = insertedSalt.length;
    String decryptedString =
        encodedString.replaceRange(pos, pos + insertedSaltLength, "");
    //Get.log("Decrypted String: $decryptedString");
    return decryptedString;
  }

  onInternetLookUp(hasInternet) {
    if (!hasInternet) {
      showNoConnectionDialog();
    }
  }

  void showNoConnectionDialog() {
    Get.until((route) => !Get.isDialogOpen!);
    Get.dialog(
      barrierDismissible: false,
      CupertinoAlertDialog(
        title: const Text(
          'Alert!',
        ),
        content: const Text(
          'Please check your internet connection',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              checkConnection();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void checkConnection() async {
    hasInternet.value = true;
    try {
      final lookUpAddress = await InternetAddress.lookup("google.com")
          .timeout(const Duration(seconds: 7));
      // Get.log("$lookUpAddress");
      if (lookUpAddress.isNotEmpty && lookUpAddress[0].rawAddress.isNotEmpty) {
        reloadCurrentPage();
      } else {
        hasInternet.value = false;
      }
    } on Exception catch (_) {
      hasInternet.value = false;
    }
  }

  void reloadCurrentPage() async {
    //close open dialog if any
    Get.until((route) => !Get.isDialogOpen!);

    //get previous page then pushandremove until previous page is equal to this one

    var currentRoute = Get.currentRoute;

    //push current page on stack and pop pages below until
    // Get.offNamedUntil(currentRoute, (route) {
    //   if (route is GetDialogRoute) {
    //     print("yes, is dialog");
    //     return false;
    //   } else {
    //     return (route as GetPageRoute).routeName != Get.currentRoute;
    //   }
    // });

    //default was [we were only dealing with app start and no internet]
    // Get.offAndToNamed(Get.currentRoute);

    //but due to some errors occuring in other pages when net gets back,
    //we changed to

    if (currentRoute == AppRoutes.login) {
      //We don't want to go back, as this is the first page
      Get.offAndToNamed(Get.currentRoute);
    } else {
      Get.back();
      await Future.delayed(const Duration(milliseconds: 650));
      Get.toNamed(currentRoute, preventDuplicates: true);
    }
  }
}