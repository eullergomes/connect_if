import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_if/features/post/domain/entities/comment.dart';
import 'package:connect_if/features/post/domain/entities/post.dart';
import 'package:connect_if/features/post/domain/repos/post_repo.dart';

class FirebasePostRepos implements PostRepo {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // store the posts in a collection called 'posts'
  final CollectionReference postsCollection = 
    FirebaseFirestore.instance.collection('posts');

  @override
  Future<void> createPost(Post post) async {
    try {
      await postsCollection.doc(post.id).set(post.toJson());
    } catch (e) {
      throw Exception("Erro ao criar post: $e");
    }
  }

  @override
  Future<void> deletePost(String postId) async {
    await postsCollection.doc(postId).delete();
  }

  @override
  Future<List<Post>> fetchAllPosts() async {
    try {
      // get all posts with most recent at the top
      final postSnapshot = 
        await postsCollection.orderBy('timestamp', descending: true).get();
    
      // convert each firestore document from json -> list of posts
      final List<Post> allPosts = postSnapshot.docs
        .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
        .toList();

      return allPosts;
    } catch (e) {
      throw Exception("Erro ao buscar os posts: $e");
    }
  }

  @override
  Future<List<Post>> fetchPostsByUserId(String userId) async {
    try {
      // fetch posts snapshot with this uid
      final postSnapshot = 
        await postsCollection.where('userId', isEqualTo: userId).get();

      // convert firestore documents from json -> list of posts
      final userPosts = postSnapshot.docs
        .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
        .toList();

      return userPosts;
    } catch (e) {
      throw Exception("Erro ao buscar os posts do usuário: $e");
    }
  }

  @override
  Future<void> toggleLikePost(String postId, String userId) async {
    try {
      // get the post document from firestore
      final postDoc = await postsCollection.doc(postId).get();

      if (postDoc.exists) {
        final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);

        // check if the user has already liked this post
        final hasLiked = post.likes.contains(userId);

        // update the likes list
        if (hasLiked) {
          post.likes.remove(userId); // unlike
        } else {
          post.likes.add(userId); // like
        }

        // update the post document with the new like list
        await postsCollection.doc(postId).update({'likes': post.likes});
      } else {
        throw Exception("Post não encontrado");
      }
    } catch (e) {
      throw Exception("Erro ao curtir post: $e");
    }
  }

  @override
  Future<void> addComment(String postId, Comment comment) async {
    try {
      // get post document
      final postDoc = await postsCollection.doc(postId).get();

      if (postDoc.exists) {
        final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);

        // add the comment to the post
        post.comments.add(comment);

        // update the post document in firestore
        await postsCollection.doc(postId).update({
          'comments': post.comments.map((comment) => comment.toJson()).toList(),
        });
      } else {
        throw Exception("Post não encontrado");
      }
    } catch (e) {
      throw Exception("Erro ao adicionar comentário: $e");
    }
  }

  @override
  Future<void> deleteComment(String postId, String commentId) async {
    try {
      // get post document
      final postDoc = await postsCollection.doc(postId).get();

      if (postDoc.exists) {
        final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);

        // add the comment to the post
        post.comments.removeWhere((comment) => comment.id == commentId);

        // update the post document in firestore
        await postsCollection.doc(postId).update({
          'comments': post.comments.map((comment) => comment.toJson()).toList(),
        });
      } else {
        throw Exception("Post não encontrado");
      }
    } catch (e) {
      throw Exception("Erro ao apagar comentário: $e");
    }
  }
}