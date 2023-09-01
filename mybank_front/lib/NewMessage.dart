import 'dart:convert';

import 'package:MyBankMobile/app_state.dart';
import 'package:MyBankMobile/dashboard.dart';
import 'package:MyBankMobile/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'Messages.dart';
import 'package:http/http.dart' as http;

class NewMessagePage extends StatefulWidget {
  @override
  State<NewMessagePage> createState() => _NewMessagePageState();
}

class _NewMessagePageState extends State<NewMessagePage> {
  final authenticatedUser = Get.arguments;
  final _formKey = GlobalKey<FormState>();

  final List<String> dropdownOptions = ['Topic 1', 'Topic 2', 'Topic 3'];

  String selectedDropdownValue = 'Topic 1';
  String messageText = '';

  Future<void> _submitForm() async {
    Uri url = Uri.parse("http://192.168.1.18:8080/api/messages/add");

    var request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] =
        'Bearer ${authenticatedUser.accessToken}';

    // Add other form fields
    request.fields['userId'] = authenticatedUser.id.toString();
    request.fields['subject'] = selectedDropdownValue;
    request.fields['body'] = messageText;

    var response = await request.send();

    if (response.statusCode == 200) {
      Get.snackbar('Success', 'Your message was sent successfully');
      Get.to(DashboardPage(), arguments: authenticatedUser);
    } else {
      Get.snackbar(
          'Error', 'An error occurred. Status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<ApplicationState>(context);
    if (!(appState.loggedIn)) {
      return HomePage();
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Write a New Message'),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  width: 200,
                  height: 200,
                  child: Image.asset('assets/Mail-pana.png'),
                ),
                SizedBox(height: 20.0),
                DropdownButtonFormField<String>(
                  value: selectedDropdownValue,
                  items: dropdownOptions.map((String option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedDropdownValue = newValue!;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Object of the message',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: 'Message',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a message';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      messageText = value;
                    });
                  },
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    _submitForm();
                    messageText = '';
                  },
                  child: Text('Send Message'),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
