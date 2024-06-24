class FirestorePath {
  static String usersPresences() => 'usersPresence/';
  static String usersPresence({required String uid}) => 'usersPresence/$uid/';

  static String userFirebaseSessions() => 'userSession/';
  static String userFirebaseSession({required String uid}) =>
      'userSession/$uid';

  static String notifications({required String uid}) =>
      'userSession/$uid/notifications/';
  static String notification({required String uid, required String id}) =>
      'userSession/$uid/notifications/$id';

  static String chats() => 'chats/';
  static String chat({required String uid}) => 'chats/$uid';

  static String messages({required String chatId}) => 'chats/$chatId/messages/';
  static String message({required String chatId, required String messageId}) =>
      'chats/$chatId/messages/$messageId';
}
