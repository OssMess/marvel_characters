class ListModelsPagination<T> {
  /// Set of unique `T`.
  Set<T> list = {};

  // The limit of elements per page. Used for pagination.
  final int limit;

  // The total number of Ts
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

  ListModelsPagination({this.limit = 10});

  T elementAt(int index) => list.elementAt(index);
}
