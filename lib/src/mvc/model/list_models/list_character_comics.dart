import '../../../data/models.dart';
import '../../controller/services.dart';
import '../list_models.dart';

class ListCharacterComics extends SetApiPaginationClasses<CharacterComic> {
  final int characterId;
  ListCharacterComics({
    super.limit = 5,
    required this.characterId,
  });

  @override
  Future<void> get({required bool refresh}) {
    return APIComicsService().listCharacterComics(
      characterId: characterId,
      listCharacterComics: this,
      refresh: refresh,
    );
  }
}
