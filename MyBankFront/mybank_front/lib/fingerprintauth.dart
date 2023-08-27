import 'package:MyBankMobile/dashboard.dart';
import 'package:flutter/material.dart';
import 'register.dart';
import 'src/widgets.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'login.dart';

class FingerPrintAuth extends StatelessWidget {
  const FingerPrintAuth({Key? key}) : super(key: key);

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
      }
    } on PlatformException catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    _authenticateWithFingerprint(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyBank'),
      ),
      /*  body: Center(
        child: ElevatedButton(
          onPressed: () => _authenticateWithFingerprint(context),
          child: const Text('Authenticate with Fingerprint'),
        ),
      ),*/
    );
  }
}
