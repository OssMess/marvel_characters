import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories.dart';
import '../../../mvc/controller/hives.dart';
import '../../cubits.dart';

class CharacterCubit extends Cubit<CharacterState> {
  CharacterRepository repository = CharacterRepository();

  CharacterCubit(CharacterState characterState) : super(characterState);

  factory CharacterCubit.fromJson(
    Map<dynamic, dynamic> json,
    List<CharacterState> bookmarkedCharacters,
  ) =>
      CharacterCubit(CharacterState.fromJson(json, bookmarkedCharacters));

  Future<void> bookmark(HiveCharacters hiveCharacters) async {
    await repository.bookmarkCharacter(
      hiveCharacters: hiveCharacters,
      character: state,
    );
    emit(state);
  }

  Future<void> init(ScrollController scrollController) async {
    state.listCharacterComicsCubit.addControllerListener(scrollController);
    await state.listCharacterComicsCubit.initData(callGet: true);
  }
}
