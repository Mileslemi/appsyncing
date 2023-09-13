import 'package:appsyncing/models/branch_model.dart';
import 'package:get/get.dart';

import '../../models/user_model.dart';

class AuthenticationController extends GetxController {
  static AuthenticationController get instance => Get.find();

  RxList<Branch> branches = RxList([
    Branch(branchName: "DESKTOP"),
    Branch(branchName: "MAIN"),
    Branch(branchName: "ANDROID"),
  ]);

  late Rx<Branch> branch;
  late Rx<User> user;

  @override
  void onInit() {
    branch = Rx(Branch(branchName: "DESKTOP"));
    user = Rx(User(username: "mileslemi", password: "1234"));
    super.onInit();
  }
}
