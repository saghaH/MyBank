// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'User.dart';
import 'login.dart';
import 'src/widgets.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RegisterPageState();
  }
}

Future<void> registerUsers(
  User user,
  String email,
  String password,
  String firstName,
  String lastName,
  String mobile,
  BuildContext context,
) async {
  Uri url = Uri.parse("http://192.168.1.20:8080/register");
  Map<String, dynamic> userMap = {
    "firstName": firstName,
    "lastName": lastName,
    "mobile": mobile,
    "email": email,
    "password": password,
  };
  user = User(email, password, firstName, lastName, mobile);
  //var Url = "http://localhost:8080/register";
  var response = await http.post(
    url,
    headers: <String, String>{"Content-Type": "application/json"},
    body: jsonEncode(userMap),
  );
  String responseString = response.body;
  if (response.statusCode == 200) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Backend Response'),
          content: Text(response.body),
        );
      },
    );
  } else {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Backend Response'),
          content:
              Text('An error occurred. Status code: ${response.statusCode}'),
        );
      },
    );
  }
}

class RegisterPageState extends State<RegisterPage> {
  late User user;
  TextEditingController firstController = TextEditingController();
  TextEditingController lastController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    controller: firstController,
                    decoration: const InputDecoration(
                      labelText: 'Nom',
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'lastName cannot be empty';
                      }
                      return null; // Validation passed
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: TextFormField(
                    controller: lastController,
                    decoration: const InputDecoration(
                      labelText: 'Prénom',
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'firstName cannot be empty';
                      }
                      return null; // Validation passed
                    },
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Adresse mail',
                prefixIcon: Icon(Icons.mail_outline),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Mail cannot be empty';
                }
                return null; // Validation passed
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: mobileController,
              decoration: const InputDecoration(
                labelText: 'Numéro de téléphone',
                prefixIcon: Icon(Icons.phone_iphone_outlined),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Numero de tel cannot be empty';
                }
                return null; // Validation passed
              },
            ),
            /*   const SizedBox(height: 16),
            TextFormField(
              keyboardType: TextInputType.datetime,
              decoration: const InputDecoration(
                labelText: 'Date de naissance',
                prefixIcon: Icon(Icons.calendar_today),
              ),
            ),*/
            const SizedBox(height: 16),
            /*   TextFormField(
              decoration: const InputDecoration(
                labelText: 'Poste',
                prefixIcon: Icon(Icons.work_outline),
              ),
            ),*/
            //const SizedBox(height: 16),
            /*TextFormField(
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Salaire',
                prefixIcon: Icon(Icons.paid_outlined),
              ),
            ),*/
            const SizedBox(height: 16),
            /* DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Select Role',
                prefixIcon: Icon(Icons.person),
              ),
              items: ['User', 'Admin']
                  .map((String value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      ))
                  .toList(),
              onChanged: (String? newValue) {
                setState(() {
                  roleController.text = newValue!;
                });
              },
            ),*/

            const SizedBox(height: 16),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password cannot be empty';
                }
                return null; // Validation passed
              },
            ),

            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                String firstName = firstController.text;
                String lastName = lastController.text;
                String email = emailController.text;
                String mobile = mobileController.text;
                String password = passwordController.text;

                user = User(firstName, lastName, email, password, mobile);
                await registerUsers(user, email, password, firstName, lastName,
                    mobile, context);
                firstController.text = '';
                lastController.text = '';
                emailController.text = '';
                mobileController.text = '';
                passwordController.text = '';
              },
              child: const Text('Register'),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                // Navigate to the login page when the link is tapped
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
              child: const Text(
                'If you already have an account, click here to log in',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
