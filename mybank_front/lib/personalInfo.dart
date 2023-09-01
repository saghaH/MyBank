import 'dart:convert';

import 'package:MyBankMobile/AuthenticatedUser.dart';
import 'package:MyBankMobile/Profile.dart';
import 'package:MyBankMobile/app_state.dart';
import 'package:MyBankMobile/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class PersonalInfoPage extends StatefulWidget {
  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  final authenticatedUser = Get.arguments;
  bool isEditing = false;
  // Create controllers for editable fields
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final mobileNumberController = TextEditingController();
  final dobController = TextEditingController();
  final jobController = TextEditingController();
  final addressController = TextEditingController();

  @override
  void initState() {
    super.initState();

    firstNameController.text = authenticatedUser.firstName;
    lastNameController.text = authenticatedUser.lastName;
    mobileNumberController.text = authenticatedUser.mobileNumber;

    jobController.text = authenticatedUser.job;
    addressController.text = authenticatedUser.address;
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    mobileNumberController.dispose();

    jobController.dispose();
    addressController.dispose();
    super.dispose();
  }

  Future<void> updateUserInformation() async {
    final apiUrl = 'http://192.168.1.18:8080/update';
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${authenticatedUser.accessToken}",
    };

    final response = await http.put(
      Uri.parse(apiUrl),
      headers: headers,
      body: jsonEncode({
        "username": authenticatedUser.username,
        "firstName": firstNameController.text,
        "lastName": lastNameController.text,
        "mobileNumber": mobileNumberController.text,
        "job": jobController.text,
        "address": addressController.text,
      }),
    );

    if (response.statusCode == 200) {
      Get.snackbar('Success', 'Updated successfully');
      authenticatedUser.firstName = firstNameController.text;
      authenticatedUser.lastName = lastNameController.text;
      authenticatedUser.mobileNumber = mobileNumberController.text;
      authenticatedUser.job = jobController.text;
      authenticatedUser.address = addressController.text;
      setState(() {
        isEditing = false;
      });
      Get.to(ProfilePage(), arguments: authenticatedUser);
    } else {
      Get.snackbar('Error', 'Something went wrong!');
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
          title: Text('Personal Information'),
          actions: [
            if (!isEditing)
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  setState(() {
                    isEditing = true;
                  });
                },
              ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 200,
                height: 200,
                child: Image.asset('assets/Profile data-amico.png'),
              ),
              TextFormField(
                enabled: isEditing,
                controller: lastNameController,
                decoration: const InputDecoration(
                  labelText: 'Last Name',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                enabled: isEditing,
                controller: firstNameController,
                decoration: const InputDecoration(
                  labelText: 'First Name',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                enabled: false,
                controller:
                    TextEditingController(text: authenticatedUser.cinNumber),
                decoration: InputDecoration(
                  labelText: 'CIN Number',
                  prefixIcon: Icon(Icons.assignment_ind),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                enabled: false,
                controller:
                    TextEditingController(text: authenticatedUser.email),
                decoration: const InputDecoration(
                  labelText: 'Mail Address',
                  prefixIcon: Icon(Icons.mail_outline),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                enabled: isEditing,
                controller: mobileNumberController,
                decoration: const InputDecoration(
                  labelText: 'Mobile Number',
                  prefixIcon: Icon(Icons.phone_iphone_outlined),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                enabled: isEditing,
                controller: addressController,
                decoration: InputDecoration(
                  labelText: 'Address',
                  prefixIcon: Icon(Icons.home_outlined),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                enabled: false,
                controller: dobController,
                decoration: InputDecoration(
                  labelText: 'Date of birth',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
              ),
              SizedBox(height: 16),

              /*TextFormField(
                          controller: TextEditingController(
                              text: authenticatedUser.status),
                          decoration: InputDecoration(
                            labelText: 'Marital Status',
                            prefixIcon: Icon(Icons.supervisor_account),
                          ),
                        ),
                        SizedBox(height: 16),*/
              TextFormField(
                enabled: isEditing,
                controller: jobController,
                decoration: InputDecoration(
                  labelText: 'Job',
                  prefixIcon: Icon(Icons.work_outline),
                ),
              ),
              if (isEditing)
                ElevatedButton(
                  onPressed: () async {
                    AuthenticatedUser updatedUser = AuthenticatedUser(
                      accessToken: authenticatedUser.accessToken,
                      type: authenticatedUser.type,
                      id: authenticatedUser.id,
                      username: authenticatedUser.username,
                      email: authenticatedUser.email,
                      roles: authenticatedUser.roles,
                      firstName: firstNameController.text,
                      lastName: lastNameController.text,
                      mobileNumber: mobileNumberController.text,
                      address: '',
                      job: '',
                      dateOfBirth: '',
                      cinNumber: authenticatedUser.cinNumber,
                      biometric: authenticatedUser.biometric,
                    );

                    try {
                      await updateUserInformation();

                      setState(() {
                        isEditing = false;
                      });
                    } catch (error) {
                      print('Error updating user information: $error');
                    }
                  },
                  child: Text('Update'),
                ),
            ],
          ),
        ),
      );
    }
  }
}
