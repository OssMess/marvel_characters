import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models.dart';
import '../../../data/repositories.dart';

part 'list_character_comics_state.dart';

class ListCharacterComicsCubit extends Cubit<ListCharacterComicsState> {
  final int characterId;
  final ComicRepository comicRepository = ComicRepository();

  ListCharacterComicsCubit(this.characterId)
      : super(ListCharacterComicsInitial());

  /// Init data.
  /// if [callGet] is `true` proceed with query, else break.
  Future<void> initData({
    required bool callGet,
  }) async {
    assert(
      state is ListCharacterComicsInitial,
      'state must be ListCharacterComicInitial',
    );
    if (!callGet) return;
    emit(ListCharacterComicsLoading());
    await get(
      refresh: false,
    );
  }

  /// call get to retrieve data from backend.
  Future<void> get({
    required bool refresh,
  }) async {
    try {
      await comicRepository.listCharacterComics(
        characterId: characterId,
        listCharacterComics: this,
        refresh: refresh,
      );
    } on BackendException catch (e) {
      emit(ListCharacterComicsError(e));
    } catch (e) {
      emit(
        const ListCharacterComicsError(
          BackendException(
            code: 'unknown_error',
            statusCode: 0,
          ),
        ),
      );
    }
  }

  /// Get more data, uses pagination.
  Future<void> getMore() async {
    assert(
      state is ListCharacterComicsLoaded,
      'state must be ListCharacterComicInitial',
    );
    if ((state as ListCharacterComicsLoaded).isLoading) return;
    var loadedState = (state as ListCharacterComicsLoaded);
    emit(
      ListCharacterComicsLoaded(
        currentPage: loadedState.currentPage,
        totalPages: loadedState.totalPages,
        set: loadedState.set,
        offset: loadedState.offset,
        total: loadedState.total,
        isLoading: true,
        limit: 10,
      ),
    );
    await get(refresh: false);
  }

  /// Refresh data.
  Future<void> refresh() async {
    if (state is ListCharacterComicsLoading) return;
    emit(ListCharacterComicsLoading());
    await get(
      refresh: true,
    );
  }

  /// Update list with query result, and notify listeners
  void update(
    Set<CharacterComic> result,
    int total,
    bool refresh,
  ) {
    if (state is! ListCharacterComicsLoaded || refresh) {
      emit(
        ListCharacterComicsLoaded(
          currentPage: 1,
          totalPages: (total / 10).round() + 1,
          isLoading: false,
          set: result,
          offset: min(10, result.length),
          total: total,
          limit: 10,
        ),
      );
      return;
    }
    assert(state is ListCharacterComicsLoaded,
        'state must be ListCharacterComicLoaded');
    var loadedState = (state as ListCharacterComicsLoaded);
    emit(
      ListCharacterComicsLoaded(
        currentPage: loadedState.currentPage + 1,
        totalPages: (total / loadedState.limit).round() + 1,
        set: {...loadedState.set, ...result},
        offset: loadedState.offset + min(loadedState.limit, result.length),
        total: total,
        isLoading: false,
        limit: 10,
      ),
    );
  }

  /// Reset list to its initial state.
  void reset() {
    emit(ListCharacterComicsInitial());
  }

  ///For lazzy loading, Use [scrollNotification] to detect if the scroll has reached the end of the
  ///page, and if the list has more data, call `getMore`.
  bool onMaxScrollExtent(ScrollNotification scrollNotification) {
    if (state is! ListCharacterComicsLoaded) return true;
    if (!(state as ListCharacterComicsLoaded).canGetMore) return true;
    if (scrollNotification.metrics.pixels !=
        scrollNotification.metrics.maxScrollExtent) {
      return true;
    }
    getMore();
    return true;
  }

  ///For lazzy loading, Use [scrollNotification] to detect if the scroll is
  ///[extentAfter] away from the end of the page, and if the list has more data,
  /// call `getMore`.
  bool onExtentAfter(
    ScrollNotification scrollNotification,
    double extentAfter,
  ) {
    if (state is! ListCharacterComicsLoaded) return true;
    if (!(state as ListCharacterComicsLoaded).canGetMore) return true;
    if (scrollNotification.metrics.extentAfter < extentAfter) {
      return true;
    }
    getMore();
    return true;
  }

  /// Add listener to [controller] to listen for pagination and load more results
  /// if there are any.
  void addControllerListener(ScrollController controller) {
    controller.addListener(() {
      if (state is! ListCharacterComicsLoaded) return;
      if (!(state as ListCharacterComicsLoaded).canGetMore) return;
      if (controller.position.maxScrollExtent != controller.offset) return;
      getMore();
    });
  }
}
