import 'package:MyBankMobile/AuthenticatedUser.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;
  AuthenticatedUser? _authenticatedUser;

  AuthenticatedUser? get authenticatedUser => _authenticatedUser;

  void setAuthenticatedUser(AuthenticatedUser user) {
    _authenticatedUser = user;
    notifyListeners();
  }

  void clearAuthenticatedUser() {
    _authenticatedUser = null;
    notifyListeners();
  }

  void logout() {
    _authenticatedUser = null;
    _loggedIn = false;
    notifyListeners();
  }

  Future<void> init() async {
    notifyListeners();
  }

  void setloggenIn(bool value) {
    _loggedIn = value;
    notifyListeners();
  }
}
