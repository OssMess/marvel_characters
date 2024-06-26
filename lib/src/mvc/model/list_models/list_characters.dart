import '../list_models.dart';
import '../models.dart';

class ListCharacters extends SetApiPaginationClasses<Character> {
  ListCharacters({super.limit = 10});

  @override
  Future<void> get({
    required int page,
    required bool refresh,
    required void Function(
      Set<Character> list,
      int total,
      bool hasError,
      bool refresh,
    ) update,
  }) {
    throw UnimplementedError();
  }
}
