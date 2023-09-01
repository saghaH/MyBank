import 'package:MyBankMobile/Comptes.dart';
import 'package:MyBankMobile/SuiviImportation.dart';
import 'package:MyBankMobile/SuiviOuverture.dart';
import 'package:MyBankMobile/dashboard.dart';
import 'package:MyBankMobile/importationCompte.dart';
import 'package:MyBankMobile/ouverturecompte.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class AccountsMenuPage extends StatefulWidget {
  @override
  State<AccountsMenuPage> createState() => _AccountsMenuPageState();
}

class _AccountsMenuPageState extends State<AccountsMenuPage> {
  int _initialSelectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _initialSelectedIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    final authenticatedUser = Get.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Accounts Menu'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              height: 200,
              child: Image.asset('assets/Dropdown menu-amico.png'),
            ),
            MenuOption(
              title: 'View my accounts',
              icon: Icons.account_balance,
              onTap: () {
                try {
                  Get.to(ComptesPage(), arguments: authenticatedUser);
                } catch (e) {
                  print('Navigation error: $e');
                }
              },
            ),
            MenuOption(
              title: 'open an account',
              icon: Icons.add_box_outlined,
              onTap: () {
                try {
                  Get.to(OuvertureComptePage(), arguments: authenticatedUser);
                } catch (e) {
                  print('Navigation error: $e');
                }
              },
            ),
            MenuOption(
              title: "Track account opening",
              icon: Icons.check,
              onTap: () {
                try {
                  Get.to(SuiviOuverturePage(), arguments: authenticatedUser);
                } catch (e) {
                  print('Navigation error: $e');
                }
              },
            ),
            MenuOption(
              title: 'Import my accounts',
              icon: Icons.upload_file_outlined,
              onTap: () {
                try {
                  Get.to(ImportationComptePage(), arguments: authenticatedUser);
                } catch (e) {
                  print('Navigation error: $e');
                }
              },
            ),
            MenuOption(
              title: "Track account import",
              icon: Icons.check,
              onTap: () {
                try {
                  Get.to(SuiviImportationPage(), arguments: authenticatedUser);
                } catch (e) {
                  print('Navigation error: $e');
                }
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavMenu(
        authenticatedUser,
        initialSelectedIndex: _initialSelectedIndex,
      ),
    );
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 350,
        height: 60,
        margin: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(58, 71, 80, 0.8),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 16.0,
              ),
              SizedBox(width: 10.0),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
