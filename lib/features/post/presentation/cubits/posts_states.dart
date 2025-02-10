import 'package:connect_if/features/post/domain/entities/post.dart';

abstract class PostStates {}

class PostsInitial extends PostStates {}

class PostsLoading extends PostStates {}

class PostUploading extends PostStates {}

class PostsError extends PostStates {
  final String message;

  PostsError(this.message);
}

class PostsLoaded extends PostStates {
  final List<Post> posts;
  PostsLoaded(this.posts);
}


