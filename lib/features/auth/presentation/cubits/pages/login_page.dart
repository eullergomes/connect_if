/*
LOGIN PAGE

On thi spage, an axisting user can login with their:
- Email
- Password

----------------------------------------------------------------
Once the user sucessfully logs in, they will be redirected to the home page.

If user does not have an account, they can navigate to the register page. */

import 'package:connect_if/features/auth/presentation/components/my_button.dart';
import 'package:connect_if/features/auth/presentation/components/my_text_field.dart';
import 'package:connect_if/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:connect_if/ui/themes/class_themes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  final void Function()? togglePages;
  const LoginPage({
    super.key,
    required this.togglePages,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // login button pressed
  void login() {
    final String email = emailController.text;
    final String password = passwordController.text;

    // auth cubit
    final authCubit = context.read<AuthCubit>();

    // ensure that email and password are not empty
    if (email.isNotEmpty && password.isNotEmpty) {
      authCubit.login(email, password);
    }

    // displa error if some fields are empty
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Por favor, preencha todos os campos"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // logo
                Image.asset(
                  'assets/images/logo.png',
                  height: 80,
                ),
            
                const SizedBox(height: 50),
            
                // wekcome message
                Text(
                  "Bem vindo de volta! Sentimos sua falta",
                  style: TextStyle(
                    color: AppThemeCustom.black,
                    fontSize: 20
                  ),
                ),
            
                const SizedBox(height: 25),
                // email textfield
                MyTextField(
                  controller: emailController, 
                  hintText: "Email",	
                  obscureText: false
                ),
                const SizedBox(height: 10),
            
                // password textfield
                MyTextField(
                  controller: passwordController, 
                  hintText: "Senha",	
                  obscureText: true
                ),

                const SizedBox(height: 25),

                // login button
                MyButton(
                  onTap: login,
                  text: "Entrar",
                ),

                const SizedBox(height: 50),

                // register button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Não tem uma conta?",
                      style: TextStyle(color: AppThemeCustom.gray900),
                    ),
                    GestureDetector(
                      onTap: widget.togglePages,
                      child: Text(
                        " Registre-se agora",
                        style: TextStyle(
                          color: AppThemeCustom.gray900,
                          fontWeight: FontWeight.bold,  
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ) 
        )
      )
    );
  }
}