import 'package:flutter/material.dart';

import 'navigation.dart';
import 'styles.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppStyles.theme,
      initialRoute: AppRoutes.login,
      routes: AppRoutes.routes,
    );
  }
}
