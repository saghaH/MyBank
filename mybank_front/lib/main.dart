import 'dart:io';
import 'package:flutter/material.dart';
import 'package:face_camera/face_camera.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'home_page.dart';
import 'app_state.dart';
import 'register.dart';
import 'login.dart';
import 'forgotpasword.dart';
import 'dashboard.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FaceCamera.initialize();
  runApp(ChangeNotifierProvider(
    create: (context) => ApplicationState(),
    builder: ((context, child) => const App()),
  ));
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'MyBank',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromRGBO(190, 49, 68, 10)),
        //primarySwatch: Colors.orange,
        appBarTheme: AppBarTheme(
          backgroundColor: Color.fromRGBO(190, 49, 68, 10),
        ),
        scaffoldBackgroundColor: Color(0xFFD3D6DB),
        buttonTheme: ButtonThemeData(
          buttonColor: Color.fromRGBO(190, 49, 68, 1),
        ),
        textTheme: GoogleFonts.montserratTextTheme(
          Theme.of(context).textTheme,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      initialRoute: '/', //Initial route
      getPages: [
        GetPage(name: '/', page: () => const HomePage()),
        GetPage(name: '/register', page: () => RegisterPage()),
        GetPage(name: '/login', page: () => LoginPage()),
        GetPage(name: '/forgotpassword', page: () => ForgotPasswordPage()),
      ],
    );
  }
}
