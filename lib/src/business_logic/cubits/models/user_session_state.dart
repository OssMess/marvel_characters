part of 'user_session_cubit.dart';

@immutable
sealed class UserSessionState {
  final UserSession userSession;

  const UserSessionState({required this.userSession});
}

final class UserSessionLoading extends UserSessionState {
  UserSessionLoading()
      : super(userSession: UserSession.init(AuthState.awaiting));
}

final class UserSessionUnauthenticated extends UserSessionState {
  UserSessionUnauthenticated()
      : super(userSession: UserSession.init(AuthState.unauthenticated));
}

final class UserSessionAuthenticated extends UserSessionState {
  const UserSessionAuthenticated({required super.userSession});

  factory UserSessionAuthenticated.fromFirebaseUserDoc({
    required User user,
    required DocumentSnapshot<Map<String, dynamic>> doc,
  }) =>
      UserSessionAuthenticated(
        userSession: UserSession.fromFirebaseUserDoc(user: user, doc: doc),
      );

  factory UserSessionAuthenticated.fromUser({
    required User user,
    required String? token,
  }) =>
      UserSessionAuthenticated(
        userSession: UserSession.fromUser(user: user, token: token),
      );

  factory UserSessionAuthenticated.fromUserCredential({
    required UserCredential userCredential,
    required String? token,
  }) =>
      UserSessionAuthenticated(
        userSession: UserSession.fromUserCredential(
          userCredential: userCredential,
          token: token,
        ),
      );
}
