/*
- list of follwers
- list of following
*/

import 'package:connect_if/features/profile/presentation/components/user_title.dart';
import 'package:connect_if/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:connect_if/ui/themes/class_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FollowerPage extends StatelessWidget {
  final List<String> followers;
  final List<String> following;

  const FollowerPage({
    super.key,
    required this.followers,
    required this.following,
  });

  @override
  Widget build(BuildContext context) {
    // TAB CONTROLLER
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            dividerColor: Colors.transparent,
            labelColor: AppThemeCustom.black,
            unselectedLabelColor: AppThemeCustom.green400,
            tabs: const [
              Tab(text: "Seguidores"),
              Tab(text: "Seguindo",)
            ]),
          ),

          // Tab Bar View
          body: TabBarView(
            children: [
              _buildUserList(followers, "Sem seguidores", context),
              _buildUserList(followers, "Sem seguindo", context),
            ]),
        ),
      );
  }

  // build user list, given a list of profile uids
  Widget _buildUserList(
    List<String> uids, String emptyMessage, BuildContext context) {
      return uids.isEmpty
        ? Center(child: Text(emptyMessage))
        : ListView.builder(
          itemCount: uids.length,
          itemBuilder: (context, index) {
            // get each uid
            final uid = uids[index];

            return FutureBuilder(
              future: context.read<ProfileCubit>().getUserProfile(uid),
              builder: (context, snapshot) {
                // user loaded
                if (snapshot.hasData) {
                  final user = snapshot.data!;
                  return UserTitle(user: user);
                }

                // loading...
                else if (snapshot.connectionState == ConnectionState.waiting) {
                  return ListTile(title: Text("Carregando..."));
                }

                // not found...
                else {
                  return ListTile(title: Text("Usuário não encontrado..."));
                }
              },
            );
          },
        );
    }
}