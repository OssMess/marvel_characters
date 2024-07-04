import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../models.dart';
import 'firestore_path.dart';
import '../../mvc/controller/services.dart';

class FirebaseAuthenticationRepository {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Stream<User?> onChangeAuthState() {
    return FirebaseAuth.instance.authStateChanges();
  }

  ///build a UserFirebaseSession object for current [user]
  static Future<UserSession> userFromFirebaseUser(
    User user, [
    int retry = 5,
  ]) async {
    try {
      late UserSession userdata;
      if (retry <= 0) {
        throw FirebaseAuthException(
          code: 'time-out',
          message:
              'Connection time out! Your user document is still being written',
        );
      }
      userdata = await _firestore
          .doc(FirestorePath.userSession(uid: user.uid))
          .get(const GetOptions(source: Source.server))
          .then((doc) async {
        if (doc.data() == null || !doc.exists) {
          throw FirebaseAuthException(
            code: 'time-out-being-created',
            message:
                'Connection time out! Your user document is still being created',
          );
        }
        if (doc.data()!['uid'] != user.uid) {
          throw FirebaseAuthException(code: 'user-not-match');
        }
        if (doc.metadata.hasPendingWrites) {
          throw FirebaseAuthException(
            code: 'time-out-has-pending-writes',
            message:
                'Connection time out! Your user document is still being written',
          );
        }
        if (!doc.exists || doc.data() == null) {
          throw FirebaseAuthException(
            code: 'time-out-being-created',
            message:
                'Connection time out! Your user document is still being created',
          );
        }
        if (doc.data()!['uid'] != user.uid) {
          throw FirebaseAuthException(code: 'user-not-match');
        }
        return UserSession.fromFirebaseUserDoc(
          user: user,
          doc: doc,
        );
      });
      return userdata;
    } on FirebaseAuthException catch (e) {
      if (retry > 0 &&
          ['time-out-being-created', 'time-out-has-pending-writes']
              .contains(e.code)) {
        log('error:${e.code}');
        await Future.delayed(const Duration(milliseconds: 500));
        return userFromFirebaseUser(user, retry - 1);
      } else {
        rethrow;
      }
    } catch (e) {
      if (retry == 0) {
        rethrow;
      } else {
        await Future.delayed(const Duration(milliseconds: 500));
        return userFromFirebaseUser(user, retry - 1);
      }
    }
  }

  /// Update user email.
  static Future<void> updateUserEmail(String email) async {
    var firebaseUser = _auth.currentUser;
    if (firebaseUser == null) return;
    await firebaseUser.verifyBeforeUpdateEmail(email);
  }

  /// Update user displayName.
  static Future<void> updateDisplayName(String displayName) async {
    var firebaseUser = _auth.currentUser;
    if (firebaseUser == null) return;
    await firebaseUser.updateDisplayName(displayName);
  }

  /// On user signs in with credential, first update AuthState to `awaiting` to
  /// show the splash screen while user document is being created/updated, and
  /// retrieved from Firestore database.
  static Future<void> onSignInWithCredential(
      UserCredential userCredential) async {
    if (userCredential.user == null) throw Exception('User is not signed in');
    await onSignInUser(userCredential.user!);
  }

  /// On user signs in, first update AuthState to `awaiting` to
  /// show the splash screen while user document is being created/updated, and
  /// retrieved from Firestore database.
  static Future<void> onSignInUser(User user) async {
    String? token = await _messaging.getToken();
    try {
      await UserSessionRepository.updateToken(
        user.uid,
        token,
      );
    } catch (e) {
      await UserSessionRepository.create(
        UserSession.fromUser(
          user: user,
          token: token,
        ),
      );
    }
  }

  /// Send a verification email.
  static Future<void> sendEmailVerification() async {
    await FirebaseAuth.instance.currentUser?.sendEmailVerification();
  }

  /// Tries to create a new user account with the given [email] address and [password].
  static Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (userCredential.user != null) {
      FirebaseAuthenticationRepository.onSignInWithCredential(userCredential);
    }
  }

  /// Attempts to sign in a user with the given [email] address and [password].
  static Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (userCredential.user != null) {
      FirebaseAuthenticationRepository.onSignInWithCredential(userCredential);
    }
  }

  /// Sends a password reset email to the given [email] address.
  static Future<void> sendPasswordResetEmail({
    required String email,
  }) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  ///Signs out the current user.
  static Future<void> signOut(UserSession user) async {
    await FirebaseFirestore.instance.terminate();
    await FirebaseFirestore.instance.clearPersistence();
    await _auth.signOut();
  }
}
