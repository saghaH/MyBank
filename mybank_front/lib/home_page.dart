import 'package:flutter/material.dart';
import 'register.dart';
import 'src/widgets.dart';

import 'login.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyBank'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          SizedBox(
            width: 200,
            height: 200,
            child: Image.asset('assets/creditcard.png'),
          ),
          const SizedBox(height: 8),
          const Center(
            child: Text(
              "MyBank Mobile, votre banque entre vos mains",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(
            height: 8,
            thickness: 1,
            indent: 8,
            endIndent: 8,
            color: Colors.grey,
          ),
          const Center(
            child: Text(
              "Commencez par vous authentifier à l'application",
              style: TextStyle(
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
              backgroundColor: const Color.fromRGBO(58, 71, 80, 1),
            ),
            child: const Text(
              'Login',
              style: TextStyle(
                color: Color(0xFFD3D6DB),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RegisterPage()));
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 16),
              backgroundColor: const Color.fromRGBO(58, 71, 80, 1),
            ),
            child: const Text(
              'Register',
              style: TextStyle(
                color: Color(0xFFD3D6DB),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
