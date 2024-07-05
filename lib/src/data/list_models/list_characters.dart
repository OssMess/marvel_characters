import '../../business_logic/cubits.dart';
import '../list_models.dart';
import '../repositories.dart';

class ListCharacters extends ListModelsPagination<CharacterState> {
  /// The repository used to communicate with the backend.
  final CharacterRepository characterRepository = CharacterRepository();

  // FIXME add bookmarked characters
  /// The hive used to bookmark characters
  // final HiveCharacters hiveCharacters;

  ListCharacters({super.limit});
}
