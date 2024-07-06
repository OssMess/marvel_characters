import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models.dart';
import '../../../data/repositories.dart';
import '../../cubits.dart';

part 'list_characters_state.dart';

class ListCharactersCubit extends Cubit<ListCharactersState> {
  final CharacterRepository characterRepository = CharacterRepository();
  final ListCharactersBookmarkedState listCharactersBookmarkedState;

  ListCharactersCubit(this.listCharactersBookmarkedState)
      : super(ListCharactersInitial());

  /// Init data.
  /// if [callGet] is `true` proceed with query, else break.
  Future<void> initData({
    required bool callGet,
  }) async {
    assert(
      state is ListCharactersInitial,
      'state must be ListCharactersInitial',
    );
    if (!callGet) return;
    emit(ListCharactersLoading());
    await get(
      refresh: false,
    );
  }

  /// call get to retrieve data from backend.
  Future<void> get({
    required bool refresh,
  }) async {
    try {
      await characterRepository.list(
        listCharactersBookmarkedState: listCharactersBookmarkedState,
        listCharacters: this,
        refresh: refresh,
      );
    } on BackendException catch (e) {
      emit(ListCharactersError(e));
    } catch (e) {
      emit(
        const ListCharactersError(
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
      state is ListCharactersLoaded,
      'state must be ListCharactersInitial',
    );
    if ((state as ListCharactersLoaded).isLoading) return;
    var loadedState = (state as ListCharactersLoaded);
    emit(
      ListCharactersLoaded(
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
    if (state is ListCharactersLoading) return;
    emit(ListCharactersLoading());
    await get(
      refresh: true,
    );
  }

  /// Update list with query result, and notify listeners
  void update(
    Set<CharacterCubit> result,
    int total,
    bool refresh,
  ) {
    if (state is! ListCharactersLoaded || refresh) {
      emit(
        ListCharactersLoaded(
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
    assert(state is ListCharactersLoaded, 'state must be ListCharactersLoaded');
    var loadedState = (state as ListCharactersLoaded);
    emit(
      ListCharactersLoaded(
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
    emit(ListCharactersInitial());
  }

  ///For lazzy loading, Use [scrollNotification] to detect if the scroll has reached the end of the
  ///page, and if the list has more data, call `getMore`.
  bool onMaxScrollExtent(ScrollNotification scrollNotification) {
    if (state is! ListCharactersLoaded) return true;
    if (!(state as ListCharactersLoaded).canGetMore) return true;
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
    if (state is! ListCharactersLoaded) return true;
    if (!(state as ListCharactersLoaded).canGetMore) return true;
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
      if (state is! ListCharactersLoaded) return;
      if (!(state as ListCharactersLoaded).canGetMore) return;
      if (controller.position.maxScrollExtent != controller.offset) return;
      getMore();
    });
  }
}
