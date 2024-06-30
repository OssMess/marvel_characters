import '../../mvc/model/list_models.dart';
import '../data_providers.dart';
import '../models.dart';

class ComicRepository {
  final ComicProvider provider = ComicProvider();

  Future<void> list({
    required ListComics listComics,
    required bool refresh,
  }) async {
    Map<String, dynamic> result = await provider.listComics(
      offset: listComics.offset,
      limit: listComics.limit,
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
    required ListCharacterComics listCharacterComics,
    required bool refresh,
  }) async {
    Map<String, dynamic> result = await provider.listCharacterComics(
      characterId: characterId,
      offset: listCharacterComics.offset,
      limit: listCharacterComics.limit,
    );

    List<CharacterComic> list = List.from(result['data']['results'])
        .map((e) => CharacterComic.fromJson(e))
        .toList();
    listCharacterComics.update(
      list.toSet(),
      result['data']['total'],
      false,
      refresh,
    );
  }
}
