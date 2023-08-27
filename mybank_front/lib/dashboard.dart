import 'package:MyBankMobile/AuthenticatedUser.dart';
import 'package:MyBankMobile/ouverturecompte.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'User.dart';
import 'package:go_router/go_router.dart';

class DashboardPage extends StatefulWidget {
  // late final User authenticatedUser;
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool isDrawerOpen = false;

  void toggleDrawer() {
    setState(() {
      isDrawerOpen = !isDrawerOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authenticatedUser = Get.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: toggleDrawer,
        ),
      ),
      drawer: NavDrawer(authenticatedUser),
      body: Center(
        child:
            Text('Welcome to the Dashboard, ${authenticatedUser.firstName}!'),
      ),
    );
  }
}

class NavDrawer extends StatelessWidget {
  final AuthenticatedUser authenticatedUser;
  NavDrawer(this.authenticatedUser);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'Side menu',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            decoration: BoxDecoration(
                color: Colors.green,
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/creditcard.png'))),
          ),
          ListTile(
            leading: Icon(Icons.input),
            title: Text('Welcome'),
            onTap: () => {},
          ),
          ListTile(
            leading: Icon(Icons.verified_user),
            title: Text('Profile'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Ouverture compte'),
            onTap: () {
              try {
                Get.to(OuvertureComptePage(), arguments: authenticatedUser);
              } catch (e) {
                print('Navigation error: $e');
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.border_color),
            title: Text('Feedback'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () => {Navigator.of(context).pop()},
          ),
        ],
      ),
    );
  }
}
