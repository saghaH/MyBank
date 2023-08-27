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
            width: 200, // Adjust the width as needed
            height: 200, // Adjust the height as needed
            child: Image.asset('assets/creditcard.png'),
          ),
          const SizedBox(height: 8),
          //const IconAndDetail(Icons.credit_card, 'MyBank, votre banque entre vos mains'),
          //const IconAndDetail(Icons.location_city, 'San Francisco'),
          const Center(
            child: Text(
              "MyBank Mobile, votre banque entre vos mains",
              style: TextStyle(
                fontSize: 20, // Adjust the font size as needed
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
                fontSize: 16, // Adjust the font size as needed
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32), // Add spacing
          ElevatedButton(
            onPressed: () {
              // Navigate to the login page when the login button is pressed
              // You need to replace LoginPage with the actual login page widget
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
                color: Color(0xFFD3D6DB), // Button text color
              ),
            ),
          ),
          const SizedBox(height: 16), // Add spacing
          ElevatedButton(
            onPressed: () {
              // Navigate to the registration page when the register button is pressed
              // You need to replace RegisterPage with the actual registration page widget
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
                color: Color(0xFFD3D6DB), // Button text color
              ),
            ),
          ),
        ],
      ),
    );
  }
}
