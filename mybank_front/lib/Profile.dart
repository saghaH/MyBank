import 'package:MyBankMobile/AddBiometric.dart';
import 'package:MyBankMobile/ModifyPassword.dart';
import 'package:MyBankMobile/app_state.dart';
import 'package:MyBankMobile/dashboard.dart';
import 'package:MyBankMobile/home_page.dart';
import 'package:MyBankMobile/login.dart';
import 'package:MyBankMobile/personalInfo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _initialSelectedIndex = 1;

  @override
  void initState() {
    super.initState();
    _initialSelectedIndex = 1;
  }

  final authenticatedUser = Get.arguments;
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<ApplicationState>(context);
    if (!(appState.loggedIn)) {
      return HomePage();
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 200,
                height: 200,
                child: Image.asset('assets/Online page-bro.png'),
              ),
              MenuOption(
                title: 'My personal info',
                icon: Icons.person,
                onTap: () {
                  try {
                    Get.to(PersonalInfoPage(), arguments: authenticatedUser);
                  } catch (e) {
                    print('Navigation error: $e');
                  }
                },
              ),
              MenuOption(
                title: 'Biometric Authentication',
                icon: Icons.fingerprint,
                onTap: () {
                  try {
                    Get.to(BiometricPage(), arguments: authenticatedUser);
                  } catch (e) {
                    print('Navigation error: $e');
                  }
                },
              ),
              MenuOption(
                title: 'Modify password',
                icon: Icons.lock,
                onTap: () {
                  try {
                    Get.to(ModifyPasswordPage(), arguments: authenticatedUser);
                  } catch (e) {
                    print('Navigation error: $e');
                  }
                },
              ),
              MenuOption(
                title: 'Log Out',
                icon: Icons.exit_to_app,
                onTap: () {
                  try {
                    appState.logout();
                    Get.to(LoginPage());
                  } catch (e) {
                    print('Navigation error: $e');
                  }
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavMenu(authenticatedUser,
            initialSelectedIndex: _initialSelectedIndex),
      );
    }
  }
}

class MenuOption extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const MenuOption(
      {required this.title, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = title == 'Log Out'
        ? Color.fromRGBO(190, 49, 68, 1)
        : const Color.fromRGBO(58, 71, 80, 0.8);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 350,
        height: 60,
        margin: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),
            SizedBox(height: 8.0),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
              ),
            )
          ],
        )),
      ),
    );
  }
}
