import '../../business_logic/cubits.dart';
import '../data_providers.dart';
import '../models.dart';

class ComicRepository {
  final ComicProvider provider = ComicProvider();

  Future<void> list({
    required ListComicsCubit listComics,
    required bool refresh,
  }) async {
    Map<String, dynamic> result = await provider.listComics(
      offset: listComics.state.offset,
      limit: listComics.state.limit,
    );
    List<Comic> list = List.from(result['data']['results'])
        .map((e) => Comic.fromJson(e))
        .toList();
    listComics.update(
      list.toSet(),
      result['data']['total'],
      false,
      refresh,
    );
  }

  Future<void> listCharacterComics({
    required int characterId,
    required ListCharacterComicsCubit listCharacterComics,
    required bool refresh,
  }) async {
    Map<String, dynamic> result = await provider.listCharacterComics(
      characterId: characterId,
      offset: listCharacterComics.state is ListCharacterComicsLoaded
          ? (listCharacterComics.state as ListCharacterComicsLoaded).offset
          : 0,
      limit: listCharacterComics.state is ListCharacterComicsLoaded
          ? (listCharacterComics.state as ListCharacterComicsLoaded).limit
          : 10,
    );
    List<CharacterComic> list = List.from(result['data']['results'])
        .map((e) => CharacterComic.fromJson(e))
        .toList();
    listCharacterComics.update(
      list.toSet(),
      result['data']['total'],
      refresh,
    );
  }
}
