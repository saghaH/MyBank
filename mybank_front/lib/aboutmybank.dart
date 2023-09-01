import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AboutMyBankPage extends StatefulWidget {
  @override
  State<AboutMyBankPage> createState() => _AboutMyBankPageState();
}

class _AboutMyBankPageState extends State<AboutMyBankPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About MyBank'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: SizedBox(
                width: 200,
                height: 200,
                child: Image.asset('assets/About us page-cuate.png'),
              ),
            ),
            SizedBox(height: 20.0),
            Center(
              child: Text(
                'Feature not yet available',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
