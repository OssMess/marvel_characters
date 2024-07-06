import '../../business_logic/cubits.dart';
import '../data_providers.dart';

class CharacterRepository {
  final CharacterProvider provider = CharacterProvider();

  Future<void> list({
    required ListCharactersBookmarkedCubit listCharactersBookmarkedCubit,
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
            listCharactersBookmarkedCubit.state
                    is! ListCharactersBookmarkedLoaded
                ? false
                : ((listCharactersBookmarkedCubit.state
                        as ListCharactersBookmarkedLoaded)
                    .set
                    .where((element) =>
                        (element.state as CharacterLoaded).id == e['id'])
                    .isNotEmpty),
          ),
        )
        .toList();
    listCharacters.update(
      list.toSet(),
      result['data']['total'],
      refresh,
    );
  }
}
