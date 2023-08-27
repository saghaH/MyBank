// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

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

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(ChangeNotifierProvider(
    create: (context) => ApplicationState(),
    builder: ((context, child) => const App()),
  ));
}

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
          path: 'register', // Add this route for the "register" page
          builder: (context, state) =>
              RegisterPage(), // Replace with your actual RegisterPage widget
        ),
        GoRoute(
          path: 'login', // Add this route for the "register" page
          builder: (context, state) =>
              LoginPage(), // Replace with your actual RegisterPage widget
        ),
        GoRoute(
          path: 'forgotpassword',
          builder: (context, state) => ForgotPasswordPage(),
        ),
        GoRoute(
          path: 'dashboard',
          builder: (context, state) => DashboardPage(),
        ),
      ],
    ),
  ],
);

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'MyBank',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor:
              Color.fromRGBO(190, 49, 68, 10), // Set your desired color here
        ),
        scaffoldBackgroundColor: Color(0xFFD3D6DB),
        //scaffoldBackgroundColor: Color.fromARGB(0, 242, 32, 140),
        //hintColor: AppColors.secondary, // Use your secondary color
        // Customize other theme properties as needed
        buttonTheme: ButtonThemeData(
          buttonColor: Color.fromRGBO(190, 49, 68, 1), // Set the button color
        ),
        textTheme: GoogleFonts.robotoTextTheme(
          Theme.of(context).textTheme,
        ),

        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}
