import 'package:flutter/material.dart';
import 'navigation.dart';
import 'styles.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: AppStyles.containerPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Login Screen', style: AppStyles.headerTextStyle),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.signup);
              },
              style: AppStyles.buttonStyle,
              child: const Text('Go to Signup'),
            ),
          ],
        ),
      ),
    );
  }
}
