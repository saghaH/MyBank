import 'package:MyBankMobile/NewMessage.dart';
import 'package:MyBankMobile/ViewMessages.dart';
import 'package:MyBankMobile/app_state.dart';
import 'package:MyBankMobile/dashboard.dart';
import 'package:MyBankMobile/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';

class MessagesPage extends StatefulWidget {
  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  int _initialSelectedIndex = 2;

  @override
  void initState() {
    super.initState();
    _initialSelectedIndex = 2;
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
          title: Text('Messages'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 200,
                height: 200,
                child: Image.asset('assets/Messaging-amico.png'),
              ),
              MenuOption(
                title: 'Send message to the support',
                icon: Icons.send,
                onTap: () {
                  try {
                    Get.to(NewMessagePage(), arguments: authenticatedUser);
                  } catch (e) {
                    print('Navigation error: $e');
                  }
                },
              ),
              MenuOption(
                title: 'Recieved messages',
                icon: Icons.mail_outline,
                onTap: () {
                  try {
                    Get.to(ViewMessagesPage(), arguments: authenticatedUser);
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
