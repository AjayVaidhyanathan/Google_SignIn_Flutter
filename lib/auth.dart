import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_signin/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();
final _firestore = Firestore.instance;
String userID;
String userDisplayName;
String userPicture;
String userEmail;
bool isEmailVerified;

class AuthService {
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount _googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication _googleSignInAuthentication =
          await _googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: _googleSignInAuthentication.idToken,
        accessToken: _googleSignInAuthentication.accessToken,
      );

      final AuthResult result =
          await _firebaseAuth.signInWithCredential(credential);
      if (result != null) {
        FirebaseUser user = await _firebaseAuth.currentUser();

        userID = user.uid;
        userDisplayName = user.displayName;
        userPicture = user.photoUrl;
        userEmail = user.email;

        if (user.isEmailVerified == true) {
          isEmailVerified = true;
        } else {
          isEmailVerified = false;
        }
        updateTask(user);
        
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      }
    } catch (e) {
      print(e.message);
    }
  }

  void signOut() {
    _googleSignIn.signOut();
  }

  Future<void> updateTask(FirebaseUser user) async {
    return await _firestore.collection('Users').document(user.uid).setData({
      'uid': user.uid,
      'email': user.email,
      'photoURL': user.photoUrl,
      'displayName': user.displayName,
      'lastSeen': DateTime.now()
    }, merge: true);
  }

  String getUserdisplayname() {
    return userDisplayName;
  }

  String getUserPicture() {
    return userPicture;
  }

  String getUserEmail() {
    return userEmail;
  }

  String isUserApproved() {
    if (isEmailVerified == false) {
      return 'Your email verification is pending';
    } else {
      return 'Your email is verified';
    }
  }
}
