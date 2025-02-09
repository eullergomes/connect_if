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
          return ProfileUser(
            uid: uid,
            email: userData['email'],
            name: userData['name'],
            bio: userData['bio'] ?? '',
            profileImageUrl: userData['profileImageUrl'].toString(),
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
}