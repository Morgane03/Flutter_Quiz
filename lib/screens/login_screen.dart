import 'package:flutter/material.dart';
import '../widgets/login_form.dart';
import '../assets/const/color.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightSable,
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