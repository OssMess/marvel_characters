import '../../business_logic/cubits.dart';
import '../../mvc/controller/hives.dart';
import '../data_providers.dart';

class CharacterRepository {
  final CharacterProvider provider = CharacterProvider();

  Future<void> list({
    required List<CharacterState> bookmarkedCharacters,
    required ListCharactersCubit listCharacters,
    required bool refresh,
  }) async {
    Map<String, dynamic> result = await provider.list(
      offset: listCharacters.state.offset,
      limit: listCharacters.state.limit,
    );
    List<CharacterState> list = List.from(result['data']['results'])
        .map((e) => CharacterState.fromJson(e, bookmarkedCharacters))
        .toList();
    listCharacters.update(
      list.toSet(),
      result['data']['total'],
      false,
      refresh,
    );
  }

  Future<void> bookmarkCharacter({
    required HiveCharacters hiveCharacters,
    required CharacterState character,
  }) async {
    if (character.isBookmarked) {
      await deleteBookmark(
        hiveCharacters: hiveCharacters,
        character: character,
      );
    } else {
      await addBookmark(
        hiveCharacters: hiveCharacters,
        character: character,
      );
    }
  }

  Future<void> addBookmark({
    required HiveCharacters hiveCharacters,
    required CharacterState character,
  }) async {
    character.isBookmarked = true;
    await hiveCharacters.save(character);
  }

  Future<void> deleteBookmark({
    required HiveCharacters hiveCharacters,
    required CharacterState character,
  }) async {
    character.isBookmarked = false;
    await hiveCharacters.delete(character);
  }
}
