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
  final void Function()? onTap;

  const ProfileStats({
    super.key,
    required this.postCount,
    required this.followersCount,
    required this.followingCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // text style for count
    var textStyleForCount = TextStyle(
      fontSize: 20,
      color: AppThemeCustom.black
    );

    // text style for text
    var textStyleForText = TextStyle(
      color: AppThemeCustom.black
    );
    return GestureDetector(
      onTap: onTap,
      child: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        // posts
        SizedBox(
          width: 100,
          child: Column(
          children: [
            Text(postCount.toString(), style: textStyleForCount,),
            Text("Postagens", style: textStyleForText,),
          ],
          ),
        ),
      
        // followers
        SizedBox(
          width: 100,
          child: Column(
          children: [
            Text(followersCount.toString(), style: textStyleForCount,),
            Text("Seguindo", style: textStyleForText,),
          ],
          ),
        ),
      
        // seguidores
        SizedBox(
          width: 100,
          child: Column(
          children: [
            Text(followingCount.toString(), style: textStyleForCount,),
            Text("Seguidores", style: textStyleForText,),
          ],
          ),
        )
        ],
      ),
      ),
    );
  }
}