import 'package:connect_if/features/profile/domain/entities/profile_user.dart';
import 'package:connect_if/features/profile/presentation/pages/profile_page.dart';
import 'package:connect_if/ui/themes/class_themes.dart';
import 'package:flutter/material.dart';

class UserTitle extends StatelessWidget {
  final ProfileUser user;

  const UserTitle({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: _buildAvatar(),
      title: Text(
        user.name,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppThemeCustom.black,
        ),
      ),
      subtitle: Text(
        user.email,
        style: TextStyle(color: AppThemeCustom.black),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: AppThemeCustom.black,
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePage(uid: user.uid),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    final hasImage = user.profileImageUrl.isNotEmpty &&
        !user.profileImageUrl.toLowerCase().contains("default");

    return CircleAvatar(
      radius: 24,
      backgroundColor: AppThemeCustom.gray200,
      backgroundImage: hasImage
          ? NetworkImage(user.profileImageUrl)
          : null,
      child: !hasImage
          ? Icon(
              Icons.account_circle,
              size: 32,
              color: AppThemeCustom.black,
            )
          : null,
    );
  }
}
