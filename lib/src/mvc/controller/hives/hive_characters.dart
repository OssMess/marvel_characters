import 'dart:convert';
import 'package:hive/hive.dart';

import '../../model/models.dart';

class HiveCharacters {
  static late Box _box;

  static List<Character> list = [];

  static const String _boxName = 'characters';

  static Future<void> init() async {
    _box = await Hive.openBox(_boxName);
    if (_box.isNotEmpty) {
      list = List.from(_box.values)
          .map(
            (e) => Character.fromJson(
              e,
            ),
          )
          .toList();
    }
  }

  /// Save [json] to `_box`.
  static Future<void> save(Character character) async {
    list.add(character);
    await _box.put(
      character.id,
      character.toJson(),
    );
  }

  static Future<void> delete(Character searchHistory) async {
    list.remove(searchHistory);
    await _box.delete(searchHistory.id);
  }

  /// Clear Hive `_box`
  static Future<void> clear() async {
    await _box.clear();
    list.clear();
  }
}
