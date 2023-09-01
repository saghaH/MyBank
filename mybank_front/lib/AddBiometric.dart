import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;

class BiometricPage extends StatelessWidget {
  final authenticatedUser = Get.arguments;

  Future<void> activateBiometric() async {
    final url = Uri.parse("http://192.168.1.18:8080/activate-biometric");

    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer ${authenticatedUser.accessToken}",
      },
      body: {
        "userId": authenticatedUser.id.toString(),
      },
    );

    if (response.statusCode == 200) {
      // Biometric activation successful
      Get.snackbar('Success', 'Biometric authentication activated');
    } else {
      // Handle error
      Get.snackbar('Error', 'Failed to activate biometric authentication');
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
            BiometricButton(onPressed: activateBiometric),
          ],
        ),
      ),
    );
  }
}

class BiometricButton extends StatelessWidget {
  final void Function() onPressed;

  BiometricButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text('Activate'),
    );
  }
}
