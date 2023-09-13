// should have three textfields, branch,
// which will be autopopulated if branch Table is found in server.
// then username and password.

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/sizes.dart';
import 'login_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    final loginController = Get.find<LoginController>();

    return SafeArea(
        child: Scaffold(
      body: Form(
        key: formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * .25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(
                () => DropdownButtonFormField<String>(
                  items: loginController.branches
                      .map<DropdownMenuItem<String>>((branch) =>
                          DropdownMenuItem<String>(
                              value: branch.branchName,
                              child: Text(branch.branchName!)))
                      .toList(),
                  value: loginController.thisBranch.value.branchName,
                  disabledHint:
                      Text(loginController.thisBranch.value.branchName ?? ''),
                  onChanged: loginController.thisBranch.value.branchName != null
                      ? null
                      : (value) {
                          // we'll add this value to local table
                        },
                ),
              ),
              const SizedBox(
                height: defaultSpacing,
              ),
              TextFormField(
                controller: loginController.username,
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
                decoration: const InputDecoration(
                  labelText: "Password",
                  hintText: "Password",
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(
                height: defaultSpacing,
              ),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    loginController.login(loginController.username.text,
                        loginController.password.text);
                  }
                },
                child: const Text("LOGIN"),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
