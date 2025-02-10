import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_if/features/auth/domain/entities/app_user.dart';
import 'package:connect_if/features/auth/domain/repository/auth_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthRepo  implements AuthRepo {

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  @override
  Future<AppUser?> loginWithEmailPassword(String email, String password) async {
    try {
      // attempt to sign in
      UserCredential userCredential = await firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);

      // fetch user document from firestore
      DocumentSnapshot userDoc = await firebaseFirestore
        .collection("users")
        .doc(userCredential.user!.uid)
        .get();

      // create user
      AppUser user = AppUser(
        uid: userCredential.user!.uid,
        email: email,
        name: userDoc["name"],
      );

      return user;
    }

    catch (e) {
      throw Exception("Login failed: $e");
    }
  }

  @override
  Future<AppUser?> registerWithEmailPassword(
    String name, String email, String password) async {
      try {
        // attempt to sign up
        UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

        // create user
        AppUser user = AppUser(
          uid: userCredential.user!.uid,
          email: email,
          name: name,
        );

        // save user in firestore
        await firebaseFirestore
          .collection("users")
          .doc(user.uid)
          .set(user.toJson());

        return user;
      }

      catch (e) {
        throw Exception("Falha ao realizar login: $e");
      }
    }

  @override
  Future<void> logout() async{
    await firebaseAuth.signOut();
  }

  @override
  Future<AppUser?> getCurrentUser() async {
    // get current logged in user from firebase
    final firebaseUser = firebaseAuth.currentUser;
    
    // no user logged in
    if (firebaseUser == null) {
      return null;
    }

    // fetch user document from firestore
    DocumentSnapshot userDoc = await firebaseFirestore
      .collection("users")
      .doc(firebaseUser.uid)
      .get();

    // check if user doc exits
    if (!userDoc.exists) {
      return null;
    }

    // user exits
    return AppUser(
      uid: firebaseUser.uid,
      email: firebaseUser.email!,
      name: userDoc["name"],
    );
  }
}