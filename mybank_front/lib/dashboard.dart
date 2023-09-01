import 'package:MyBankMobile/AccountMenu.dart';
import 'package:MyBankMobile/AuthenticatedUser.dart';
import 'package:MyBankMobile/Information.dart';
import 'package:MyBankMobile/Messages.dart';
import 'package:MyBankMobile/Profile.dart';
import 'package:MyBankMobile/app_state.dart';
import 'package:MyBankMobile/home_page.dart';
import 'package:MyBankMobile/ouverturecompte.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'User.dart';
import 'package:go_router/go_router.dart';
import 'package:face_camera/face_camera.dart';

class DashboardPage extends StatefulWidget {
  // late final User authenticatedUser;
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _initialSelectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _initialSelectedIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<ApplicationState>(context);

    if (!(appState.loggedIn)) {
      return HomePage();
    } else {
      AuthenticatedUser authenticatedUser = appState.authenticatedUser!;
      return Scaffold(
        appBar: AppBar(
          title: Text('Dashboard'),
          backgroundColor: Color(0xFFD3D6DB),
          automaticallyImplyLeading: false,
          centerTitle: true,
        ),
        body: Column(
          children: [
            SizedBox(
              width: 200,
              height: 200,
              child: Image.asset('assets/creditcard.png'),
            ),
            const SizedBox(height: 24),
            const SizedBox(height: 32),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 1.5,
                mainAxisSpacing: 20.0,
                crossAxisSpacing: 20.0,
                padding: EdgeInsets.all(20.0),
                children: <Widget>[
                  RectangleItem(
                      title: 'Accounts', authenticatedUser: authenticatedUser),
                  RectangleItem(
                      title: 'Credit Cards',
                      authenticatedUser: authenticatedUser),
                  RectangleItem(
                      title: 'Checks', authenticatedUser: authenticatedUser),
                  RectangleItem(
                      title: 'Transfers', authenticatedUser: authenticatedUser),
                  RectangleItem(
                      title: 'Investments',
                      authenticatedUser: authenticatedUser),
                  RectangleItem(
                      title: 'Subscriptions',
                      authenticatedUser: authenticatedUser),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavMenu(
          authenticatedUser,
          initialSelectedIndex: _initialSelectedIndex,
        ),
      );
    }
  }
}

class RectangleItem extends StatelessWidget {
  final AuthenticatedUser authenticatedUser;
  final String title;

  const RectangleItem({required this.title, required this.authenticatedUser});

  @override
  Widget build(BuildContext context) {
    void _openMenuPage() {
      switch (title) {
        case 'Accounts':
          Get.to(AccountsMenuPage(), arguments: authenticatedUser);
          break;
        // Handle other menu items
        default:
          showDialog(
            context: context,
            builder: (BuildContext dialogContext) {
              return AlertDialog(
                title: Text('Feature not yet available'),
                //content: Text('Feature not yet available.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
      }
    }

    return GestureDetector(
      onTap: _openMenuPage,
      child: Container(
        decoration: BoxDecoration(
          color: title == 'Accounts'
              ? const Color.fromRGBO(58, 71, 80, 1)
              : const Color.fromRGBO(58, 71, 80, 0.5),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: Color(0xFFD3D6DB),
              fontSize: 16.0,
            ),
          ),
        ),
      ),
    );
  }
}

class BottomNavMenu extends StatefulWidget {
  final AuthenticatedUser authenticatedUser;
  final int initialSelectedIndex;
  BottomNavMenu(this.authenticatedUser, {required this.initialSelectedIndex});

  @override
  _BottomNavMenuState createState() => _BottomNavMenuState();
}

class _BottomNavMenuState extends State<BottomNavMenu> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialSelectedIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      switch (index) {
        case 0:
          _openDashboardPage();

          break;
        case 1:
          _openProfilePage();

          break;
        case 2:
          _openMessagesPage();

          break;
        case 3:
          _openInformationPage();
          break;
      }
    });
  }

  void _openDashboardPage() {
    try {
      Get.to(DashboardPage(), arguments: widget.authenticatedUser);
    } catch (e) {
      print('Navigation error: $e');
    }
  }

  void _openInformationPage() {
    try {
      Get.to(InformationPage());
    } catch (e) {
      print('Navigation error: $e');
    }
  }

  void _openMessagesPage() {
    try {
      Get.to(MessagesPage(), arguments: widget.authenticatedUser);
    } catch (e) {
      print('Navigation error: $e');
    }
  }

  void _openProfilePage() {
    try {
      Get.to(ProfilePage(), arguments: widget.authenticatedUser);
    } catch (e) {
      print('Navigation error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.message_outlined),
          label: 'Messages',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.info_outlined),
          label: 'About Us',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Color.fromRGBO(190, 49, 68, 10),
      unselectedItemColor: Color(0xFFD3D6DB),
      onTap: _onItemTapped,
    );
  }
}
