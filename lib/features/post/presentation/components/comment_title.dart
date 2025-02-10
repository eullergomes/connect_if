import 'package:connect_if/features/auth/domain/entities/app_user.dart';
import 'package:connect_if/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:connect_if/features/post/domain/entities/comment.dart';
import 'package:connect_if/features/post/presentation/cubits/post_cubit.dart';
import 'package:connect_if/ui/themes/class_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentTitle extends StatefulWidget {
  final Comment comment;

  const CommentTitle({super.key, required this.comment});

  @override
  State<CommentTitle> createState() => _CommentTitleState();
}

class _CommentTitleState extends State<CommentTitle> {
  // current user
  AppUser? currentUser;
  bool isDownPost = false;

  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }

  void getCurrentUser() {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
    isDownPost = (widget.comment.userId == currentUser!.uid);
  }

  // show options for deletion
  void showOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deletar postagem?'),
        actions: [
          // cancel button
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),

          // delete button
          TextButton(
            onPressed: () {
              context
                .read<PostCubit>()
                .deleteComment(widget.comment.postId, widget.comment.id);
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          // name
          Text(
            widget.comment.userName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),

          const SizedBox(width: 10),

          // coment text
          Text(widget.comment.text),

          const Spacer(),

          // delete button
          if (isDownPost)
            GestureDetector(
              onTap: showOptions,
              child: Icon(
                Icons.more_horiz,
                color: AppThemeCustom.green400,
              ),
            )
        ],
      ),
    );
  }
}
