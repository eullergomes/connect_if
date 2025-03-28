import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_if/features/post/presentation/components/post_title.dart';
import 'package:connect_if/features/post/presentation/cubits/post_cubit.dart';
import 'package:connect_if/features/post/presentation/cubits/posts_states.dart';
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
    // is own post
    final isOwnPost = (widget.uid == currentUser!.uid);
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
              foregroundColor: AppThemeCustom.black,
              actions: [
              // edit profile
              if (isOwnPost)
              IconButton(
                onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                builder: (context) => EditProfilePage(user: user),
                )),
                icon: const Icon(Icons.edit),
              ),
              // logout
              IconButton(
              onPressed: () {
                authCubit.logout();
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              icon: const Icon(Icons.logout),
              ),
              ],
              ),

              // BODY
              body: Padding(
              padding: const EdgeInsets.only(top: 10.0), // Added spacing
              child: ListView(
              children: [
                // email
                  Center(
                    child: Text(
                      user.email,
                      style: TextStyle(color: AppThemeCustom.black),
                    ),
                  ),

                  // profile pic
                  const SizedBox(height: 20),
                  CachedNetworkImage(
                    imageUrl: user.profileImageUrl,
                    // loading
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),

                    // error -> failed to load
                    errorWidget: (context, url, error) => Icon(
                      Icons.person,
                      size: 72,
                      color: AppThemeCustom.black,
                    ),

                    // loaded
                    imageBuilder: (context, imageProvider) => Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit
                                .contain, // Changed from BoxFit.cover to BoxFit.contain
                          )),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // profile stats
                  ProfileStats(
                    postCount: postCount,
                    followersCount: user.followers.length,
                    followingCount: user.following.length,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FollowerPage(
                                followers: user.followers,
                                following: user.following,
                              )),
                    ),
                  ),
                  // follow button
                    if (!isOwnPost)
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: FollowButton(
                      onPressed: followButtonPressed,
                      isFollowing: user.followers.contains(currentUser!.uid),
                      ),
                    ),

                  // bio box
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

                  const SizedBox(height: 10),

                    // posts
                    Padding(
                    padding: const EdgeInsets.only(left: 25.0, top: 25),
                    child: Row(
                      children: [
                      Text(
                        "Posts",
                        style: TextStyle(
                          color: AppThemeCustom.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16), // Increased font size
                      )
                      ],
                    ),
                    ),

                  const SizedBox(height: 10),

                  // list of posts from this user
                  BlocBuilder<PostCubit, PostStates>(builder: (context, state) {
                    // posts loaded
                    if (state is PostsLoaded) {
                      // filter posts by user id
                      final userPosts = state.posts
                          .where((post) => post.userId == widget.uid)
                          .toList();

                      postCount = userPosts.length;

                      return ListView.builder(
                          itemCount: postCount,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            // get individual post
                            final post = userPosts[index];

                            // return as post title UI
                            return PostTitle(
                              post: post,
                              onDeletePressed: () =>
                                  context.read<PostCubit>().deletePost(post.id),
                            );
                          });
                    }

                    // posts loading...
                    else if (state is PostsLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return const Center(
                        child: Text('Nenhum post encontrado'),
                      );
                    }
                  })
                ],
              ))
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
