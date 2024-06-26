import '../../controller/services.dart';
import '../list_models.dart';
import '../models.dart';

class ListCharacters extends SetApiPaginationClasses<Character> {
  ListCharacters({super.limit = 10});

  @override
  Future<void> get({
    required bool refresh,
  }) {
    return APICharactersService().list(listCharacters: this, refresh: refresh);
  }
}
