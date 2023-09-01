import 'dart:io';
import 'package:MyBankMobile/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class OuvertureComptePage extends StatefulWidget {
  @override
  _OuvertureComptePageState createState() => _OuvertureComptePageState();
}

class _OuvertureComptePageState extends State<OuvertureComptePage> {
  int _initialSelectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _initialSelectedIndex = 0;
  }

  File? _selfieImage;
  List<File?> _selectedImages = List.generate(4, (_) => null);
  String? _selectedValue;
  final authenticatedUser = Get.arguments;

  List<String> imageTitles = ['cinVerso', 'cinR', 'justifR', 'justifAdr'];
  List<String> imageLabels = [
    'cin Verso',
    'cin Recto',
    'Justificatif Revenu',
    'Justificatif Adresse'
  ];

  int _currentStep = 0;

  StepperType stepperType = StepperType.vertical;
  void _captureSelfie() async {
    final imageFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 5,
    );
    if (imageFile != null) {
      setState(() {
        _selfieImage = File(imageFile.path);
      });
    }
  }

  Future<void> _sendDemande() async {
    Uri url = Uri.parse("http://192.168.1.18:8080/api/demandeouverture");

    var request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] =
        'Bearer ${authenticatedUser.accessToken}';

    // Add other form fields
    request.fields['userId'] = authenticatedUser.id.toString();
    request.fields['typeCompte'] = _selectedValue!;

    // Add images
    for (int i = 0; i < _selectedImages.length; i++) {
      if (_selectedImages[i] != null) {
        final imageFile = _selectedImages[i]!;
        request.files.add(http.MultipartFile(
          imageTitles[i],
          imageFile.readAsBytes().asStream(),
          imageFile.lengthSync(),
          filename: imageFile.path.split('/').last,
        ));
      }
    }

    if (_selfieImage != null) {
      request.files.add(http.MultipartFile(
        'selfie',
        _selfieImage!.readAsBytes().asStream(),
        _selfieImage!.lengthSync(),
        filename: _selfieImage!.path.split('/').last,
      ));
    }

    // Send the request
    var response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      Get.snackbar('Success', 'Request sent successfully');
      Get.to(DashboardPage(), arguments: authenticatedUser);
    } else {
      Get.snackbar(
          'Error', 'An error occurred. Status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                            title: Text(imageLabels[i]),
                            trailing: _selectedImages[i] == null
                                ? ElevatedButton(
                                    onPressed: () async {
                                      final imageFile = await ImagePicker()
                                          .pickImage(
                                              source: ImageSource.gallery,
                                              imageQuality: 5);
                                      if (imageFile != null) {
                                        setState(() {
                                          _selectedImages[i] =
                                              File(imageFile.path);
                                        });
                                      }
                                    },
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
      bottomNavigationBar: BottomNavMenu(
        authenticatedUser,
        initialSelectedIndex: _initialSelectedIndex,
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
          var lastField = true;
        } else {
          var lastField = false;
        }
      });
    } else {
      _sendDemande();
    }
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }
}
