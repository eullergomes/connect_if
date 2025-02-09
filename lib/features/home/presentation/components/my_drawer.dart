import 'package:connect_if/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:connect_if/features/home/presentation/components/my_drawer_title.dart';
import 'package:connect_if/features/home/presentation/pages/home_page.dart';
import 'package:connect_if/features/profile/presentation/pages/profile_page.dart';
import 'package:connect_if/ui/themes/class_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50.0),
                child: Icon(
                  Icons.person,
                  size: 80,
                  color: AppThemeCustom.gray400,
                ),
              ),

              // divider line
              const Divider(
                color: AppThemeCustom.gray400,
              ),
          
              // home title
              MyDrawerTitle(
                title: "Início", 
                icon: Icons.home, 
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ),
                  );
                }
              ),
          
              // profile title
              MyDrawerTitle(
                title: "Perfil", 
                icon: Icons.person, 
                onTap: () {
                  // pop menu drawer
                  Navigator.of(context).pop();

                  // get current user
                  final user = context.read<AuthCubit>().currentUser;
                  String? uid = user!.uid;

                  // navigate to profile page
                  Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(uid: uid),
                    ),
                  );
                }
              ),

              // search title
              MyDrawerTitle(
                title: "Buscar", 
                icon: Icons.search, 
                onTap: () {},
              ),

              // settings title
              MyDrawerTitle(
                title: "Configurações", 
                icon: Icons.settings, 
                onTap: () {},
              ),
          
              // logout title
              MyDrawerTitle(
                title: "Sair", 
                icon: Icons.logout, 
                onTap: () => context.read<AuthCubit>().logout(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}