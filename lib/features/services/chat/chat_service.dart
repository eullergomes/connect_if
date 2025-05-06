import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_if/features/services/chat/domain/entities/message.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  // get instance of firestore & auth
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // get user stream
  /*

  List<Nao><String,dynamic> =

  [
  {
    'email': test@gmail.com
    'id': ..
  },
  {
    'email': euller@gmail.com
    'id': ..
  }
  ]
  */

  // get all user stream
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection('users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        // go through each individual user
        final user = doc.data();

        // return user
        return user;
      }).toList();
    });
  }

  // get all users except blocked users
  Stream<List<Map<String, dynamic>>> getUsersStreamExcludingBlocked() {
    final currentUser = _auth.currentUser;

    return _firestore
      .collection('users')
      .doc(currentUser!.uid)
      .collection('BlockedUsers')
      .snapshots()
      .asyncMap((snapshot) async {
        // get list of blocked users ids
        final blockedUserIds = snapshot.docs.map((doc) => doc.id).toList();

        // get all users
        final usersSnapshot = await _firestore.collection('users').get();
        
        // return as stream list, excluding current user and blocked users
        return usersSnapshot.docs
          .where((doc) => 
            doc.data()['email'] != currentUser!.email &&
            !blockedUserIds.contains(doc.id)
          )
          .map((doc) => doc.data())
          .toList();
      });
  }

  // send message
  Future<void> sendMessage(String receiverId, message) async {
    // get current user info
    final String currentUserId = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    // create a new message
    Message newMessage = Message(
      senderId: currentUserId,
      senderEmail: currentUserEmail,
      receiverId: receiverId,
      message: message,
      timestamp: timestamp,
    );

    // const chat room Id for the two users (sorted to ensure uniqueness)
    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatRoomId = ids.join('_');

    // add new message to database
    await _firestore.collection('chat_rooms').doc(chatRoomId).collection('messages').add(newMessage.toMap());
  }

  // get messages
  Stream<QuerySnapshot> getMessages(String userId, otherUserId) {
    // construct a chatroom Id for the two users
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join('_');

    return _firestore.collection('chat_rooms').doc(chatRoomId).collection('messages').orderBy('timestamp', descending: false).snapshots();
  }

  // report user
  Future<void> reportUser(String messageId, String userId) async {
    final currentUser = _auth.currentUser;
    final report = {
      'reporterId': currentUser!.uid,
      'messageId': messageId,
      'messageOwnerId': userId,
      'timestamp': FieldValue.serverTimestamp(),
    };

    await _firestore.collection('reports').add(report);
  }

  // block user
  Future<void> blockUser(String userId) async {
    final currentUser = _auth.currentUser;
    await _firestore
      .collection('users')
      .doc(currentUser!.uid)
      .collection('BlockedUsers')
      .doc(userId)
      .set({});
    // notifyListeners();
  }

  // unblock user
  Future<void> unblockUser(String blockedUserId) async {
    final currentUser = _auth.currentUser;

    await _firestore
      .collection('users')
      .doc(currentUser!.uid)
      .collection('BlockedUsers')
      .doc(blockedUserId)
      .delete();
  }

  // get blocked users stream
  Stream<List<Map<String, dynamic>>> getBlockedUsersStream(String userId) {
    return _firestore
      .collection('user')
      .doc(userId)
      .collection('BlockedUsers')
      .snapshots()
      .asyncMap((snapshot) async {
        // get list of blocked users ids
        final blockedUserIds = snapshot.docs.map((doc) => doc.id).toList();

        final userDocs = await Future.wait(
          blockedUserIds
            .map((id) => _firestore.collection('users').doc(id).get())
        );

        // return as a list
        return userDocs.map((doc) => doc.data as Map<String, dynamic>).toList();
      });
  }
}