import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models.dart';
import '../../../data/repositories.dart';
import '../../../mvc/controller/hives.dart';

class CharacterCubit extends Cubit<Character> {
  CharacterRepository repository = CharacterRepository();

  CharacterCubit(
    Map<dynamic, dynamic> json,
    List<Character> bookmarkedCharacters,
  ) : super(Character.fromJson(json, bookmarkedCharacters));

  Future<void> bookmark(HiveCharacters hiveCharacters) async {
    await repository.bookmarkCharacter(
      hiveCharacters: hiveCharacters,
      character: state,
    );
    emit(state);
  }
}
