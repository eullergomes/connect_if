import 'dart:typed_data';
import 'package:connect_if/features/post/domain/entities/comment.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connect_if/features/post/domain/entities/post.dart';
import 'package:connect_if/features/post/domain/repos/post_repo.dart';
import 'package:connect_if/features/post/presentation/cubits/posts_states.dart';
import 'package:connect_if/features/storage/domain/storage_repo.dart';

class PostCubit extends Cubit<PostStates> {
  final PostRepo postRepo;
  final StorageRepo storageRepo;

  PostCubit({
    required this.postRepo, 
    required this.storageRepo
  }) : super(PostsInitial());

  // create a new post
  Future<void> createPost(Post post,
      {String? imagePath, Uint8List? imageBytes}) async {
    String? imageUrl;

    try {
      // handle image upload for mobile platforms (using file path)
      if (imagePath != null) {
        emit(PostUploading());
        imageUrl =
            await storageRepo.uploadPostImageMobile(imagePath, post.id);
      }

      // handle image upload for web platforms (using file bytes)
      else if (imageBytes != null) {
        emit(PostUploading());
        imageUrl = await storageRepo.uploadPostImageWeb(imageBytes, post.id);
      }

      // give image url to post
      final newPost = post.copyWith(imageUrl: imageUrl);

      // re-fetch all posts
      fetchAllPosts();

      // create post in the backend
      postRepo.createPost(newPost);
    } catch (e) {
      emit(PostsError("Erro ao criar post: $e"));
    }
  }

  // fetch all posts
  Future<void> fetchAllPosts() async {
    try {
      emit(PostsLoading());
      final posts = await postRepo.fetchAllPosts();
      emit(PostsLoaded(posts));
    } catch (e) {
      emit(PostsError("Erro ao buscar posts: $e"));
    }
  }

  // delete a post
  Future<void> deletePost(String postId) async {
    try {
      await postRepo.deletePost(postId);
      emit(PostsLoaded([]));
    } catch (e) {}
  }

  // toggle like on a post
  Future<void> toggleLikePost(String postId, String userId) async {
    try {
      await postRepo.toggleLikePost(postId, userId);
    } catch (e) {
      emit(PostsError("Erro ao curtir post: $e"));
    }
  }

  // add a comment to a post
  Future<void> addComment(String postId, Comment comment) async {
    try {
      await postRepo.addComment(postId, comment);

      await fetchAllPosts();
    } catch (e) {
      emit(PostsError("Erro ao adicionar comentário: $e"));
    }
  }

  // delete a comment from a post
  Future<void> deleteComment(String postId, String commentId) async {
    try {
      await postRepo.deleteComment(postId, commentId);
      
      await fetchAllPosts();
    } catch (e) {
      emit(PostsError("Erro ao apagar comentário: $e"));
    }
  }
}