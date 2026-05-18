import 'package:flutter/material.dart';
import '../widgets/login_form.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F4),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: const [
                LoginForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}