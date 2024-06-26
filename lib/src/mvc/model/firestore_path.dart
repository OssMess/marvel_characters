class FirestorePath {
  static String usersPresences() => 'usersPresence/';
  static String usersPresence({required String uid}) => 'usersPresence/$uid/';

  static String userSessions() => 'userSession/';
  static String userSession({required String uid}) => 'userSession/$uid';
}
