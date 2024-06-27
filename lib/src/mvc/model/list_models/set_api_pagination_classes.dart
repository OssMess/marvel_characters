import 'dart:math';

import 'package:flutter/material.dart';

/// List user upcoming appointments (Set<`Appointment`>):
abstract class SetApiPaginationClasses<T> with ChangeNotifier {
  /// Set of unique `T`.
  Set<T> list = {};

  // The limit of elements per page. Used for pagination.
  final int limit;

  // The total number of characters
  int total = 0;

  // Cuurent offset for pagination.
  int offset = 0;

  /// is in init state and requires initialization.
  bool isNull = true;

  /// is awaiting for response from get HTTP request, used to avoid duplicated requests.
  bool isLoading = false;

  /// has error after the last HTTP request
  bool hasError = false;

  /// total number of pages for appointments list.
  int totalPages = -1;

  /// current page.
  int currentPage = 0;

  SetApiPaginationClasses({required this.limit});

  /// `true` if there are still more pages (pagination).
  bool get hasMore => currentPage < totalPages;

  /// The number of nearby salons in list.
  int get length => list.length;

  bool get isNotNull => !isNull;

  /// `this.list` is empty.
  bool get isEmpty => list.isEmpty;

  /// `this.list` is not empty.
  bool get isNotEmpty => list.isNotEmpty;

  bool get canGetMore => (isNotNull && hasMore && !isLoading);

  T elementAt(int index) => list.elementAt(index);

  /// Init data.
  /// if [callGet] is `true` proceed with query, else break.
  Future<void> initData({
    required bool callGet,
  }) async {
    if (!callGet) return;
    if (!isNull) return;
    if (isLoading) return;
    isLoading = true;
    await get(
      refresh: false,
    );
  }

  /// call get to retrieve data from backend.
  Future<void> get({
    required bool refresh,
  });

  /// Get more data, uses pagination.
  Future<void> getMore() async {
    if (isNull) return;
    if (isLoading) return;
    isLoading = true;
    notifyListeners();
    await get(
      refresh: false,
    );
  }

  /// Refresh data.
  Future<void> refresh() async {
    if (isLoading) return;
    total = 0;
    offset = 0;
    totalPages = -1;
    currentPage = 0;
    hasError = false;
    isLoading = true;
    await get(
      refresh: true,
    );
  }

  /// Update list with query result, and notify listeners
  void update(
    Set<T> result,
    int total,
    bool error,
    bool refresh,
  ) {
    if (error || refresh) {
      list.clear();
    }
    if (!error) {
      this.total = total;
      offset = offset + min(limit, result.length);
      totalPages = (total / limit).round() + 1;
      currentPage++;
      list.addAll(result);
    }
    isLoading = false;
    isNull = false;
    hasError = error;
    notifyListeners();
  }

  /// Reset list to its initial state.
  void reset() {
    isNull = true;
    isLoading = false;
    hasError = false;
    list.clear();
    totalPages = -1;
    currentPage = 0;
  }

  /// Clone the values of all attributs of [update] to `this` and refresh the UI.
  /// The aim here is to update to `this` and keep all widgets attached to `this` notifiable.
  void updateFrom(SetApiPaginationClasses<T> update) {
    list = update.list;
    isNull = update.isNull;
    isLoading = update.isLoading;
    totalPages = update.totalPages;
    currentPage = update.currentPage;
    hasError = update.hasError;
    notifyListeners();
  }

  ///For lazzy loading, Use [scrollNotification] to detect if the scroll has reached the end of the
  ///page, and if the list has more data, call `getMore`.
  bool onMaxScrollExtent(ScrollNotification scrollNotification) {
    if (!canGetMore) return true;
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
    if (!canGetMore) return true;
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
      if (isNull) return;
      if (isLoading) return;
      if (!canGetMore) return;
      if (controller.position.maxScrollExtent != controller.offset) return;
      getMore();
    });
  }
}
