import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/firestore_path.dart';
import '../../model/models.dart';

class UserFirebaseSessionService {
  // static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static Future<void> updateToken(String uid, String? token) async {
    await _firestore.doc(FirestorePath.userFirebaseSession(uid: uid)).update({
      'token': token,
    });
  }

  static Future<void> update(String uid, Map<String, dynamic> data) async {
    await _firestore
        .doc(FirestorePath.userFirebaseSession(uid: uid))
        .update(data);
  }

  static Future<void> create(UserFirebaseSession user) async {
    await _firestore.doc(FirestorePath.userFirebaseSession(uid: user.uid)).set(
          user.toInitMap,
        );
  }
}
