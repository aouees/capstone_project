import 'package:flutter/material.dart';

import 'login.dart';
import 'signup.dart';

class AppRoutes {
  static const String login = '/login';
  static const String signup = '/signup';

  static Map<String, WidgetBuilder> get routes => {
        login: (context) => const LoginScreen(),
        signup: (context) => const SignupScreen(),
      };
}
