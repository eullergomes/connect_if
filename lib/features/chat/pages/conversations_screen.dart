import 'package:connect_if/features/chat/components/conversation_list.dart';
import 'package:connect_if/features/chat/models/chat_users_model.dart';
import 'package:connect_if/ui/themes/class_themes.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  List<ChatUsers> chatUsers = [
    ChatUsers(name: "Jane Russel", messageText: "Awesome Setup", imageURL: "assets/images/userImage1.jpg", time: "Now"),
    ChatUsers(name: "Glady's Murphy", messageText: "That's Great", imageURL: "assets/images/userImage2.jpg", time: "Yesterday"),
    ChatUsers(name: "Jorge Henry", messageText: "Hey where are you?", imageURL: "assets/images/userImage3.jpg", time: "31 Mar"),
    ChatUsers(name: "Philip Fox", messageText: "Busy! Call me in 20 mins", imageURL: "assets/images/userImage4.jpg", time: "28 Mar"),
    ChatUsers(name: "Debra Hawkins", messageText: "Thank you, It's awesome", imageURL: "assets/images/userImage5.jpg", time: "23 Mar"),
    ChatUsers(name: "Jacob Pena", messageText: "Will update you in evening", imageURL: "assets/images/userImage6.jpg", time: "17 Mar"),
    ChatUsers(name: "Andrey Jones", messageText: "Can you please share the file?", imageURL: "assets/images/userImage7.jpg", time: "24 Feb"),
    ChatUsers(name: "John Wick", messageText: "How are you?", imageURL: "assets/images/userImage8.jpg", time: "18 Feb"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SafeArea(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 16, left: 10, right: 10),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Pesquisar...",
                          hintStyle: TextStyle(color: Colors.grey.shade600),
                          prefixIcon: Icon(Icons.search, color: Colors.grey.shade600, size: 20),
                          filled: true,
                          fillColor: AppThemeCustom.green100,
                          contentPadding: EdgeInsets.all(8),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Colors.grey.shade100),
                          ),
                        ),
                      ),
                    ),
                    ListView.builder(
                      itemCount: chatUsers.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.only(top: 16),
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return ConversationList(
                          name: chatUsers[index].name,
                          messageText: chatUsers[index].messageText,
                          imageUrl: chatUsers[index].imageURL,
                          time: chatUsers[index].time,
                          isMessageRead: (index == 0 || index == 3) ? true : false,
                        );
                      },
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}