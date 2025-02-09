import 'package:connect_if/features/profile/presentation/components/bio_box.dart';
import 'package:connect_if/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:connect_if/features/profile/presentation/cubits/profile_states.dart';
import 'package:connect_if/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:connect_if/ui/themes/class_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connect_if/features/auth/domain/entities/app_user.dart';
import 'package:connect_if/features/auth/presentation/cubits/auth_cubit.dart';

class ProfilePage extends StatefulWidget {
  final String uid;

  const ProfilePage({super.key, required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // cubits
  late final authCubit = context.read<AuthCubit>();
  late final profileCubit = context.read<ProfileCubit>();

  // current user
  late AppUser? currentUser = authCubit.currentUser;

  // on startup
  @override
  void initState() {
    super.initState();
    // load user profile data
    profileCubit.fetchUserProfile(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        // loaded
        if (state is ProfileLoaded) {
          // get loaded user
          final user = state.profileUser;

          return Scaffold(
            // APP BAR
            appBar: AppBar(
              title: Text(user.name),
              foregroundColor: AppThemeCustom.gray400,
              actions: [
                // edit profile
                IconButton(
                  onPressed: () => Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => EditProfilePage(user: user),
                    )),
                  icon: const Icon(Icons.settings),
                )
              ],
            ),

            // BODY
            body: Column(
              children: [
                // email
                Center(
                  child: Text(
                    user.email,
                    style: TextStyle(color: AppThemeCustom.gray400),
                  ),
                ),
            
                // profile pic
                Container(
                  decoration: BoxDecoration(
                    color: AppThemeCustom.green400,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  height: 120,
                  width: 120,
                  padding: const EdgeInsets.all(25),
                  child: Center(
                    child: Icon(
                      Icons.person,
                      size: 72,
                      color: AppThemeCustom.gray400,
                    ),
                  ),
                ),
            
                const SizedBox(height: 25),
            
                // bio box
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Row(
                    children: [
                      Text(
                        "Bio",
                        style: TextStyle(color: AppThemeCustom.gray400),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 10),
            
                BioBox(text: user.bio),

                // posts
                Padding(
                  padding: const EdgeInsets.only(left: 25.0, top: 25),
                  child: Row(
                    children: [
                      Text(
                        "Posts",
                        style: TextStyle(color: AppThemeCustom.gray400),
                      )
                    ],
                  ),
                ),
              ],
            )
          );
        }

        // loading...
        else if (state is ProfileLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return const Scaffold(
            body: Center(
              child: Text('Perfil não encontrado'),
            ),
          );
        }
      },
    );
  }
}