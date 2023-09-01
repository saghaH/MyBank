import 'dart:convert';

import 'package:MyBankMobile/AuthenticatedUser.dart';
import 'package:MyBankMobile/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';
import 'register.dart';
import 'forgotpasword.dart';
import 'src/widgets.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'User.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

import 'dashboard.dart';

class ModifyPasswordPage extends StatelessWidget {
  final authenticatedUser = Get.arguments;
  Future<void> login(String oldpwd, String newpwd, String confirmpwd,
      BuildContext context) async {
    final url = Uri.parse("http://192.168.1.18:8080/modifypwd");

    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${authenticatedUser.accessToken}",
    };

    final requestBody = jsonEncode({
      "oldPwd": oldpwd,
      "newPwd": newpwd,
      "confirmPwd": confirmpwd,
    });

    final response = await http.post(
      url,
      headers: headers,
      body: requestBody,
    );
    String responseBody = response.body;

    if (response.statusCode == 200) {
      Get.snackbar('Success', 'Password reset successfully');
      Get.to(DashboardPage(), arguments: authenticatedUser);
    } else {
      Get.snackbar(
          'Error', 'An error occurred. Status code: ${response.statusCode}');
    }
  }

  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPwdController = TextEditingController();
  TextEditingController confirmPwdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<ApplicationState>(context);
    if (!(appState.loggedIn)) {
      return HomePage();
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Modify Password'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: Image.asset('assets/My password-bro.png'),
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: oldPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Old Password',
                      prefixIcon: Icon(Icons.lock),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Old password cannot be empty';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Divider(),
                  TextFormField(
                    controller: newPwdController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'New Password',
                      prefixIcon: Icon(Icons.lock),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'New Password cannot be empty';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: confirmPwdController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Confirm new Password',
                      prefixIcon: Icon(Icons.lock),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'New Password cannot be empty';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      String oldpwd = oldPasswordController.text;
                      String newpwd = newPwdController.text;
                      String confirmpwd = confirmPwdController.text;
                      login(oldpwd, newpwd, confirmpwd, context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(58, 71, 80, 1),
                    ),
                    child: const Text(
                      'Modify',
                      style: TextStyle(
                        color: Color(0xFFD3D6DB),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}
