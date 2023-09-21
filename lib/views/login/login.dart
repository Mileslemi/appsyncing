// should have three textfields, branch,
// which will be autopopulated if branch Table is found in server.
// then username and password.

import 'package:appsyncing/db/sync_table.dart';
import 'package:appsyncing/models/branch_model.dart';
import 'package:appsyncing/models/note_model.dart';
import 'package:appsyncing/models/sync_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common_widgets/loading_widget.dart';
import '../../constants/sizes.dart';
import 'login_controller.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final loginController = Get.find<LoginController>();

    return SafeArea(
        child: Scaffold(
      body: Stack(
        children: [
          Form(
            key: formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * .1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(
                    () => loginController.fetchedOnlineBranches.isNotEmpty
                        ? DropdownButtonFormField<FetchedOnlineBranch>(
                            validator: (value) {
                              if (loginController
                                      .localBranch.value.branchName !=
                                  null) {
                                return null;
                              } else {
                                if (value?.id != null) {
                                  return null;
                                }
                                return "Select Branch";
                              }
                            },
                            items: loginController.fetchedOnlineBranches
                                .map<DropdownMenuItem<FetchedOnlineBranch>>(
                                    (branch) => DropdownMenuItem<
                                            FetchedOnlineBranch>(
                                        enabled: !(branch.assigned ??
                                            true), //defaulted to true if null, to make that branch name unpickable unless assigned is false
                                        value: branch,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(branch.branchName!),
                                            (branch.assigned ?? false)
                                                ? Text(
                                                    'assigned',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall
                                                        ?.apply(
                                                            fontStyle: FontStyle
                                                                .italic),
                                                  )
                                                : const SizedBox()
                                          ],
                                        )))
                                .toList(),
                            hint: const Text('Choose Branch'),
                            // initializing a value should be one of the list, since we don't want that
                            // value: loginController.selectedOnlineBranch.value,
                            disabledHint: Text(
                                loginController.localBranch.value.branchName ??
                                    ''),
                            onChanged: loginController
                                        .localBranch.value.branchName !=
                                    null
                                ? null
                                : (value) {
                                    // we'll add this value to local table
                                    loginController.selectedOnlineBranch.value =
                                        value ?? FetchedOnlineBranch();
                                  },
                          )
                        : TextFormField(
                            controller: loginController.localBranchText,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              enabled: false,
                              labelText: "Branch",
                              hintText: "Choose Branch",
                              prefixIcon: Icon(Icons.person),
                            ),
                          ),
                  ),
                  const SizedBox(
                    height: defaultSpacing,
                  ),
                  TextFormField(
                    controller: loginController.username,
                    validator: (value) {
                      if ((value ?? '').isEmpty) {
                        return "Enter Username";
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: "Username",
                      hintText: "Username",
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(
                    height: defaultSpacing,
                  ),
                  TextFormField(
                    controller: loginController.password,
                    obscureText: true,
                    validator: (value) {
                      if ((value ?? '').isEmpty) {
                        return "Enter Password";
                      } else {
                        return null;
                      }
                    },
                    decoration: const InputDecoration(
                      labelText: "Password",
                      hintText: "Password",
                      prefixIcon: Icon(Icons.password),
                    ),
                  ),
                  const SizedBox(
                    height: defaultSpacing,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // ***table actions for testing***
                      // BranchTable.delete(2);
                      // UserTable.delete(2);
                      SyncTable.delete(1);
                      // SyncTable.create(SyncModel(
                      //     lastSync: DateTime.now(),
                      //     rowsEntered: 0,
                      //     tableName: noteTableName));
                      // *****

                      // if (formKey.currentState!.validate()) {
                      //   if (loginController.localBranch.value.branchName !=
                      //       null) {
                      //     // branch was previously added to local table, local login
                      //     loginController.login(
                      //       username: loginController.username.text,
                      //       password: loginController.password.text,
                      //     );
                      //   } else {
                      //     loginController.onlineFirstSetup(
                      //         username: loginController.username.text,
                      //         password: loginController.password.text,
                      //         selectedBranch:
                      //             loginController.selectedOnlineBranch.value);
                      //   }
                      // }
                    },
                    child: const Text("LOGIN"),
                  )
                ],
              ),
            ),
          ),
          Obx(
            () => loginController.logginIn.value
                ? const LoadingWidget()
                : const SizedBox(),
          ),
        ],
      ),
    ));
  }
}
