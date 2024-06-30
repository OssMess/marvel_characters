import '../models.dart';
import '../../mvc/controller/hives.dart';
import '../../mvc/model/list_models.dart';
import '../repositories.dart';

class ListCharacters extends SetApiPaginationClasses<Character> {
  final HiveCharacters hiveCharacters;
  final CharacterRepository characterRepository = CharacterRepository();

  ListCharacters({
    super.limit = 10,
    required this.hiveCharacters,
  });

  @override
  Future<void> get({
    required bool refresh,
  }) {
    return characterRepository.list(
      bookmarkedCharacters: hiveCharacters.list,
      listCharacters: this,
      refresh: refresh,
    );
  }
}
