import 'package:connect_if/features/auth/presentation/components/my_button.dart';
import 'package:connect_if/features/auth/presentation/components/my_text_field.dart';
import 'package:connect_if/ui/themes/class_themes.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // logo
                Icon(
                  Icons.lock_open_rounded,
                  size: 80,
                  color: AppThemeCustom.gray400,
                ),
            
                const SizedBox(height: 50),
            
                // create account message
                Text(
                  "Vamos criar um conta para você",
                  style: TextStyle(
                    color: AppThemeCustom.black,
                    fontSize: 20
                  ),
                ),
            
                const SizedBox(height: 25),
                // name textfield
                MyTextField(
                  controller: nameController, 
                  hintText: "Nome",	
                  obscureText: false
                ),
                const SizedBox(height: 10),

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
                const SizedBox(height: 10),

                // confirma password textfield
                MyTextField(
                  controller: confirmPasswordController, 
                  hintText: "Confirmar senha",	
                  obscureText: true
                ),

                const SizedBox(height: 25),

                // register button
                MyButton(
                  onTap: () {},
                  text: "Criar conta",
                ),

                const SizedBox(height: 50),

                // already a member? login now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Já tem uma conta?",
                      style: TextStyle(color: AppThemeCustom.blue400),
                    ),
                    GestureDetector(
                      onTap: widget.togglePages,
                      child: Text(
                        "Entre agora",
                        style: TextStyle(
                          color: AppThemeCustom.blue600,
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