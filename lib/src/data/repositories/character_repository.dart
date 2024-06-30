import '../../mvc/controller/hives.dart';
import '../data_providers.dart';
import '../list_models.dart';
import '../models.dart';

class CharacterRepository {
  final CharacterProvider provider = CharacterProvider();

  Future<void> list({
    required List<Character> bookmarkedCharacters,
    required ListCharacters listCharacters,
    required bool refresh,
  }) async {
    Map<String, dynamic> result = await provider.list(
      offset: listCharacters.offset,
      limit: listCharacters.limit,
    );
    List<Character> list = List.from(result['data']['results'])
        .map((e) => Character.fromJson(e, bookmarkedCharacters))
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
    required Character character,
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
    required Character character,
  }) async {
    character.isBookmarked = true;
    await hiveCharacters.save(character);
  }

  Future<void> deleteBookmark({
    required HiveCharacters hiveCharacters,
    required Character character,
  }) async {
    character.isBookmarked = false;
    await hiveCharacters.delete(character);
  }
}
