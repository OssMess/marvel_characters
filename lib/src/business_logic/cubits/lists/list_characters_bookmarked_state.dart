part of 'list_characters_bookmarked_cubit.dart';

// ignore: must_be_immutable
class ListCharactersBookmarkedState extends Equatable {
  late Box box;

  final List<CharacterCubit> list = [];

  final String boxName = 'characters';

  ListCharactersBookmarkedState();

  Future<void> init() async {
    box = await Hive.openBox(boxName);
    if (box.isNotEmpty) {
      list.addAll(List.from(box.values).map(
        (e) => CharacterCubit.fromJson(
          e,
          true,
        ),
      ));
    }
  }

  /// Save [character] to `_box`.
  Future<void> add(CharacterCubit character) async {
    assert(character.state is CharacterLoaded, 'character must be Character');
    list.add(character);
    await box.put(
      (character.state as CharacterLoaded).id,
      (character.state as CharacterLoaded).toJson(),
    );
  }

  Future<void> remove(CharacterCubit character) async {
    assert(character.state is CharacterLoaded, 'character must be Character');
    list.removeWhere((element) =>
        (character.state as CharacterLoaded).id ==
        (element.state as CharacterLoaded).id);
    await box.delete((character.state as CharacterLoaded).id);
  }

  /// Clear Hive `_box`
  Future<void> clear() async {
    await box.clear();
    list.clear();
  }

  @override
  List<Object> get props => throw UnimplementedError();
}
