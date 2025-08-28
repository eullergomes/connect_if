/*
PROFILE STATS
- posts
- followers
- following
*/

import 'package:connect_if/ui/themes/class_themes.dart';
import 'package:flutter/material.dart';

class ProfileStats extends StatelessWidget {
  final int postCount;
  final int followersCount;
  final int followingCount;
  final VoidCallback? onPostsTap;
  final VoidCallback? onFollowersTap;
  final VoidCallback? onFollowingTap;

  const ProfileStats({
    super.key,
    required this.postCount,
    required this.followersCount,
    required this.followingCount,
    this.onPostsTap,
    this.onFollowersTap,
    this.onFollowingTap,
  });

  @override
  Widget build(BuildContext context) {
    final textStyleForCount = TextStyle(
      fontSize: 20,
      color: AppThemeCustom.black,
    );
    final textStyleForText = TextStyle(color: AppThemeCustom.black);

    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Postagens
          GestureDetector(
            onTap: onPostsTap,
            child: SizedBox(
              width: 100,
              child: Column(
                children: [
                  Text(postCount.toString(), style: textStyleForCount),
                  Text("Postagens", style: textStyleForText),
                ],
              ),
            ),
          ),

          // Seguindo
          GestureDetector(
            onTap: onFollowingTap,
            child: SizedBox(
              width: 100,
              child: Column(
                children: [
                  Text(followingCount.toString(), style: textStyleForCount),
                  Text("Seguindo", style: textStyleForText),
                ],
              ),
            ),
          ),

          // Seguidores
          GestureDetector(
            onTap: onFollowersTap,
            child: SizedBox(
              width: 100,
              child: Column(
                children: [
                  Text(followersCount.toString(), style: textStyleForCount),
                  Text("Seguidores", style: textStyleForText),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
