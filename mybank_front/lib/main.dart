import 'package:MyBankMobile/User.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'app_colors.dart';
import 'home_page.dart';
import 'app_state.dart';
import 'register.dart';
import 'login.dart';
import 'forgotpasword.dart';
import 'dashboard.dart';
import 'package:get/get.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

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
  final _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
        routes: [
          GoRoute(
            path: 'register',
            builder: (context, state) => RegisterPage(),
          ),
          GoRoute(
            path: 'login',
            builder: (context, state) => LoginPage(),
          ),
          GoRoute(
            path: 'forgotpassword',
            builder: (context, state) => ForgotPasswordPage(),
          ),
        ],
      ),
    ],
  );

  @override
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
        textTheme: GoogleFonts.robotoTextTheme(
          Theme.of(context).textTheme,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      initialRoute: '/', // Set the initial route
      getPages: [
        GetPage(
            name: '/',
            page: () => const HomePage()), // Define your routes using GetPage
        GetPage(name: '/register', page: () => RegisterPage()),
        GetPage(name: '/login', page: () => LoginPage()),
        GetPage(name: '/forgotpassword', page: () => ForgotPasswordPage()),
      ],
    );
  }
}
