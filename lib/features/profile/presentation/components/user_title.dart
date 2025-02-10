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
      title: Text(user.name),
      subtitle: Text(user.email),
      subtitleTextStyle: TextStyle(
        color: AppThemeCustom.black,
      ),
      leading: Icon(
        Icons.account_circle,
        color: AppThemeCustom.black,
      ),
      trailing: Icon(
        Icons.arrow_forward,
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
}