import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_if/features/profile/domain/entities/profile_user.dart';
import 'package:connect_if/features/profile/domain/repos/profile_repo.dart';

class FirebaseProfileRepo implements ProfileRepo{
  final FirebaseFirestore firestoreFirestore = FirebaseFirestore.instance;
  
  @override
  Future<ProfileUser?> fetchUserProfile(String uid) async {
    try {
      // get user document from firestore
      final userDoc = await firestoreFirestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        final userData = userDoc.data();

        if (userData != null) {
          // fetch follwers & following
          final followers = List<String>.from(userData['followers'] ?? []);
          final following = List<String>.from(userData['following'] ?? []);

          return ProfileUser(
            uid: uid,
            email: userData['email'],
            name: userData['name'],
            bio: userData['bio'] ?? '',
            profileImageUrl: userData['profileImageUrl'].toString(),
            followers: followers,
            following: following,
          );
        }
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> updaterProfile(ProfileUser updateProfile) async {
    try {
      // convert updated profile to json to store in firestore
      await firestoreFirestore
        .collection('users')
        .doc(updateProfile.uid)
        .update({
          'bio': updateProfile.bio,
          'profileImageUrl': updateProfile.profileImageUrl,
        });
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> toggleFollow(String currentUid, String targetUid) async {
    try {
      final currentUserDoc = 
        await firestoreFirestore.collection('users').doc(currentUid).get();
      
      final targetUserDoc = 
        await firestoreFirestore.collection('users').doc(targetUid).get();

      if (currentUserDoc.exists && targetUserDoc.exists) {
        final currentUserData = currentUserDoc.data();
        final targetUserData = targetUserDoc.data();

        if (currentUserData != null && targetUserData != null) {
          final List<String> currentFollowing = 
            List<String>.from(currentUserData['following'] ?? []);

          // check if the current user is already following the target user
          if (currentFollowing.contains(targetUid)) {
            // unfollow
            await firestoreFirestore.collection('users').doc(currentUid).update({
              'following': FieldValue.arrayRemove([targetUid]),
            });

            await firestoreFirestore.collection('users').doc(targetUid).update({
              'followers': FieldValue.arrayRemove([currentUid]),
            });
          } else {
            // follow
            await firestoreFirestore.collection('users').doc(currentUid).update({
              'following': FieldValue.arrayUnion([targetUid]),
            });

            await firestoreFirestore.collection('users').doc(targetUid).update({
              'followers': FieldValue.arrayRemove([targetUid]),
            });
          }
        }
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}