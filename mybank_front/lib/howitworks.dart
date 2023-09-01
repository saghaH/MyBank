import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HIWPage extends StatefulWidget {
  @override
  State<HIWPage> createState() => _HIWPageState();
}

class _HIWPageState extends State<HIWPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('How it works'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: SizedBox(
                width: 200,
                height: 200,
                child: Image.asset('assets/Instruction manual-cuate.png'),
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
