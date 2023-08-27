import 'package:flutter/material.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({Key? key, String? token}) : super(key: key);

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController pwdController = TextEditingController();
  final TextEditingController confirmpwdController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Password'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: pwdController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'New Password',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a new password.';
                  }

                  return null;
                },
              ),
              TextFormField(
                controller: confirmpwdController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please confirm the new password.';
                  }
                  if (value != pwdController.text) {
                    return 'Passwords do not match.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {}
                },
                child: Text('Reset Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
