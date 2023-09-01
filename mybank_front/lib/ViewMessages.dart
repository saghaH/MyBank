import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewMessagesPage extends StatefulWidget {
  @override
  State<ViewMessagesPage> createState() => _ViewMessagesPageState();
}

class _ViewMessagesPageState extends State<ViewMessagesPage> {
  final authenticatedUser = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Messages'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: SizedBox(
                width: 200,
                height: 200,
                child: Image.asset('assets/Inbox cleanup-amico.png'),
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
