import 'package:flutter/material.dart';
import 'package:connect_if/ui/themes/class_themes.dart';

class UserTitle extends StatelessWidget {
  final String text;
  final String? profileImageUrl;
  final void Function()? onTap;

  const UserTitle({
    super.key,
    required this.text,
    required this.onTap,
    this.profileImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            // profile image or default icon
            profileImageUrl != null && profileImageUrl!.isNotEmpty
                ? CircleAvatar(
                    backgroundImage: NetworkImage(profileImageUrl!),
                    radius: 20,
                  )
                : const Icon(Icons.person, size: 40),

            const SizedBox(width: 20),

            // user name
            Text(
              text,
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
