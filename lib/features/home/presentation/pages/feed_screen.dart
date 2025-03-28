import 'package:connect_if/features/post/presentation/components/post_title.dart';
import 'package:connect_if/features/post/presentation/cubits/post_cubit.dart';
import 'package:connect_if/features/post/presentation/cubits/posts_states.dart';
import 'package:connect_if/features/search/components/SearchBarWidget.dart';
import 'package:connect_if/features/search/components/SearchResultsWidget.dart';
import 'package:connect_if/features/search/presentation/cubits/search_cubit.dart';
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

  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchAllPosts();
  }

  void fetchAllPosts() {
    postCubit.fetchAllPosts();
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
                builder: (context, state) {
                  if (state is PostsLoading || state is PostUploading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is PostsLoaded) {
                    final allPosts = state.posts;

                    if (allPosts.isEmpty) {
                      return const Center(child: Text('Nenhum post encontrado'));
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
                  } else if (state is PostsError) {
                    return Center(child: Text(state.message));
                  } else {
                    return const SizedBox();
                  }
                },
              ),
      ),
    ),
  );
}

}
