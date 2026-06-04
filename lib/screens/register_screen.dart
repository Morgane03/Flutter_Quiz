import 'package:flutter/material.dart';
import '../widgets/register_form.dart';
import '../assets/const/color.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightSable,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: const RegisterForm(),
          ),
        ),
      ),
    );
  }
}