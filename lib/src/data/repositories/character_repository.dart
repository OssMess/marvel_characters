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
      offset: listCharacters.state is ListCharactersLoaded
          ? (listCharacters.state as ListCharactersLoaded).offset
          : 0,
      limit: listCharacters.state is ListCharactersLoaded
          ? (listCharacters.state as ListCharactersLoaded).limit
          : 10,
    );
    List<CharacterCubit> list = List.from(result['data']['results'])
        .map(
          (e) => CharacterCubit.fromJson(
            e,
            listCharactersBookmarkedState.list
                .where((element) =>
                    (element.state as CharacterLoaded).id == e['id'])
                .isNotEmpty,
          ),
        )
        .toList();
    listCharacters.update(
      list.toSet(),
      result['data']['total'],
      refresh,
    );
  }

  //FIXME bookmark character
  // Future<void> bookmarkCharacter(CharacterState character) async {
  //   assert(character is CharacterLoaded, 'character must be Character');
  //   if ((character as CharacterLoaded).isBookmarked) {
  //     deleteBookmark(character);
  //   } else {
  //     addBookmark(character);
  //   }
  // }

  // bool addBookmark(CharacterState character) {
  //   assert(character is CharacterLoaded, 'character must be Character');
  //   return true;
  // }

  // bool deleteBookmark(CharacterState character) {
  //   assert(character is CharacterLoaded, 'character must be Character');
  //   return false;
  // }
}
