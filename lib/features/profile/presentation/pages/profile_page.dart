import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_if/features/config/pages/config_page.dart';
import 'package:connect_if/features/post/presentation/components/post_title.dart';
import 'package:connect_if/features/post/presentation/cubits/post_cubit.dart';
import 'package:connect_if/features/post/presentation/cubits/posts_states.dart';
import 'package:connect_if/features/post/domain/entities/post.dart';
import 'package:connect_if/features/profile/presentation/components/bio_box.dart';
import 'package:connect_if/features/profile/presentation/components/follow_button.dart';
import 'package:connect_if/features/profile/presentation/components/profile_stats.dart';
import 'package:connect_if/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:connect_if/features/profile/presentation/cubits/profile_states.dart';
import 'package:connect_if/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:connect_if/features/profile/presentation/pages/follower_page.dart';
import 'package:connect_if/ui/themes/class_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connect_if/features/services/auth/domain/entities/app_user.dart';
import 'package:connect_if/features/services/auth/presentation/cubits/auth_cubit.dart';

class ProfilePage extends StatefulWidget {
  final String uid;

  const ProfilePage({super.key, required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

enum _ProfileMenuOption { edit, settings, logout }

class _ProfilePageState extends State<ProfilePage> {
  // cubits
  late final authCubit = context.read<AuthCubit>();
  late final profileCubit = context.read<ProfileCubit>();

  // current user
  late AppUser? currentUser = authCubit.currentUser;

  // posts
  int postCount = 0;

  // on startup
  @override
  void initState() {
    super.initState();
    // load user profile data
    profileCubit.fetchUserProfile(widget.uid);
  }

  /*
    FOLLOW / UNFOLLOW
  */

  void followButtonPressed() {
    final profileState = profileCubit.state;
    if (profileState is! ProfileLoaded) {
      return;
    }

    final profileUser = profileState.profileUser;
    final isFollwind = profileUser.followers.contains(currentUser!.uid);

    // optimistically update UI
    setState(() {
      // unfollow
      if (isFollwind) {
        profileUser.followers.remove(currentUser!.uid);
      } else {
        // follow
        profileUser.followers.add(currentUser!.uid);
      }
    });

    // perform actual toggle in cubit
    profileCubit
        .toggleFollow(
      currentUser!.uid,
      widget.uid,
    )
        .catchError((error) {
      // unfollow
      if (isFollwind) {
        profileUser.followers.add(currentUser!.uid);
      } else {
        // follow
        profileUser.followers.remove(currentUser!.uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isOwnPost = (widget.uid == currentUser!.uid);

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoaded) {
          final user = state.profileUser;

          return Scaffold(
            appBar: AppBar(
              title: Text(user.name),
              foregroundColor: AppThemeCustom.black,
              actions: [
                if (isOwnPost)
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (value) {
                      switch (value) {
                        case 'edit':
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfilePage(user: user),
                            ),
                          );
                          break;
                        case 'settings':
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SettingsPage(),
                            ),
                          );
                          break;
                        case 'logout':
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Confirmar saída'),
                              content:
                                  const Text('Você realmente deseja sair?'),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context), // Fecha o modal
                                  child: const Text(
                                    'Cancelar',
                                    style: TextStyle(color: Colors.green),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context); // Fecha o modal
                                    authCubit.logout();
                                    Navigator.of(context)
                                        .popUntil((route) => route.isFirst);
                                  },
                                  child: const Text(
                                    'Sair',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          );
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: ListTile(
                          leading: Icon(Icons.edit),
                          title: Text('Editar perfil'),
                        ),
                      ),
                      PopupMenuItem(
                        value: 'settings',
                        child: ListTile(
                          leading: Icon(Icons.settings),
                          title: Text('Configurações'),
                        ),
                      ),
                      PopupMenuItem(
                        value: 'logout',
                        child: ListTile(
                          leading: Icon(Icons.logout),
                          title: Text('Sair'),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            body: BlocBuilder<PostCubit, PostStates>(
              builder: (context, postState) {
                List<Post> userPosts = [];
                if (postState is PostsLoaded) {
                  userPosts = postState.posts
                      .where((post) => post.userId == widget.uid)
                      .toList();
                }

                return Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: ListView(
                    children: [
                      Center(
                        child: Text(
                          user.email,
                          style: TextStyle(color: AppThemeCustom.black),
                        ),
                      ),
                      const SizedBox(height: 20),
                      CachedNetworkImage(
                        imageUrl: user.profileImageUrl,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(
                          Icons.person,
                          size: 72,
                          color: AppThemeCustom.black,
                        ),
                        imageBuilder: (context, imageProvider) => Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      ProfileStats(
                        postCount: userPosts.length,
                        followersCount: user.followers.length,
                        followingCount: user.following.length,
                        onPostsTap: () {
                          // No-op ou rolar para os posts
                        },
                        onFollowersTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FollowerPage(
                                followers: user.followers,
                                following: user.following,
                              ),
                            ),
                          );
                        },
                        onFollowingTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FollowerPage(
                                followers: user.followers,
                                following: user.following,
                              ),
                            ),
                          );
                        },
                      ),
                      if (!isOwnPost)
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: FollowButton(
                            onPressed: followButtonPressed,
                            isFollowing:
                                user.followers.contains(currentUser!.uid),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0, top: 25.0),
                        child: Row(
                          children: [
                            Text(
                              "Bio",
                              style: TextStyle(
                                color: AppThemeCustom.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      BioBox(text: user.bio),
                      const SizedBox(height: 25),
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0),
                        child: Row(
                          children: [
                            Text(
                              "Posts",
                              style: TextStyle(
                                color: AppThemeCustom.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (postState is PostsLoaded)
                        ListView.builder(
                          itemCount: userPosts.length,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final post = userPosts[index];
                            return PostTitle(
                              post: post,
                              onDeletePressed: () =>
                                  context.read<PostCubit>().deletePost(post.id),
                            );
                          },
                        )
                      else if (postState is PostsLoading)
                        const Center(child: CircularProgressIndicator())
                      else
                        const Center(child: Text('Nenhum post encontrado')),
                    ],
                  ),
                );
              },
            ),
          );
        } else if (state is ProfileLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          return const Scaffold(
            body: Center(child: Text('Perfil não encontrado')),
          );
        }
      },
    );
  }
}
