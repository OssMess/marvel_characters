import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/_models.dart';
import '../../../data/_repositories.dart';
import '../../_cubits.dart';

part 'list_comics_state.dart';

class ListComicsCubit extends Cubit<ListComicsState> {
  final ComicRepository comicRepository = ComicRepository();

  ListComicsCubit() : super(ListComicsInitial());

  /// Init data.
  /// if [callGet] is `true` proceed with query, else break.
  Future<void> initData({
    required bool callGet,
  }) async {
    assert(
      state is ListComicsInitial,
      'state must be ListComicsInitial',
    );
    if (!callGet) return;
    emit(ListComicsLoading());
    await get(
      refresh: false,
    );
  }

  /// call get to retrieve data from backend.
  Future<void> get({
    required bool refresh,
  }) async {
    try {
      await comicRepository.list(
        listComics: this,
        refresh: refresh,
      );
    } on BackendException catch (e) {
      emit(ListComicsError(e));
    } catch (e) {
      emit(
        const ListComicsError(
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
      state is ListComicsLoaded,
      'state must be ListComicsInitial',
    );
    if ((state as ListComicsLoaded).isLoading) return;
    var loadedState = (state as ListComicsLoaded);
    emit(
      ListComicsLoaded(
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
    if (state is ListComicsLoading) return;
    emit(ListComicsLoading());
    await get(
      refresh: true,
    );
  }

  /// Update list with query result, and notify listeners
  void update(
    Set<ComicCubit> result,
    int total,
    bool refresh,
  ) {
    if (state is! ListComicsLoaded || refresh) {
      emit(
        ListComicsLoaded(
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
    assert(state is ListComicsLoaded, 'state must be ListComicsLoaded');
    var loadedState = (state as ListComicsLoaded);
    emit(
      ListComicsLoaded(
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
    emit(ListComicsInitial());
  }

  ///For lazzy loading, Use [scrollNotification] to detect if the scroll has reached the end of the
  ///page, and if the list has more data, call `getMore`.
  bool onMaxScrollExtent(ScrollNotification scrollNotification) {
    if (state is! ListComicsLoaded) return true;
    if (!(state as ListComicsLoaded).canGetMore) return true;
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
    if (state is! ListComicsLoaded) return true;
    if (!(state as ListComicsLoaded).canGetMore) return true;
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
      if (state is! ListComicsLoaded) return;
      if (!(state as ListComicsLoaded).canGetMore) return;
      if (controller.position.maxScrollExtent != controller.offset) return;
      getMore();
    });
  }
}
