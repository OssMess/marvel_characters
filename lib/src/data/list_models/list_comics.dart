import '../list_models.dart';
import '../models.dart';
import '../repositories.dart';

class ListComics extends ListModelsPagination<Comic> {
  /// The repository used to communicate with the backend.
  final ComicRepository comicRepository = ComicRepository();

  ListComics({super.limit});
}
