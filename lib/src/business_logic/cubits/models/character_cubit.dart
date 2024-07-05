import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:equatable/equatable.dart';

import '../../cubits.dart';
import '../../../data/models.dart';
import '../../../data/repositories.dart';

part 'character_state.dart';

class CharacterCubit extends Cubit<CharacterState> {
  CharacterRepository repository = CharacterRepository();

  CharacterCubit(CharacterState characterState) : super(characterState);

  factory CharacterCubit.fromJson(
    Map<dynamic, dynamic> json,
    bool isBookmarked,
  ) =>
      CharacterCubit(
        Character.fromJson(
          json,
          isBookmarked,
        ),
      );

  bool bookmark() {
    repository.bookmarkCharacter(state);
    emit(state);
    return (state as Character).isBookmarked;
  }

  Future<void> init(ScrollController scrollController) async {
    (state as Character)
        .listCharacterComicsCubit
        .addControllerListener(scrollController);
    await (state as Character).listCharacterComicsCubit.initData(callGet: true);
  }
}
