import 'package:hive/hive.dart';

import '../../model/models.dart';

class AuthStateChange {
  /// Hive box named `auth_state_change` used to store user session.
  static late Box _box;

  /// Current user session.
  static late UserAPISession _userSession;

  /// Initialises and opens `_box`, initiates initialisation of and returns a
  /// refrence to `_userSession` with last saved active session if it exists.
  static Future<UserAPISession> init() async {
    _box = await Hive.openBox('auth_state_change');
    if (_box.isEmpty) {
      // _box is empty, no saved session
      _userSession = UserAPISession.initUnauthenticated();
    } else {
      _userSession = UserAPISession.fromMap(
        Map<String, dynamic>.from(Map<String, dynamic>.from(_box.values.first)),
      );
    }
    return _userSession;
  }

  /// Save [userSession] to `_box` and `_userSession`.
  static Future<void> save(UserAPISession userSession) async {
    await clear();
    await _box.put(
      userSession.uid,
      userSession.toMap,
    );
    _userSession = userSession;
  }

  /// Clear Hive `_box` and reset `_userSession` to
  /// `userSession.initUnauthenticated()`
  static Future<UserAPISession> clear() async {
    await _box.clear();
    _userSession = UserAPISession.initUnauthenticated();
    return _userSession;
  }
}
