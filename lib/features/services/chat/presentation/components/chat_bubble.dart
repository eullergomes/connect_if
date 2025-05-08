import 'package:connect_if/features/services/chat/chat_service.dart';
import 'package:connect_if/ui/themes/class_themes.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  final String messageId;
  final String userId;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
    required this.messageId,
    required this.userId,
  });

  // show options
  void _showOptions(BuildContext context, String messageId, String userId) {
    showModalBottomSheet(
      context: context, 
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.flag),
                title: const Text('Reportar'),
                onTap: () {
                  Navigator.pop(context);
                  _reportMessage(context, messageId, userId);
                },
              ),

              // block user button
              ListTile(
                leading: const Icon(Icons.block),
                title: const Text('Bloquear'),
                onTap: () {
                  Navigator.pop(context);
                  blockUser(context, userId);
                },
              ),
              
              // cancel button
              ListTile(
                leading: const Icon(Icons.cancel),
                title: const Text('Cancelar'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          )
        );
      }
    );
  }

  // report message
  void _reportMessage(BuildContext context, String messageId, String userId) {
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: const Text('Reportar mensagem'),
        content: const Text('Você tem certeza que deseja reportar esta mensagem?'),
        actions: [
          // cancel button
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),

          // report button
          TextButton(
            onPressed: () {
              ChatService().reportUser(messageId, userId);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Mensagem reportada com sucesso!')));
            },
            child: const Text('Reportar'),
          )
        ],
      ),
    );
  }

  // block user
  void blockUser(BuildContext context, String userId) {
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: const Text('Bloquear usuário'),
        content: const Text('Você tem certeza que deseja bloquear este usuário?'),
        actions: [
          // cancel button
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),

          // block button
          TextButton(
            onPressed: () {
              // perform block
              ChatService().blockUser(userId);
              // dimiss dialog
              Navigator.pop(context);
              // dismiss page
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Usuário bloqueado com sucesso!')));
            },
            child: const Text('Bloquear'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        if (!isCurrentUser) {
          // show options
          _showOptions(context, messageId, userId);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: isCurrentUser ? AppThemeCustom.green500 : AppThemeCustom.gray400,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(12),
        margin: EdgeInsets.symmetric(vertical: 2.5, horizontal: 25),
        child: Text(
          message,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}