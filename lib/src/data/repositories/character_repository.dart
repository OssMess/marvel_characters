import '../../business_logic/cubits.dart';
import '../data_providers.dart';

class CharacterRepository {
  final CharacterProvider provider = CharacterProvider();

  Future<void> list({
    required ListCharactersBookmarkedState listCharactersBookmarkedState,
    required ListCharactersCubit listCharacters,
    required bool refresh,
  }) async {
    Map<String, dynamic> result = await provider.list(
      offset: listCharacters.state.offset,
      limit: listCharacters.state.limit,
    );
    List<CharacterState> list = List.from(result['data']['results'])
        .map((e) =>
            CharacterState.fromJson(e, listCharactersBookmarkedState.list))
        .toList();
    listCharacters.update(
      list.toSet(),
      result['data']['total'],
      false,
      refresh,
    );
  }

  Future<void> bookmarkCharacter(CharacterState character) async {
    if (character.isBookmarked) {
      deleteBookmark(character);
    } else {
      addBookmark(character);
    }
  }

  void addBookmark(
    CharacterState character,
  ) {
    character.isBookmarked = true;
  }

  void deleteBookmark(CharacterState character) {
    character.isBookmarked = false;
  }
}
