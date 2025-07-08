import 'package:flutter/material.dart';
import 'styles.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signup'),
      ),
      body: Padding(
        padding: AppStyles.containerPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Signup Screen', style: AppStyles.headerTextStyle),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: AppStyles.buttonStyle,
              child: const Text('Back to Login'),
            ),
          ],
        ),
      ),
    );
  }
}
