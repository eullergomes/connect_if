import 'package:connect_if/features/services/auth/data/firebase_auth_repo.dart';
import 'package:connect_if/features/services/chat/chat_service.dart';
import 'package:connect_if/features/services/chat/presentation/components/user_tile.dart';
import 'package:connect_if/features/services/chat/presentation/cubits/pages/chat_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  // chat & auth service
  final ChatService _chatService = ChatService();
  final firebaseAuthRepo = FirebaseAuthRepo();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  ChatScreen({super.key});

  // get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversas'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: _buildUserList(),
    );
  }

  // build a list of users except the current logged in user
  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getFollowingUsersStream(),
      builder: (context, snapshot) {
        // error
        if (snapshot.hasError) {
          return const Text('Error');
        }

        // loading...
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // return List view
        return ListView(
          children: snapshot.data!
              .map<Widget>((userData) => _buildUserListItem(userData, context))
              .toList(),
        );
      },
    );
  }

  // build individual user title for user
  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    if (userData['email'] != getCurrentUser()!.email) {
      final profileImageUrl = userData['profileImageUrl'] ?? '';

      return UserTile(
        text: userData['name'],
        profileImageUrl: profileImageUrl,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverName: userData['name'],
                receiverProfileImageUrl: profileImageUrl,
                receiverId: userData['uid'],
              ),
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }
}
