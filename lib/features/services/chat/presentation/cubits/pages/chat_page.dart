import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_if/features/services/auth/data/firebase_auth_repo.dart';
import 'package:connect_if/features/services/auth/presentation/components/my_text_field.dart';
import 'package:connect_if/features/services/chat/chat_service.dart';
import 'package:connect_if/features/services/chat/presentation/components/chat_bubble.dart';
import 'package:connect_if/ui/themes/class_themes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverName;
  final String receiverProfileImageUrl;
  final String receiverId;

  const ChatPage({
    super.key,
    required this.receiverName,
    required this.receiverProfileImageUrl,
    required this.receiverId,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // text controller
  final TextEditingController _messageController = TextEditingController();

  // chat & auth services
  final ChatService _chatService = ChatService();
  final firebaseAuthRepo = FirebaseAuthRepo();
  final FirebaseAuth _authService = FirebaseAuth.instance;

  // for textfield focus
  FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // add listener to focus node
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        // cause a delay so that the keyboard has time to show up
        // then amount of remaining space will be calculated
        // the scroll down
        Future.delayed(
          const Duration(milliseconds: 500),
          () => scrollDown(),
        );
      }
    });

    // wait a bit for listview to be build, then scroll to button
    Future.delayed(
      const Duration(milliseconds: 500),
      () => scrollDown(),
    );

  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  // scroll controller
  final ScrollController _scrollController = ScrollController();
  void scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  // get current user
  User? getCurrentUser() {
    return _authService.currentUser;
  }

  // send message
  void sendMessage() async {
    // if there is something inside the text field
    if (_messageController.text.isNotEmpty) {
      // send message
      await _chatService.sendMessage(widget.receiverId, _messageController.text);

      _messageController.clear();
    }

    scrollDown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Row(
          children: [
        widget.receiverProfileImageUrl.isNotEmpty
          ? CircleAvatar(
          backgroundImage: NetworkImage(widget.receiverProfileImageUrl),
            )
          : const CircleAvatar(
          child: Icon(Icons.person),
            ),
        const SizedBox(width: 10),
        Text(widget.receiverName),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          _buildUserInput(),
        ],
      ),
    );
  }

  // build message list
  Widget _buildMessageList() {
    String senderId = getCurrentUser()!.uid;

    return StreamBuilder(
        stream: _chatService.getMessages(widget.receiverId, senderId),
        builder: (context, snapshot) {
          // erros
          if (snapshot.hasError) {
            return Text('Erro');
          }

          // loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // return list view
          return ListView(
            controller: _scrollController,
            children: snapshot.data!.docs
                .map((doc) => _buildMessageItem(doc))
                .toList(),
          );
        });
  }

  // build message item
  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // is current user
    bool isCurrentUser = data['senderId'] == getCurrentUser()!.uid;

    // align message to the right if sender is current user, otherwise left
    var alignment = 
      isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment:
          isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          ChatBubble(
            message: data['message'],
            isCurrentUser: isCurrentUser,
            messageId: doc.id,
            userId: data['senderId'],
          ),
        ],
      ),
    );
  }

  // build message input
  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, // Center the row horizontally
        children: [
          // textfield should take up most of the space
          Expanded(
            child: MyTextField(
              controller: _messageController,
              hintText: 'Digite uma mensagem',
              obscureText: false,
              focusNode: myFocusNode,
            ),
          ),

          // send button
          Container(
            decoration: BoxDecoration(
              color: AppThemeCustom.green500,
              shape: BoxShape.circle,
            ),
            margin: const EdgeInsets.only(left: 10.0), // Add spacing between textfield and button
            child: IconButton(
              onPressed: sendMessage,
              icon: Icon(Icons.arrow_upward, color: Colors.white),
              tooltip: 'Enviar mensagem',
            ),
          )
        ],
      ),
    );
  }
}
