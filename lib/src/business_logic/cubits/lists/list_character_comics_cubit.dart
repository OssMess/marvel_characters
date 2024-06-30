import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/list_models.dart';
import '../../../data/models.dart';
import '../../../data/repositories.dart';

class ListCharacterComicsCubit extends Cubit<ListCharacterComics> {
  final ComicRepository comicRepository = ComicRepository();

  ListCharacterComicsCubit(int characterId)
      : super(ListCharacterComics(characterId: characterId));

  /// Init data.
  /// if [callGet] is `true` proceed with query, else break.
  Future<void> initData({
    required bool callGet,
  }) async {
    if (!callGet) return;
    if (!state.isNull) return;
    if (state.isLoading) return;
    state.isLoading = true;
    await get(
      refresh: false,
    );
  }

  /// call get to retrieve data from backend.
  Future<void> get({
    required bool refresh,
  }) {
    return comicRepository.listCharacterComics(
      characterId: state.characterId,
      listCharacterComics: this,
      refresh: refresh,
    );
  }

  /// Get more data, uses pagination.
  Future<void> getMore() async {
    if (state.isNull) return;
    if (state.isLoading) return;
    state.isLoading = true;
    emit(state);
    await get(
      refresh: false,
    );
  }

  /// Refresh data.
  Future<void> refresh() async {
    if (state.isLoading) return;
    state.total = 0;
    state.offset = 0;
    state.totalPages = -1;
    state.currentPage = 0;
    state.hasError = false;
    state.isLoading = true;
    await get(
      refresh: true,
    );
  }

  /// Update list with query result, and notify listeners
  void update(
    Set<CharacterComic> result,
    int total,
    bool error,
    bool refresh,
  ) {
    if (error || refresh) {
      state.list.clear();
    }
    if (!error) {
      state.total = total;
      state.offset = state.offset + min(state.limit, result.length);
      state.totalPages = (total / state.limit).round() + 1;
      state.currentPage++;
      state.list.addAll(result);
    }
    state.isLoading = false;
    state.isNull = false;
    state.hasError = error;
    emit(state);
  }

  /// Reset list to its initial state.
  void reset() {
    state.isNull = true;
    state.isLoading = false;
    state.hasError = false;
    state.list.clear();
    state.totalPages = -1;
    state.currentPage = 0;
  }

  /// Clone the values of all attributs of [update] to `this` and refresh the UI.
  /// The aim here is to update to `this` and keep all widgets attached to `this` notifiable.
  void updateFrom(ListCharacterComics update) {
    state.list = update.list;
    state.isNull = update.isNull;
    state.isLoading = update.isLoading;
    state.totalPages = update.totalPages;
    state.currentPage = update.currentPage;
    state.hasError = update.hasError;
    emit(state);
  }

  ///For lazzy loading, Use [scrollNotification] to detect if the scroll has reached the end of the
  ///page, and if the list has more data, call `getMore`.
  bool onMaxScrollExtent(ScrollNotification scrollNotification) {
    if (!state.canGetMore) return true;
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
    if (!state.canGetMore) return true;
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
      if (state.isNull) return;
      if (state.isLoading) return;
      if (!state.canGetMore) return;
      if (controller.position.maxScrollExtent != controller.offset) return;
      getMore();
    });
  }
}
