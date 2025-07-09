import 'package:flutter/material.dart';

import 'login.dart';
import 'signup.dart';
import 'home.dart';
import 'countries_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String countries = '/countries';

  static Map<String, WidgetBuilder> get routes => {
        login: (context) => const LoginScreen(),
        signup: (context) => const SignupScreen(),
        home: (context) => const HomeScreen(),
        countries: (context) => const CountriesScreen(),
      };
}
