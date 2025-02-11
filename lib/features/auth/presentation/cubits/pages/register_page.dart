import 'package:connect_if/features/auth/presentation/components/my_button.dart';
import 'package:connect_if/features/auth/presentation/components/my_text_field.dart';
import 'package:connect_if/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:connect_if/ui/themes/class_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? togglePages;
  const RegisterPage({
    super.key,
    required this.togglePages,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // register button pressed
  void register() {
    final String name = nameController.text;
    final String email = emailController.text;
    final String password = passwordController.text;
    final String confirmPassword = confirmPasswordController.text;

    // auth cubit
    final authCubit = context.read<AuthCubit>();

    // ensure fields are not empty
    if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty && confirmPassword.isNotEmpty) {
      // ensure passwords match
      if (password == confirmPassword) {
        authCubit.register(name, email, password);
      }
      // passwords do not match
      else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("As senhas não coincidem"),
          ),
        );
      }
    }
    // fields are empt -> display error
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Por favor, preencha todos os campos"),
        ),
      );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    resizeToAvoidBottomInset: false, // Impede que o teclado empurre os widgets
    body: SafeArea(
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Mantém a altura mínima necessária
                children: [
                  // Logo
                  Image.asset(
                    'assets/images/logo.png',
                    height: 80,
                  ),

                  const SizedBox(height: 50),

                  // Create account message
                  Text(
                    "Vamos criar uma conta para você",
                    style: TextStyle(
                      color: AppThemeCustom.black,
                      fontSize: 20,
                    ),
                  ),

                  const SizedBox(height: 25),

                  // Name textfield
                  MyTextField(
                    controller: nameController,
                    hintText: "Nome",
                    obscureText: false,
                  ),
                  const SizedBox(height: 10),

                  // Email textfield
                  MyTextField(
                    controller: emailController,
                    hintText: "Email",
                    obscureText: false,
                  ),
                  const SizedBox(height: 10),

                  // Password textfield
                  MyTextField(
                    controller: passwordController,
                    hintText: "Senha",
                    obscureText: true,
                  ),
                  const SizedBox(height: 10),

                  // Confirm password textfield
                  MyTextField(
                    controller: confirmPasswordController,
                    hintText: "Confirmar senha",
                    obscureText: true,
                  ),

                  const SizedBox(height: 25),

                  // Register button
                  MyButton(
                    onTap: register,
                    text: "Criar conta",
                  ),

                  const SizedBox(height: 50),

                  // Already a member? Login now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Já tem uma conta?",
                        style: TextStyle(color: AppThemeCustom.gray900),
                      ),
                      GestureDetector(
                        onTap: widget.togglePages,
                        child: Text(
                          " Entre agora",
                          style: TextStyle(
                            color: AppThemeCustom.gray900,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

}