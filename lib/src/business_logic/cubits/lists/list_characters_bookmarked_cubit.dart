import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

import '../../cubits.dart';

part 'list_characters_bookmarked_state.dart';

class ListCharactersBookmarkedCubit
    extends Cubit<ListCharactersBookmarkedState> {
  ListCharactersBookmarkedCubit(
      ListCharactersBookmarkedState listCharactersBookmarkedState)
      : super(listCharactersBookmarkedState);

  Future<void> init() async {
    await state.init();
    emit(state);
  }

  /// Bookmark [character] to `_box`.
  Future<void> bookmark(CharacterCubit character) async {
    if (character.bookmark()) {
      state.add(character.state);
    } else {
      state.remove(character.state);
    }
    emit(state);
  }

  /// Clear Hive `_box`
  Future<void> clear() async {
    await state.clear();
  }
}
