class ListModels<T> {
  /// Set of unique `T`.
  Set<T> list = {};

  /// is in init state and requires initialization.
  bool isNull = true;

  /// is awaiting for response from get HTTP request, used to avoid duplicated requests.
  bool isLoading = false;

  /// has error after the last HTTP request
  bool hasError = false;

  /// The number of nearby salons in list.
  int get length => list.length;

  bool get isNotNull => !isNull;

  /// `this.list` is empty.
  bool get isEmpty => list.isEmpty;

  /// `this.list` is not empty.
  bool get isNotEmpty => list.isNotEmpty;

  ListModels();

  T elementAt(int index) => list.elementAt(index);
}
