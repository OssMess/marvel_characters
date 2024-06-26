import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../tools.dart';
import '../../controller/services.dart';
import '../enums.dart';

class UserSession with ChangeNotifier {
  /// user authentication sate
  AuthState authState;
  Exception? error;

  /// user Id
  String uid;
  String? token;
  String? email;
  bool? emailVerified;
  String? displayName;
  CachedNetworkImageProvider? photo;
  String? photoUrl;
  DateTime? updatedAt;
  DateTime? createdAt;

  UserSession({
    required this.authState,
    required this.error,
    required this.uid,
    required this.token,
    required this.email,
    required this.emailVerified,
    required this.displayName,
    required this.photo,
    required this.photoUrl,
    required this.updatedAt,
    required this.createdAt,
  });

  ///Use as build an inital instance of `UserSession` while waiting for response from
  ///stream `AuthenticationService.userStream`
  factory UserSession.init(AuthState authState) => UserSession(
        authState: authState,
        error: null,
        uid: '',
        token: null,
        email: null,
        emailVerified: null,
        displayName: null,
        photo: null,
        photoUrl: null,
        updatedAt: null,
        createdAt: null,
      );

  ///Call and use to catch [error] when listening to stream `AuthenticationService.userStream`
  factory UserSession.error(dynamic error) => UserSession(
        authState: AuthState.awaiting,
        error: error,
        uid: '',
        token: null,
        email: null,
        emailVerified: null,
        displayName: null,
        photo: null,
        photoUrl: null,
        updatedAt: null,
        createdAt: null,
      );

  ///Call after user signup to build a instance of user `profile`, that will be
  ///pushed later by calling `toInitMap` method.
  factory UserSession.fromUserCredential(
    UserCredential userCredential,
    String? token,
  ) =>
      UserSession(
        authState: AuthState.authenticated,
        error: null,
        uid: userCredential.user!.uid,
        token: token,
        email: userCredential.user!.email,
        emailVerified: userCredential.user!.emailVerified,
        displayName: userCredential.user!.displayName,
        photo: userCredential.user!.photoURL != null
            ? CachedNetworkImageProvider(userCredential.user!.photoURL!)
            : null,
        photoUrl: userCredential.user!.photoURL,
        updatedAt: DateTime.now(),
        createdAt: DateTime.now(),
      );

  ///Use to build an instance of `UserSession` from [user] and also using [token].
  factory UserSession.fromUser(
    User user,
    String? token,
  ) =>
      UserSession(
        authState: AuthState.authenticated,
        error: null,
        uid: user.uid,
        token: token,
        email: user.email,
        emailVerified: user.emailVerified,
        displayName: user.displayName,
        photo: user.photoURL != null
            ? CachedNetworkImageProvider(user.photoURL!)
            : null,
        photoUrl: user.photoURL,
        updatedAt: DateTime.now(),
        createdAt: DateTime.now(),
      );

  ///Use to build an instance of `UserSession` from [user] and [doc]
  factory UserSession.fromFirebaseUserDoc({
    required User user,
    required DocumentSnapshot<Map<String, dynamic>> doc,
  }) {
    Map<String, dynamic> json = doc.data()!;
    return UserSession(
      authState: AuthState.authenticated,
      error: null,
      uid: user.uid,
      email: user.email ?? json['email'],
      emailVerified: user.emailVerified,
      displayName: user.displayName ?? json['displayName'],
      token: json['token'],
      photoUrl: json['photoUrl'],
      photo: json['photoUrl'] != null
          ? CachedNetworkImageProvider(json['photoUrl'])
          : null,
      createdAt: DateTimeUtils.getDateTimefromTimestamp(json['createdAt']),
      updatedAt: DateTimeUtils.getDateTimefromTimestamp(json['updatedAt']),
    );
  }

  ///Used only after user signup to create profile based on user credentials.
  ///`UserData.fromUserCredential` constructor is used to init UserData model
  ///after signup, then we use `toInitMap` to build a `document` in collection
  ///`userData` that needs to be pushed along side additional somedata
  Map<String, dynamic> get toInitMap => {
        'uid': uid,
        'email': email,
        'token': token,
        'displayName': displayName,
        'photoUrl': photoUrl,
        //initial params in userData document
        'updateKey': 0,
        'updatedAt': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
      };

  bool get isReady => authState != AuthState.awaiting;
  bool get isAwaiting => authState == AuthState.awaiting;
  bool get isAuthenticated => authState == AuthState.authenticated;
  bool get isUnauthenticated => authState == AuthState.unauthenticated;

  void updateException(Exception? exception) {
    error = exception;
    notifyListeners();
  }

  void copyFromUserSession(UserSession update) {
    authState = update.authState;
    error = update.error;
    uid = update.uid;
    token = update.token;
    email = update.email;
    emailVerified = update.emailVerified;
    displayName = update.displayName;
    photo = update.photo;
    photoUrl = update.photoUrl;
    updatedAt = update.updatedAt;
    createdAt = update.createdAt;
    notifyListeners();
  }

  Future<void> listenAuthStateChanges() async {
    FirebaseAuth.instance.authStateChanges().listen(
      (user) async {
        if (user == null) {
          copyFromUserSession(
            UserSession.init(AuthState.unauthenticated),
          );
        } else {
          try {
            UserSession userdata =
                await AuthenticationService.userFromFirebaseUser(user);
            copyFromUserSession(userdata);
          } on Exception catch (e) {
            updateException(e);
          }
        }
      },
    );
  }

  Future<void> signOut() async {
    await AuthenticationService.signOut(this);
  }

  Future<void> refreshisEmailVerified() async {
    if (FirebaseAuth.instance.currentUser == null) return;
    await FirebaseAuth.instance.currentUser!.reload();
    emailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (emailVerified == true) {
      notifyListeners();
    }
  }
}
