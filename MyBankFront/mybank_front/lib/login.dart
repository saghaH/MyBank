// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';

import 'package:flutter/material.dart';
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
import 'fingerprintauth.dart';
import 'dashboard.dart';

class LoginPage extends StatelessWidget {
  static final _auth = LocalAuthentication();

  static Future<bool> hasBiometrics() async {
    try {
      return await _auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      return false;
    }
  }

  static Future<List<BiometricType>> getBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      return <BiometricType>[];
    }
  }

  Future<void> _authenticateWithFingerprint(BuildContext context) async {
    final isAvailable = await hasBiometrics();

    if (!isAvailable) {
      // Handle the case where biometrics is not available
      return;
    }

    try {
      bool authenticated = await _auth.authenticate(
        localizedReason: 'Scan Fingerprint to Authenticate',
        //useErrorDialogs: true,
        //stickyAuth: true,
      );

      if (authenticated) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => DashboardPage()));
        Provider.of<ApplicationState>(context, listen: false).setloggenIn(true);
      }
    } on PlatformException catch (e) {
      print('Error: $e');
    }
  }

  User user = User("", "", "", "", "");
  Uri url = Uri.parse("http://192.168.1.20:8080/login");
  //String url = 'http://localhost:8080/login';
  Future save(BuildContext context) async {
    var res = await http.post(url,
        headers: {'Context-Type': 'application/json'},
        body: json.encode({'email': user.email, 'password': user.password}));
    String responseString = res.body;
    if (res.statusCode == 200) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: Text('Backend Response'),
            content: Text(res.body),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: TextEditingController(text: user.email),
                onChanged: (val) {
                  user.email = val;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Email is empty';
                  }
                  return '';
                },
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: TextEditingController(text: user.password),
                onChanged: (val) {
                  user.password = val;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Password is empty';
                  }
                  return '';
                },
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  save(context);
                },
                style: ElevatedButton.styleFrom(
                  // padding:
                  //  const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                  backgroundColor: const Color.fromRGBO(58, 71, 80, 1),
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(
                    color: Color(0xFFD3D6DB), // Button text color
                  ),
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  // Navigate to the login page when the link is tapped
                  Navigator.push(
                      context,
                      // ignore: inference_failure_on_instance_creation
                      MaterialPageRoute(builder: (context) => RegisterPage()));
                },
                child: const Text(
                  "Don't have an account ? click here to create one",
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Navigate to the login page when the link is tapped
                  Navigator.push(
                      context,
                      // ignore: inference_failure_on_instance_creation
                      MaterialPageRoute(
                          builder: (context) => const ForgotPasswordPage()));
                },
                child: const Text(
                  "Forgot password ?",
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              SizedBox(height: 150),
              ElevatedButton(
                onPressed: () => _authenticateWithFingerprint(context),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                  backgroundColor: const Color.fromRGBO(58, 71, 80, 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.fingerprint,
                      color: Color(0xFFD3D6DB),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Authenticate with Fingerprint',
                      style: TextStyle(
                        color: Color(0xFFD3D6DB),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
