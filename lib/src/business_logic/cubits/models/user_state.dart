part of 'user_cubit.dart';

@immutable
sealed class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

final class UserLoading extends UserState {
  const UserLoading();
}

final class UserUnAuthenticated extends UserState {
  final Exception? error;
  const UserUnAuthenticated([this.error]);

  @override
  List<Object?> get props => [error];
}

final class UserLoaded extends UserState {
  /// user authentication sate
  final AuthState authState;

  /// user Id
  final String uid;
  final String? token;
  final String email;
  final DateTime updatedAt;
  final DateTime createdAt;

  const UserLoaded({
    required this.authState,
    required this.uid,
    required this.token,
    required this.email,
    required this.updatedAt,
    required this.createdAt,
  });

  ///Use to build an instance of `UserSession` from [user] and [doc]
  factory UserLoaded.fromFirebaseUserDoc({
    required User user,
    required DocumentSnapshot<Map<String, dynamic>> doc,
  }) {
    Map<String, dynamic> json = doc.data()!;
    return UserLoaded(
      authState: AuthState.authenticated,
      uid: user.uid,
      email: user.email ?? json['email'],
      token: json['token'],
      createdAt: DateTimeUtils.getDateTimefromTimestamp(json['createdAt'])!,
      updatedAt: DateTimeUtils.getDateTimefromTimestamp(json['updatedAt'])!,
    );
  }

  ///Use to build an instance of `UserSession` from [user] and also using [token].
  factory UserLoaded.fromUser({
    required User user,
    required String? token,
  }) {
    return UserLoaded(
      authState: AuthState.authenticated,
      uid: user.uid,
      token: token,
      email: user.email!,
      updatedAt: DateTime.now(),
      createdAt: DateTime.now(),
    );
  }

  ///Call after user signup to build a instance of user `profile`, that will be
  ///pushed later by calling `toInitMap` method.
  factory UserLoaded.fromUserCredential({
    required UserCredential userCredential,
    required String? token,
  }) {
    return UserLoaded(
      authState: AuthState.authenticated,
      uid: userCredential.user!.uid,
      token: token,
      email: userCredential.user!.email!,
      updatedAt: DateTime.now(),
      createdAt: DateTime.now(),
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
        //initial params in userData document
        'updateKey': 0,
        'updatedAt': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
      };

  Future<void> signOut() async {
    await FirebaseAuthenticationRepository.signOut();
  }
}
