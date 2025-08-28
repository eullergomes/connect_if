import 'package:connect_if/features/services/auth/data/firebase_auth_repo.dart';
import 'package:connect_if/features/services/chat/chat_service.dart';
import 'package:connect_if/features/services/chat/presentation/components/user_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BlockedUsersPage extends StatelessWidget {
  BlockedUsersPage({super.key});

  // chat & auth service
  final ChatService chatService = ChatService();
  final firebaseAuthRepo = FirebaseAuthRepo();
  final FirebaseAuth _authService = FirebaseAuth.instance;

  // get current user
  User? getCurrentUser() {
    return _authService.currentUser;
  }

  // show confirm unblock box
  void _showUnblockBox(BuildContext context, String userId) {
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: const Text('Desbloquear usuário'),
        content: const Text('Você tem certeza que deseja desbloquear este usuário?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              chatService.unblockUser(userId);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Usuário desbloqueado!'),
                ),
              );
            },
            child: const Text('Desbloquear'),
          ),
        ],
      ),
    
    );
  }

  @override
  Widget build(BuildContext context) {
    // get current users id
    String userId = getCurrentUser()!.uid;

    // UI
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuários Bloqueados'),
        backgroundColor: Colors.transparent,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: chatService.getBlockedUsersStream(userId),
        builder: (context, snapshot) {
          // erros
          if (snapshot.hasError) {
            return const Center(
              child: Text('Erro ao carregar usuários bloqueados'),
            );
          }
          // loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final blockedUsers = snapshot.data! ?? [];

          // no users
          if (blockedUsers.isEmpty) {
            return const Center(
              child: Text('Nenhum usuário bloqueado'),
            );
          }

          // load complete
          return ListView.builder(
            itemCount: blockedUsers.length,
            itemBuilder: (context, index) {
              final user = blockedUsers[index];
              return UserTile(
                text: user['email'],
                onTap: () => _showUnblockBox(context, user['uid']),
              );
            },
          );

        },
      ),
    );
  }
}