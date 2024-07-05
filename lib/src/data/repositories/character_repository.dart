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
        .map(
          (e) => Character.fromJson(
            e,
            listCharactersBookmarkedState.list
                .where((element) => (element.state as Character).id == e['id'])
                .isNotEmpty,
          ),
        )
        .toList();
    listCharacters.update(
      list.toSet(),
      result['data']['total'],
      false,
      refresh,
    );
  }

  Future<void> bookmarkCharacter(CharacterState character) async {
    assert(character is Character, 'character must be Character');
    if ((character as Character).isBookmarked) {
      deleteBookmark(character);
    } else {
      addBookmark(character);
    }
  }

  void addBookmark(
    CharacterState character,
  ) {
    assert(character is Character, 'character must be Character');
    (character as Character).isBookmarked = true;
  }

  void deleteBookmark(CharacterState character) {
    assert(character is Character, 'character must be Character');
    (character as Character).isBookmarked = false;
  }
}
