import 'dart:io';
import 'package:MyBankMobile/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ImportationComptePage extends StatefulWidget {
  @override
  _ImportationComptePageState createState() => _ImportationComptePageState();
}

class _ImportationComptePageState extends State<ImportationComptePage> {
  int _initialSelectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _initialSelectedIndex = 0;
  }

  List<File?> _selectedImages = List.generate(2, (_) => null);
  final authenticatedUser = Get.arguments;

  List<String> imageTitles = ['cinVerso', 'cinRecto'];

  int _currentStep = 0;

  StepperType stepperType = StepperType.vertical;

  Future<void> _sendDemande() async {
    Uri url = Uri.parse("http://192.168.1.18:8080/api/demandeimportation");

    var request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] =
        'Bearer ${authenticatedUser.accessToken}';

    request.fields['userId'] = authenticatedUser.id.toString();

    // Add the images
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

    var response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      Get.snackbar('Success', 'Upload Request sent successfully');
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
        title: Text('Import my accounts'),
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
                    title: new Text('General information'),
                    content: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: TextEditingController(
                              text: authenticatedUser.lastName),
                          decoration: const InputDecoration(
                            labelText: 'Last Nom',
                            prefixIcon: Icon(Icons.person),
                          ),
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: TextEditingController(
                              text: authenticatedUser.firstName),
                          decoration: const InputDecoration(
                            labelText: 'First Name',
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
                            labelText: 'Mail Address',
                            prefixIcon: Icon(Icons.mail_outline),
                          ),
                        ),
                        TextFormField(
                          controller: TextEditingController(
                              text: authenticatedUser.mobileNumber),
                          decoration: const InputDecoration(
                            labelText: 'Mobile Number',
                            prefixIcon: Icon(Icons.phone_iphone_outlined),
                          ),
                        ),
                      ],
                    ),
                    isActive: _currentStep >= 0,
                    state: _currentStep >= 0
                        ? StepState.complete
                        : StepState.disabled,
                  ),
                  Step(
                    title: Text('Documents'),
                    content: Column(
                      children: <Widget>[
                        for (int i = 0; i < 2; i++)
                          ListTile(
                            title: Text(imageTitles[i]),
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
                      ],
                    ),
                    isActive: _currentStep >= 0,
                    state: _currentStep >= 1
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
    if (_currentStep < 1) {
      setState(() {
        _currentStep += 1;
      });
    } else {
      _sendDemande();
    }
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }
}
