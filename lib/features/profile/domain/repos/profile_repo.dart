import 'package:connect_if/features/profile/domain/entities/profile_user.dart';

abstract class ProfileRepo {
  Future<ProfileUser?> fetchUserProfile(String uid);
  Future<void> updaterProfile(ProfileUser updateProfile);
  Future<void> toggleFollow(String currentUid, String targetUid);
}