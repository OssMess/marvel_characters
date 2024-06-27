import '../../controller/hives.dart';
import '../../controller/services.dart';
import '../list_models.dart';
import '../models.dart';

class ListCharacters extends SetApiPaginationClasses<Character> {
  final HiveCharacters hiveCharacters;
  ListCharacters({
    super.limit = 10,
    required this.hiveCharacters,
  });

  @override
  Future<void> get({
    required bool refresh,
  }) {
    return APICharactersService().list(
      bookmarkedCharacters: hiveCharacters.list,
      listCharacters: this,
      refresh: refresh,
    );
  }
}
