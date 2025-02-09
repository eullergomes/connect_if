import 'package:connect_if/ui/themes/class_themes.dart';
import 'package:flutter/material.dart';

class MyDrawerTitle extends StatelessWidget {
  final String title;
  final IconData icon;
  final void Function()? onTap;
  
  const MyDrawerTitle({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,  
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(color: AppThemeCustom.gray800),
      ),
      leading: Icon(
        icon,
        color: AppThemeCustom.gray800,
      ),
      onTap: onTap,
    );
  }
}