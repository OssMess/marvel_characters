import 'package:cloud_firestore/cloud_firestore.dart';

import '../../business_logic/cubits.dart';
import 'firestore_path.dart';

class UserRepository {
  // static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static Future<void> updateToken(String uid, String? token) async {
    await _firestore.doc(FirestorePath.userSession(uid: uid)).update({
      'token': token,
    });
  }

  static Future<void> update(String uid, Map<String, dynamic> data) async {
    await _firestore.doc(FirestorePath.userSession(uid: uid)).update(data);
  }

  static Future<void> create(UserSession userSession) async {
    await _firestore.doc(FirestorePath.userSession(uid: userSession.uid)).set(
          userSession.toInitMap,
        );
  }
}
