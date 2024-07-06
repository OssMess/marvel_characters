part of 'list_characters_bookmarked_cubit.dart';

sealed class ListCharactersBookmarkedState extends Equatable {
  const ListCharactersBookmarkedState();

  @override
  List<Object> get props => [];
}

class ListCharactersBookmarkedInitial extends ListCharactersBookmarkedState {}

class ListCharactersBookmarkedLoading extends ListCharactersBookmarkedState {}

class ListCharactersBookmarkedError extends ListCharactersBookmarkedState {
  final BackendException error;

  const ListCharactersBookmarkedError(this.error);

  @override
  List<Object> get props => [...error.props];
}

class ListCharactersBookmarkedLoaded extends ListCharactersBookmarkedState {
  final Set<CharacterCubit> set;

  final String boxName = 'characters';

  const ListCharactersBookmarkedLoaded({
    required this.set,
  });

  @override
  List<Object> get props => [set.length];
}
