import 'package:MyBankMobile/app_state.dart';
import 'package:MyBankMobile/dashboard.dart';
import 'package:MyBankMobile/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class InformationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MenuPage(),
    );
  }
}

class MenuItem {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  MenuItem({required this.title, required this.icon, required this.onTap});
}

class MenuPage extends StatelessWidget {
  final List<MenuItem> menuItems = [
    MenuItem(
      title: 'Banking Network',
      icon: Icons.location_on,
      onTap: () {
        print('Reseau bancaire tapped');
      },
    ),
    MenuItem(
      title: 'Exchange Rate',
      icon: Icons.monetization_on,
      onTap: () {
        print('Cours de change tapped');
      },
    ),
    MenuItem(
      title: 'About MyBank',
      icon: Icons.info,
      onTap: () {
        print('À propos de MyBank tapped');
      },
    ),
    MenuItem(
      title: 'How it works',
      icon: Icons.how_to_vote,
      onTap: () {
        print('Comment ça marche tapped');
      },
    ),
    MenuItem(
      title: 'FAQ',
      icon: Icons.question_answer,
      onTap: () {
        print('FAQ tapped');
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<ApplicationState>(context);
    if (!(appState.loggedIn)) {
      return HomePage();
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('MyBank Information'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 200,
                height: 200,
                child: Image.asset('assets/About us page-amico.png'),
              ),
              for (final item in menuItems)
                MenuOption(
                  title: item.title,
                  icon: item.icon,
                  onTap: item.onTap,
                ),
            ],
          ),
        ),
      );
    }
  }
}

class MenuOption extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const MenuOption({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<ApplicationState>(context);
    if (!(appState.loggedIn)) {
      return HomePage();
    } else {
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
}
