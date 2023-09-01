import 'package:MyBankMobile/app_state.dart';
import 'package:MyBankMobile/dashboard.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:im_stepper/stepper.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'User.dart';
import 'login.dart';
import 'src/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:country_picker/country_picker.dart';
import 'package:country_picker/country_picker.dart' as country_picker;
import 'package:country_pickers/country.dart' as country_pickers;
import 'package:intl/intl.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RegisterPageState();
  }
}

Future<void> registerUsers(
  User user,
  String email,
  String password,
  String firstName,
  String lastName,
  String mobile,
  String cinnum,
  String address,
  String job,
  String dateofbirth,
  String gender,
  String status,
  String username,
  BuildContext context,
) async {
  Uri url = Uri.parse("http://192.168.1.18:8080/api/auth/signup");
  Map<String, dynamic> userMap = {
    "username": username,
    "firstName": firstName,
    "lastName": lastName,
    "mobileNumber": mobile,
    "email": email,
    "password": password,
    "cinNumber": cinnum,
    "address": address,
    "job": job,
    "dateOfBirth": dateofbirth,
  };

  var response = await http.post(
    url,
    headers: <String, String>{"Content-Type": "application/json"},
    body: jsonEncode(userMap),
  );
  String responseString = response.body;
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

    Get.to(LoginPage());
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

class RegisterPageState extends State<RegisterPage> {
  late User user;
  final List<String> genderOptions = ['Male', 'Female', 'Other'];
  final List<String> maritalStatusOptions = [
    'Single',
    'Married',
    'Divorced',
    'Widowed'
  ];

  TextEditingController firstController = TextEditingController();
  TextEditingController lastController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController cinController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController jobController = TextEditingController();
  TextEditingController maritalStatusController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController nationalityController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  String selectedCountryName = '';

  DateTime _dob = DateTime.now();
  String _gender = 'Female';
  String _MaritalStatus = 'Single';
  //String _Nationality = 'Tunisie';
  String selectedCountryCode = 'US';

  int _currentStep = 0;
  StepperType stepperType = StepperType.vertical;
  country_picker.Country? selectedCountry;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<ApplicationState>(context);

    if (appState.loggedIn) {
      return DashboardPage();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Create an account'),
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
                          controller: lastController,
                          decoration: const InputDecoration(
                            labelText: 'Last Name',
                            prefixIcon: Icon(Icons.person),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'lastName cannot be empty';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: firstController,
                          decoration: const InputDecoration(
                            labelText: 'First Name',
                            prefixIcon: Icon(Icons.person),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'firstName cannot be empty';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            labelText: 'Mail Adress',
                            prefixIcon: Icon(Icons.mail_outline),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Mail cannot be empty';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: usernameController,
                          decoration: const InputDecoration(
                            labelText: 'Username',
                            prefixIcon: Icon(Icons.person),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Username cannot be empty';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password cannot be empty';
                            }
                            return null;
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
                    title: Text('Personal Information'),
                    content: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: mobileController,
                          decoration: const InputDecoration(
                            labelText: 'Mobile Number',
                            prefixIcon: Icon(Icons.phone_iphone_outlined),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Numero de tel cannot be empty';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: cinController,
                          decoration: InputDecoration(
                            labelText: 'CIN Number',
                            prefixIcon: Icon(Icons.assignment_ind),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'CIN field cannot be empty';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: addressController,
                          decoration: InputDecoration(
                            labelText: 'Address',
                            prefixIcon: Icon(Icons.home_outlined),
                          ),
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: dobController,
                          onTap: () async {
                            DateTime? selectedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );
                            if (selectedDate != null) {
                              _dob = selectedDate;
                              dobController.text =
                                  DateFormat('dd-MM-yyyy').format(selectedDate);
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'Date of Birth',
                            hintText: 'Select your date of birth',
                            prefixIcon: Icon(Icons.calendar_today),
                          ),
                        ),
                        SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _gender,
                          onChanged: (value) {
                            setState(() {
                              _gender = value!;
                              genderController.text = value;
                            });
                          },
                          items: genderOptions
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          decoration: InputDecoration(
                            labelText: 'Gender',
                            prefixIcon: Icon(Icons.face),
                          ),
                        ),
                        SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _MaritalStatus,
                          onChanged: (value) {
                            setState(() {
                              _MaritalStatus = value!;
                              maritalStatusController.text = value;
                            });
                          },
                          items: maritalStatusOptions
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          decoration: InputDecoration(
                            labelText: 'Marital Status',
                            prefixIcon: Icon(Icons.supervisor_account),
                          ),
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: jobController,
                          decoration: InputDecoration(
                            labelText: 'Job',
                            prefixIcon: Icon(Icons.work_outline),
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

  continued() async {
    if (_currentStep < 1) {
      setState(() {
        _currentStep += 1;
      });
    } else {
      String firstName = firstController.text;
      String lastName = lastController.text;
      String email = emailController.text;
      String mobile = mobileController.text;
      String password = passwordController.text;
      String cinnum = cinController.text;
      String address = addressController.text;
      String job = jobController.text;
      String gender = genderController.text;
      String status = maritalStatusController.text;
      String uname = usernameController.text;

      String formattedDate = _dob.toIso8601String();

      user = User(firstName, lastName, email, password, mobile, cinnum, address,
          job, formattedDate, gender, status);
      await registerUsers(user, email, password, firstName, lastName, mobile,
          cinnum, address, job, formattedDate, gender, status, uname, context);
      firstController.text = '';
      lastController.text = '';
      emailController.text = '';
      mobileController.text = '';
      passwordController.text = '';
      passwordController.text = '';
      cinController.text = '';
      addressController.text = '';
      jobController.text = '';
    }
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }
}
