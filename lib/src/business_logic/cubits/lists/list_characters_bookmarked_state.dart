part of 'list_characters_bookmarked_cubit.dart';

// ignore: must_be_immutable
class ListCharactersBookmarkedState extends Equatable {
  late Box box;

  final List<CharacterState> list = [];

  final String boxName = 'characters';

  ListCharactersBookmarkedState();

  Future<void> init() async {
    box = await Hive.openBox(boxName);
    if (box.isNotEmpty) {
      list.addAll(
        List.from(box.values).map(
          (e) => CharacterState.fromJson(
            e,
            list,
          ),
        ),
      );
    }
  }

  /// Save [character] to `_box`.
  Future<void> add(CharacterState character) async {
    list.add(character);
    await box.put(
      character.id,
      character.toJson(),
    );
  }

  Future<void> remove(CharacterState searchHistory) async {
    list.remove(searchHistory);
    await box.delete(searchHistory.id);
  }

  /// Clear Hive `_box`
  Future<void> clear() async {
    await box.clear();
    list.clear();
  }

  @override
  List<Object> get props => throw UnimplementedError();
}
