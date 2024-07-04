class FirestorePath {
  static String userSessions() => 'userSession/';
  static String userSession({required String uid}) => 'userSession/$uid';
}
