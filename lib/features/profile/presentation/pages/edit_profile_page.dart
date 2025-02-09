import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connect_if/features/auth/presentation/components/my_text_field.dart';
import 'package:connect_if/features/profile/domain/entities/profile_user.dart';
import 'package:connect_if/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:connect_if/features/profile/presentation/cubits/profile_states.dart';
import 'package:connect_if/ui/themes/class_themes.dart';

class EditProfilePage extends StatefulWidget {
  final ProfileUser user;

  const EditProfilePage({
    super.key,
    required this.user,
    });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final bioTextController = TextEditingController();

  // update profile button pressed
  void updateProfile() async {
    // profile cubit
    final profileCubit = context.read<ProfileCubit>();

    if (bioTextController.text.isNotEmpty) {
      profileCubit.updateProfile(
        uid: widget.user.uid,
        newBio: bioTextController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      builder: (context, state) {
        // profile loading...
        if (state is ProfileLoading) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Text("Editando..."),
                ],
              ),
            ),
          );
        } else {
          return buildEditPage();
        }
      }, 
      listener: (context, state) {
        if (state is ProfileLoaded) {
          Navigator.pop(context);
        }
      },
    );
  }

  Widget buildEditPage({double uploadProgress = 0.0}) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editat  perfil"),
        foregroundColor: AppThemeCustom.gray400,
        actions: [
          // sabe button
          IconButton(
            onPressed: updateProfile,
            icon: const Icon(Icons.upload),
          )
        ],
      ),
      body: Column(
        children: [
          // profile picture

          // bio
          const Text("Bio"),

          const SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: MyTextField(
              controller: bioTextController, 
              hintText: widget.user.bio, 
              obscureText: false
            ),
          )
        ],
      ),
    );
  }
}