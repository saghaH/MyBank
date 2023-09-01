import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class BiometricPage extends StatelessWidget {
  final authenticatedUser = Get.arguments;

  Future<void> activateBiometric(String password) async {
    final url = Uri.parse("http://192.168.1.18:8080/api/biometric/add");

    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer ${authenticatedUser.accessToken}",
      },
      body: {
        "username": authenticatedUser.username,
        "password": password,
      },
    );

    final statusCode = response.statusCode;

// Get the response body as a string
    final responseBody = response.body;
    if (response.statusCode == 200) {
      // Biometric activation successful
      Get.snackbar('Success', 'Biometric authentication activated');
    } else {
      // Handle error
      Get.snackbar('Error', '$responseBody and code is $statusCode');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Biometric Authentication'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              height: 200,
              child: Image.asset('assets/Fingerprint-bro.png'),
            ),
            SizedBox(height: 20),
            Text(
              'Activate Biometric Authentication',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: (authenticatedUser.biometric == true)
                  ? null
                  : () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return BiometricActivationDialog(
                            onActivate: activateBiometric,
                          );
                        },
                      );
                    },
              child: Text(
                (authenticatedUser.biometric == true)
                    ? 'Feature already activated'
                    : 'Activate',
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BiometricActivationDialog extends StatefulWidget {
  final void Function(String password) onActivate;

  BiometricActivationDialog({required this.onActivate});

  @override
  _BiometricActivationDialogState createState() =>
      _BiometricActivationDialogState();
}

class _BiometricActivationDialogState extends State<BiometricActivationDialog> {
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Enter Password to Activate'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: passwordController,
            obscureText: true, // Hide the entered password
            decoration: InputDecoration(labelText: 'Password'),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              String password = passwordController.text;
              widget.onActivate(password);
              Navigator.of(context).pop();
            },
            child: Text('Activate'),
          ),
        ],
      ),
    );
  }
}
