/*
Auth Page - This Page determines whether to show the login or register page
 */

import 'package:connect_if/features/auth/presentation/cubits/pages/login_page.dart';
import 'package:connect_if/features/auth/presentation/cubits/pages/register_page.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {

  // initianlly show the login page
  bool showLoginPage = true;

  // toggle between pages
  void togglePage() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(
        togglePages: togglePage,
      );
    } else {
      return RegisterPage(
        togglePages: togglePage,
      );
    }
  }
}