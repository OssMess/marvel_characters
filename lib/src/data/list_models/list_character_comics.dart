import '../list_models.dart';
import '../models.dart';
import '../repositories.dart';

class ListCharacterComics extends ListModelsPagination<CharacterComic> {
  final int characterId;

  /// The repository used to communicate with the backend.
  final ComicRepository comicRepository = ComicRepository();

  ListCharacterComics({super.limit, required this.characterId});
}
