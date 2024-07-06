part of 'list_characters_cubit.dart';

sealed class ListCharactersState extends Equatable {
  const ListCharactersState();

  @override
  List<Object> get props => [];
}

final class ListCharactersInitial extends ListCharactersState {}

final class ListCharactersLoading extends ListCharactersState {}

final class ListCharactersError extends ListCharactersState {
  final BackendException error;

  const ListCharactersError(this.error);

  @override
  List<Object> get props => [...error.props];
}

final class ListCharactersLoaded extends ListCharactersState {
  @override
  List<Object> get props => [
        set.length,
        isLoading,
        total,
        offset,
        totalPages,
        currentPage,
      ];

  /// Set of unique `T`.
  final Set<CharacterCubit> set;

  // The limit of elements per page. Used for pagination.
  final int limit;

  // The total number of Ts
  final int total;

  // Cuurent offset for pagination.
  final int offset;

  /// is awaiting for response from get HTTP request, used to avoid duplicated requests.
  final bool isLoading;

  /// total number of pages for appointments list.
  final int totalPages;

  /// current page.
  final int currentPage;

  /// `true` if there are still more pages (pagination).
  bool get hasMore => currentPage < totalPages;

  /// The number of nearby salons in list.
  int get length => set.length;

  /// `this.list` is empty.
  bool get isEmpty => set.isEmpty;

  /// `this.list` is not empty.
  bool get isNotEmpty => set.isNotEmpty;

  bool get canGetMore => hasMore && !isLoading;

  const ListCharactersLoaded({
    required this.currentPage,
    required this.totalPages,
    required this.total,
    required this.set,
    required this.offset,
    required this.isLoading,
    this.limit = 10,
  });

  CharacterCubit elementAt(int index) => set.elementAt(index);
}