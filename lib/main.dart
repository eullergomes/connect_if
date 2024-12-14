import 'package:flutter/material.dart';
import 'package:connect_if/ui/themes/class_themes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tela de Login',
      theme: AppThemeCustom.lightTheme,
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Image.asset(
                  'assets/images/logo.png',
                  height: 100,
                ),
                const SizedBox(height: 20),
                // Nome da aplicação estilizado
                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'CONNECT',
                        style: TextStyle(
                            fontSize: 32,
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.bold,
                            color: AppThemeCustom.green500),
                      ),
                      TextSpan(
                        text: 'IF',
                        style: TextStyle(
                          fontSize: 32,
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w900,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Entre para continuar',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 40),
                // Campo Matrícula
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Matrícula',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppThemeCustom.gray800,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppThemeCustom.green400, // Borda ao focar
                        width: 1, // Borda mais espessa ao focar
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    hintText: 'Digite sua matricula',
                    hintStyle: TextStyle(color: AppThemeCustom.gray600),
                  ),
                  style: TextStyle(color: AppThemeCustom.gray900),
                ),
                const SizedBox(height: 20),
                // Campo Senha
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Senha (SUAP)',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppThemeCustom.gray800, // Borda padrão (gray800)
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppThemeCustom.green400, // Borda ao focar
                        width: 1, // Borda mais espessa ao focar
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    hintText: 'Digite sua senha', // Texto placeholder
                    hintStyle: TextStyle(color: AppThemeCustom.gray600),
                  ),
                  style: TextStyle(color: AppThemeCustom.gray900),
                ),
                const SizedBox(height: 40),
                // Botão Entrar
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Ação do botão
                    },
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        backgroundColor: AppThemeCustom.green500),
                    child: const Text(
                      'Entrar na conta',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
