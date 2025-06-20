import 'package:connect_if/features/post/presentation/components/post_title.dart';
import 'package:connect_if/features/post/presentation/cubits/post_cubit.dart';
import 'package:connect_if/features/post/presentation/cubits/posts_states.dart';
import 'package:connect_if/features/profile/domain/entities/profile_user.dart';
import 'package:connect_if/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:connect_if/features/profile/presentation/cubits/profile_states.dart';
import 'package:connect_if/features/search/components/SearchBarWidget.dart';
import 'package:connect_if/features/search/components/SearchResultsWidget.dart';
import 'package:connect_if/features/search/presentation/cubits/search_cubit.dart';
import 'package:connect_if/features/services/auth/presentation/cubits/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late final postCubit = context.read<PostCubit>();
  late final searchCubit = context.read<SearchCubit>();
  late final profileCubit = context.read<ProfileCubit>();
  late final authCubit = context.read<AuthCubit>();

  ProfileUser? currentUser;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    final uid = authCubit.currentUser?.uid;
    if (uid != null) {
      profileCubit.fetchUserProfile(uid);
    }
  }

  void fetchAllPosts() {
    if (currentUser == null) return;

    final followingUserIds = [
      ...currentUser!.following,
      currentUser!.uid,
    ];

    postCubit.fetchFollowingPosts(followingUserIds);
  }

  void deletePost(String postId) {
    postCubit.deletePost(postId);
    fetchAllPosts();
  }

  void handleSearchChanged(String query) {
    setState(() {
      searchQuery = query;
    });

    if (query.isEmpty) return;

    searchCubit.searchUsers(query);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, profileState) {
        if (profileState is ProfileLoading || profileState is ProfileInitial) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (profileState is ProfileError) {
          return Scaffold(
            body: Center(
                child:
                    Text('Erro ao carregar perfil: ${profileState.message}')),
          );
        }

        if (profileState is ProfileLoaded) {
          currentUser = profileState.profileUser;

          fetchAllPosts();

          return WillPopScope(
            onWillPop: () async {
              if (searchQuery.isNotEmpty) {
                setState(() {
                  searchQuery = '';
                  FocusScope.of(context).unfocus();
                });
                return false;
              }
              return true;
            },
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Scaffold(
                appBar: SearchBarWidget(
                  onSearchChanged: handleSearchChanged,
                ),
                body: searchQuery.isNotEmpty
                    ? const SearchResultsWidget()
                    : BlocBuilder<PostCubit, PostStates>(
                        builder: (context, postState) {
                          if (postState is PostsLoading ||
                              postState is PostUploading) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (postState is PostsLoaded) {
                            final allPosts = postState.posts;

                            if (allPosts.isEmpty) {
                              return const Center(
                                  child: Text('Nenhum post encontrado'));
                            }

                            return ListView.builder(
                              itemCount: allPosts.length,
                              itemBuilder: (context, index) {
                                final post = allPosts[index];
                                return PostTitle(
                                  post: post,
                                  onDeletePressed: () => deletePost(post.id),
                                );
                              },
                            );
                          } else if (postState is PostsError) {
                            return Center(child: Text(postState.message));
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),
              ),
            ),
          );
        }

        return const SizedBox(); // fallback
      },
    );
  }
}
