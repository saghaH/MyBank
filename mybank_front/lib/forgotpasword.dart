import 'dart:convert';
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
    final url = Uri.parse("http://192.168.1.20:8080/api/auth/forgotpassword");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email}),
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
      try {
        await OpenMailApp.openMailApp();
      } catch (e) {
        print('Error launching email app: $e');
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
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
                onPressed: () {
                  String email = emailController.text;
                  resetPassword(email, context);
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
