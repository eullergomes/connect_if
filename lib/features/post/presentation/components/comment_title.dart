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
        title: const Text('Apagar comentário?'),
        actions: [
          // cancel button
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: AppThemeCustom.black),
            ),
          ),

          // delete button
          TextButton(
            onPressed: () {
              context
                .read<PostCubit>()
                .deleteComment(widget.comment.postId, widget.comment.id);
              Navigator.pop(context);
            },
            child: const Text(
              'Apagar',
              style: TextStyle(color: AppThemeCustom.black),
            ),
          ),
        ],
      )
    );
  }

  @override
Widget build(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 10, // Espaço entre os elementos
      children: [
        // Nome do usuário
        Text(
          widget.comment.userName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),

        // Texto do comentário (quebra automática)
        Flexible(
          child: Text(
            widget.comment.text,
            softWrap: true,
          ),
        ),

        // Botão de deletar (se for o autor)
        if (isDownPost)
          GestureDetector(
            onTap: showOptions,
            child: Icon(
              Icons.more_horiz,
              color: AppThemeCustom.gray400,
            ),
          ),
      ],
    ),
  );
}

}
