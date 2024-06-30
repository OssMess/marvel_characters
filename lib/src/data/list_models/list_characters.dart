import '../list_models.dart';
import '../../mvc/controller/hives.dart';
import '../models.dart';
import '../repositories.dart';

class ListCharacters extends ListModelsPagination<Character> {
  /// The repository used to communicate with the backend.
  final CharacterRepository characterRepository = CharacterRepository();

  /// The hive used to bookmark characters
  final HiveCharacters hiveCharacters;

  ListCharacters({super.limit, required this.hiveCharacters});
}
