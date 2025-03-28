import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_if/features/auth/domain/entities/app_user.dart';
import 'package:connect_if/features/auth/presentation/components/my_text_field.dart';
import 'package:connect_if/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:connect_if/features/post/domain/entities/comment.dart';
import 'package:connect_if/features/post/domain/entities/post.dart';
import 'package:connect_if/features/post/presentation/components/comment_title.dart';
import 'package:connect_if/features/post/presentation/cubits/post_cubit.dart';
import 'package:connect_if/features/post/presentation/cubits/posts_states.dart';
import 'package:connect_if/features/profile/domain/entities/profile_user.dart';
import 'package:connect_if/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:connect_if/features/profile/presentation/pages/profile_page.dart';
import 'package:connect_if/ui/themes/class_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostTitle extends StatefulWidget {
  final Post post;
  final void Function()? onDeletePressed;

  const PostTitle({
    super.key,
    required this.post,
    required this.onDeletePressed,
  });

  @override
  State<PostTitle> createState() => _PostTitleState();
}

class _PostTitleState extends State<PostTitle> {
  // cubits
  late final postCubit = context.read<PostCubit>();
  late final profileCubit = context.read<ProfileCubit>();

  bool isDownPost = false;

  // current user
  AppUser? currentUser;

  // post user
  ProfileUser? postUser;

  // on startup
  @override
  void initState() {
    super.initState();

    getCurrentUser();
    fetchPostUser();
  }

  void getCurrentUser() {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
    isDownPost = (widget.post.userId == currentUser!.uid);
  }

  Future<void> fetchPostUser() async {
    final fetchedUser = await profileCubit.getUserProfile(widget.post.userId);
    if (fetchedUser != null) {
      setState(() {
        postUser = fetchedUser;
      });
    }
  }

  /*
  LIKES
  */

  // user tapped like button
  void toggleLikePost() {
    // current like status
    final isLiked = widget.post.likes.contains(currentUser!.uid);

    // optimistically like & update UI
    setState(() {
      if (isLiked) {
        widget.post.likes.remove(currentUser!.uid); // unlike
      } else {
        widget.post.likes.add(currentUser!.uid); // like
      }
    });

    // update like
    postCubit.toggleLikePost(widget.post.id, currentUser!.uid).catchError((error) {
      // revert like & update UI
      setState(() {
        if (isLiked) {
          widget.post.likes.add(currentUser!.uid); // revert unlike
        } else {
          widget.post.likes.remove(currentUser!.uid); // revert like
        }
      });
    });
  }

  /*
  COMMENTS 
  */

  // comment text controller
  final commentTextController = TextEditingController();

  // open commet box -> user wants to type a new comment
  void openNewCommentBox() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: MyTextField(
          controller: commentTextController,
          hintText: "Escreva um comentário...",
          obscureText: false,
        ),
        actions: [
          // cancel button
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar', style: TextStyle(color: AppThemeCustom.black)),
          ),

          // save button
          TextButton(
            onPressed: () {
              addComment();
              Navigator.of(context).pop();
            },
            child: const Text('Comentar', style: TextStyle(color: AppThemeCustom.black)),
          ),
        ]
      )
    );
  }

  void addComment() {
    // create a new comment
    final newComment = Comment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      postId: widget.post.id,
      userId: currentUser!.uid,
      userName: currentUser!.name,
      text: commentTextController.text,
      timestamp: DateTime.now()
    );

    // add comment using cubit
    if (commentTextController.text.isNotEmpty) {
      postCubit.addComment(widget.post.id, newComment);
    }
  }

  @override
  void dispose() {
    commentTextController.dispose();
    super.dispose();
  }

  // show options for deletion
  void showOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deletar postagem'),
        actions: [
          // cancel button
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),

          // delete button
          TextButton(
            onPressed: () {
              widget.onDeletePressed!();
              Navigator.pop(context);
            },
            child: const Text('Deletar'),
          ),
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppThemeCustom.white,
      child: Column(
        children: [
          // Top section: profile pic / name / menu button
Padding(
  padding: const EdgeInsets.all(12.0),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      // Esquerda: imagem + nome
      GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfilePage(
              uid: widget.post.userId,
            ),
          ),
        ),
        child: Row(
          children: [
            // profile pic
            postUser?.profileImageUrl != null
                ? CachedNetworkImage(
                    imageUrl: postUser!.profileImageUrl,
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.person),
                    imageBuilder: (context, imageProvider) => Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )
                : const Icon(Icons.person),

            const SizedBox(width: 10),

            // name
            Text(
              widget.post.userName,
              style: TextStyle(
                color: AppThemeCustom.black,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
                  ),
                ),

                // Actions Button
                Row(
                  children: [
                    if (isDownPost)
                      GestureDetector(
                        onTap: showOptions,
                        child: Icon(
                          Icons.delete,
                          color: AppThemeCustom.black,
                        ),
                      ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        // Ação do menu "mais opções"
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => const SizedBox(
                            height: 100,
                            child: Center(child: Text('Mais opções')),
                          ),
                        );
                      },
                      child: Icon(
                        Icons.more_vert,
                        color: AppThemeCustom.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // CAPTION
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20),
            child: Text(
              widget.post.text,
              style: TextStyle(
                color: AppThemeCustom.black,
                fontSize: 14,
              ),
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
          ),

          // image
          CachedNetworkImage(
            imageUrl: widget.post.imageUrl,
            height: 350,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) => const SizedBox(height: 350),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),

          // buttons -> like, comment, timestamp
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              children: [
                SizedBox(
                  width: 50,
                  child: Row(
                    children: [
                      // like button
                      GestureDetector(
                        onTap: toggleLikePost,
                        child: Icon(
                          widget.post.likes.contains(currentUser!.uid)
                            ? Icons.favorite
                            : Icons.favorite_border,
                          color: widget.post.likes.contains(currentUser!.uid)
                            ? AppThemeCustom.green500
                            : AppThemeCustom.black,
                        ),
                      ),

                      const SizedBox(width: 5),
                  
                      // like count
                      Text(widget.post.likes.length.toString(),
                      style: TextStyle(
                        color: AppThemeCustom.black,
                        fontSize: 12,
                      ),
                      ),
                    ],
                  ),
                ),

                // comment button
                GestureDetector(
                  onTap: openNewCommentBox,
                  child: Icon(Icons.comment),
                ),

                const SizedBox(width: 5),

                Text(
                  widget.post.comments.length.toString(),
                  style: TextStyle(
                    color: AppThemeCustom.black,
                    fontSize: 12,
                  ),
                ),

                const Spacer(),

                // timestamp
                Text(widget.post.timestamp.toString()),
              ],
            ),
            
          ),

          // COMMENT SECTION
          BlocBuilder<PostCubit, PostStates>(
            builder: (context, state) {
              // LOADED
              if (state is PostsLoaded) {
                // final individual post
                final post = state.posts
                  .firstWhere((post) => post.id == widget.post.id);

                  if (post.comments.isNotEmpty) {
                    // how many comments to show
                    int showCommentCount = post.comments.length;
                    
                    // comment section
                    return ListView.builder(
                      itemCount: showCommentCount,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        // get individual comment
                        final comment = post.comments[index];

                        // comment title UI
                        return CommentTitle(comment: comment);
                      },
                    );
                  }
              }

              // LOADING...
              if (state is PostsLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              // ERROR
              else if (state is PostsError) {
                return Center(child: Text(state.message));
              } else {
                return const SizedBox();
              }
            },
          )
        ],
      ),
    );
  }
}