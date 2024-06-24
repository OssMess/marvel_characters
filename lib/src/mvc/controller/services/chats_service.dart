import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/firestore_path.dart';

class ChatsService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<int> hasUnreadMessages(String uid) {
    return _firestore
        .collection(FirestorePath.chats())
        .where('unread.$uid', isGreaterThan: 0)
        .count()
        .get()
        .then((value) => value.count ?? 0);
  }
}
