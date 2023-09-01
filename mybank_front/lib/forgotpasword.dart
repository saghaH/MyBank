import 'dart:convert';
import 'package:MyBankMobile/home_page.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:open_mail_app/open_mail_app.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> resetPassword(String email, BuildContext context) async {
    final url = Uri.parse("http://192.168.1.18:8080/api/auth/forgotpassword");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email}),
    );
    String responseString = response.body;
    if (response.statusCode == 200) {
      Get.snackbar(
          'Success', 'A password reset email has been sent to your email');
      Get.to(HomePage());
      try {
        Get.to(HomePage());
      } catch (e) {
        print('Error navigating the pages: $e');
      }
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
    ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 300,
                height: 300,
                child: Image.asset('assets/Forgot password-pana.png'),
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Adresse mail',
                  prefixIcon: Icon(Icons.mail_outline),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }

                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  String email = emailController.text;
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext dialogContext) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  );
                  await resetPassword(email, context);
                  Navigator.pop(context);
                },
                child: Text('Reset Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
