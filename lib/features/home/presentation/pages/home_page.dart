import 'package:connect_if/features/home/presentation/components/my_drawer.dart';
import 'package:connect_if/features/post/presentation/components/post_title.dart';
import 'package:connect_if/features/post/presentation/pages/upload_post_page.dart';
import 'package:connect_if/features/post/presentation/cubits/post_cubit.dart';
import 'package:connect_if/features/post/presentation/cubits/posts_states.dart';
import 'package:connect_if/ui/themes/class_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // post cubit
  late final postCubit = context.read<PostCubit>();

  // on startup
  @override
  void initState() {
    super.initState();
    
    // fetch all posts
    fetcAllPosts();
  }

  void fetcAllPosts() {
    postCubit.fetchAllPosts();
  }

  void deletePost(String postId) {
    postCubit.deletePost(postId);
    fetcAllPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Início'),
        foregroundColor: AppThemeCustom.black,
        actions: [
          // upload a new post
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const UploadPostPage(),
              ),
            ),
            icon: const Icon(Icons.add),
          )
        ],
      ),

      // DRAWER
      drawer: const MyDrawer(),

      // BODY
      body: BlocBuilder<PostCubit, PostStates>(
        builder: (context, state) {
          // loading...
          if (state is PostsLoading && state is PostUploading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } 
          // loaded
          else if (state is PostsLoaded) {
            final allPosts = state.posts;

            if (allPosts.isEmpty) {
              return const Center(
                child: Text('Nenhum post encontrado'),
              );
            }
            
            return ListView.builder(
              itemCount: allPosts.length,
              itemBuilder: (context, index) {
                // get individual post
                final post = allPosts[index];

                // image
                return PostTitle(
                  post: post,
                  onDeletePressed: () => deletePost(post.id),  
                );
              },
            );
          }
          // error
          else if (state is PostsError) {
            return Center(
              child: Text(state.message),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}