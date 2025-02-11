/*
  To use this widget, you need:
  - a function ( e.g. toggleFollow()),
  - isFollowing ( e.g false -> then we will show follow button instead of unfollow (button),
*/

import 'package:connect_if/ui/themes/class_themes.dart';
import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final void Function()? onPressed;
  final bool isFollowing;
  
  const FollowButton({
    super.key,
    required this.onPressed,
    required this.isFollowing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: MaterialButton(
          onPressed: onPressed,
          padding: const EdgeInsets.all(25),
          color: isFollowing ? AppThemeCustom.gray400 : AppThemeCustom.green500,
          child: Text(
            isFollowing ? "Deixar de seguir" : "Seguir",
            style: TextStyle(
              color: AppThemeCustom.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}