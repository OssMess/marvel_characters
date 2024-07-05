import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../../business_logic/cubits.dart';

class HiveCharacters with ChangeNotifier {
  late Box _box;

  List<CharacterState> list = [];

  final String _boxName = 'characters';

  Future<void> init() async {
    _box = await Hive.openBox(_boxName);
    if (_box.isNotEmpty) {
      list = List.from(_box.values)
          .map(
            (e) => CharacterState.fromJson(
              e,
              list,
            ),
          )
          .toList();
    }
  }

  /// Save [json] to `_box`.
  Future<void> save(CharacterState character) async {
    list.add(character);
    notifyListeners();
    await _box.put(
      character.id,
      character.toJson(),
    );
  }

  Future<void> delete(CharacterState searchHistory) async {
    list.remove(searchHistory);
    notifyListeners();
    await _box.delete(searchHistory.id);
  }

  /// Clear Hive `_box`
  Future<void> clear() async {
    await _box.clear();
    list.clear();
  }
}
