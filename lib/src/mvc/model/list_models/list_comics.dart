import '../../controller/services.dart';
import '../list_models.dart';
import '../models.dart';

class ListComics extends SetApiPaginationClasses<Comic> {
  ListComics({super.limit = 10});

  @override
  Future<void> get({required bool refresh}) {
    return APIComicsService().list(listComics: this, refresh: refresh);
  }
}
