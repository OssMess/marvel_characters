import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

import '../../../data/_models.dart';
import '../../_cubits.dart';

part 'list_characters_bookmarked_state.dart';

class ListCharactersBookmarkedCubit
    extends Cubit<ListCharactersBookmarkedState> {
  final String boxName = 'characters';

  ListCharactersBookmarkedCubit(
      ListCharactersBookmarkedState listCharactersBookmarkedState)
      : super(ListCharactersBookmarkedInitial());

  Future<void> init() async {
    emit(ListCharactersBookmarkedLoading());
    Box box = await Hive.openBox(boxName);
    Set<CharacterCubit> set = {};
    if (box.isNotEmpty) {
      set.addAll(
        List.from(box.values).map(
          (e) => CharacterCubit.fromJson(
            e,
            true,
          ),
        ),
      );
    }
    emit(ListCharactersBookmarkedLoaded(set: set));
  }

  /// Bookmark [character] to `_box`.
  Future<void> bookmark(
      CharacterCubit character, ListCharactersCubit listCharactersCubit) async {
    assert(state is ListCharactersBookmarkedLoaded,
        'state must be ListCharactersBookmarkedLoaded');
    assert(character.state is CharacterLoaded, 'state must be Character');
    Set<CharacterCubit> updatedSet = {};
    updatedSet.addAll((state as ListCharactersBookmarkedLoaded).set);
    if (character.bookmark()) {
      if (updatedSet.add(character)) {
        emit(
          ListCharactersBookmarkedLoaded(
            set: updatedSet,
          ),
        );
      }
      Box box = await Hive.openBox(boxName);
      await box.put(
        (character.state as CharacterLoaded).id,
        (character.state as CharacterLoaded).toJson(),
      );
    } else {
      updatedSet.removeWhere(
        (element) =>
            (element.state as CharacterLoaded).id ==
            (character.state as CharacterLoaded).id,
      );
      emit(
        ListCharactersBookmarkedLoaded(set: updatedSet),
      );
      try {
        CharacterCubit characterCubit =
            (listCharactersCubit.state as ListCharactersLoaded).set.firstWhere(
                  (element) =>
                      (element.state as CharacterLoaded).id ==
                      (character as CharacterLoaded).id,
                );
        characterCubit.bookmark(true);
        // ignore: empty_catches
      } catch (e) {}
      Box box = await Hive.openBox(boxName);
      await box.delete((character.state as CharacterLoaded).id);
    }
  }

  /// Clear Hive `_box`
  Future<void> clear() async {
    Box box = await Hive.openBox(boxName);
    await box.clear();
    // emit(const ListCharactersBookmarkedLoaded());
  }
}
