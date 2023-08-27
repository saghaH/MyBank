import 'dart:io';

import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_router/go_router.dart';
import 'package:im_stepper/stepper.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'User.dart';
import 'login.dart';
import 'src/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:country_picker/country_picker.dart';
import 'package:country_picker/country_picker.dart' as country_picker;
import 'package:country_pickers/country.dart' as country_pickers;
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

class OuvertureComptePage extends StatefulWidget {
  @override
  _OuvertureCompteState createState() => _OuvertureCompteState();
}

class _OuvertureCompteState extends State<OuvertureComptePage> {
  int _currentStep = 0;
  StepperType stepperType = StepperType.vertical;
  String? _selectedValue = 'EPARGNE';
  final authenticatedUser = Get.arguments;
  List<XFile?> _selectedImages = List.generate(4, (_) => null);
  List<String> imageTitles = [
    'CIN Recto',
    'CIN Verso',
    'Justification de revenu',
    "Justificatif d'adresse"
  ];

  bool lastField = false;

//Method for http post
  Future<void> _sendDemande() async {
    Uri url = Uri.parse("http://192.168.1.20:8080/demandeouverture");
    // Create a map with the demand details
    Map<String, dynamic> demandeData = {
      'userId': authenticatedUser.id,
      'cinV': _selectedImages[0]?.path ?? '',
      'cinR': _selectedImages[1]?.path ?? '',
      'justifR': _selectedImages[2]?.path ?? '',
      'justifAdr': _selectedImages[3]?.path ?? '',
      'selfie': '', // Add the selfie path if captured
      'typeCompte': _selectedValue,
    };

    // Convert the map to a JSON string
    String demandeJson = jsonEncode(demandeData);

    // Make an HTTP POST request
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json', // Set the content type to JSON
        'Authorization':
            'Bearer ${authenticatedUser.accessToken}', // Include the auth token
      },
      body: demandeJson,
    );

    if (response.statusCode == 200) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: Text('Backend Response'),
            content: Text(response.body),
          );
        },
      );
    } else {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: Text('Backend Response'),
            content:
                Text('An error occurred. Status code: ${response.statusCode}'),
          );
        },
      );
    }
  }

//end of http post method
  //Method to upload images
  Future<void> _selectImage(int index) async {
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImages[index] = image;
      });
    }
  }

//Method for the selfie
  Future<void> _captureSelfie() async {
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      // Process the captured selfie image
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Ouvrir un compte'),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Stepper(
                type: stepperType,
                physics: ScrollPhysics(),
                currentStep: _currentStep,
                onStepTapped: (step) => tapped(step),
                onStepContinue: continued,
                onStepCancel: cancel,
                steps: <Step>[
                  Step(
                    title: new Text('Account'),
                    content: Column(
                      children: [
                        RadioListTile(
                          title: Text('Compte épargne'),
                          value: 'EPARGNE',
                          groupValue: _selectedValue,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedValue = newValue as String?;
                            });
                          },
                        ),
                        RadioListTile(
                          title: Text('Compte courant'),
                          value: 'courant',
                          groupValue: _selectedValue,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedValue = newValue as String?;
                            });
                          },
                        ),
                        RadioListTile(
                          title: Text('Compte SICAV'),
                          value: 'SICAV',
                          groupValue: _selectedValue,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedValue = newValue as String?;
                            });
                          },
                        ),
                      ],
                    ),
                    isActive: _currentStep >= 0,
                    state: _currentStep >= 0
                        ? StepState.complete
                        : StepState.disabled,
                  ),
                  Step(
                    title: new Text('General information'),
                    content: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: TextEditingController(
                              text: authenticatedUser.lastName),
                          decoration: const InputDecoration(
                            labelText: 'Nom',
                            prefixIcon: Icon(Icons.person),
                          ),
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: TextEditingController(
                              text: authenticatedUser.firstName),
                          decoration: const InputDecoration(
                            labelText: 'Prénom',
                            prefixIcon: Icon(Icons.person),
                          ),
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: TextEditingController(
                              text: authenticatedUser.cinNumber),
                          decoration: InputDecoration(
                            labelText: 'CIN Number',
                            prefixIcon: Icon(Icons.assignment_ind),
                          ),
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: TextEditingController(
                              text: authenticatedUser.email),
                          decoration: const InputDecoration(
                            labelText: 'Adresse mail',
                            prefixIcon: Icon(Icons.mail_outline),
                          ),
                        ),
                      ],
                    ),
                    isActive: _currentStep >= 0,
                    state: _currentStep >= 1
                        ? StepState.complete
                        : StepState.disabled,
                  ),
                  Step(
                    title: new Text('Personal information'),
                    content: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: TextEditingController(
                              text: authenticatedUser.mobileNumber),
                          decoration: const InputDecoration(
                            labelText: 'Numéro de téléphone',
                            prefixIcon: Icon(Icons.phone_iphone_outlined),
                          ),
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: TextEditingController(
                              text: authenticatedUser.address),
                          decoration: InputDecoration(
                            labelText: 'Address',
                            prefixIcon: Icon(Icons.home_outlined),
                          ),
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: TextEditingController(
                              text: authenticatedUser.dateOfBirth),
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
                          controller: TextEditingController(
                              text: authenticatedUser.job),
                          decoration: InputDecoration(
                            labelText: 'Job',
                            prefixIcon: Icon(Icons.work_outline),
                          ),
                        ),
                      ],
                    ),
                    isActive: _currentStep >= 0,
                    state: _currentStep >= 2
                        ? StepState.complete
                        : StepState.disabled,
                  ),
                  Step(
                    title: Text('Documents'),
                    content: Column(
                      children: <Widget>[
                        for (int i = 0; i < 4; i++)
                          ListTile(
                            title: Text(imageTitles[i]),
                            trailing: _selectedImages[i] == null
                                ? ElevatedButton(
                                    onPressed: () => _selectImage(i),
                                    child: Text('Upload'),
                                  )
                                : Image.file(
                                    File(_selectedImages[i]!.path),
                                    height: 48,
                                    width: 48,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ListTile(
                          title: Text('Selfie'),
                          trailing: ElevatedButton(
                            onPressed: _captureSelfie,
                            child: Text('Take Selfie'),
                          ),
                        ),
                      ],
                    ),
                    isActive: _currentStep >= 0,
                    state: _currentStep >= 3
                        ? StepState.complete
                        : StepState.disabled,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.list),
        onPressed: switchStepsType,
      ),
    );
  }

  switchStepsType() {
    setState(() => stepperType == StepperType.vertical
        ? stepperType = StepperType.horizontal
        : stepperType = StepperType.vertical);
  }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() {
    if (_currentStep < 3) {
      setState(() {
        _currentStep += 1;
        if (_currentStep == 3) {
          lastField = true;
        } else {
          lastField = false;
        }
      });
    } else {
      // If it's the last step, call the _sendDemande() method
      _sendDemande();
    }
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }
}
