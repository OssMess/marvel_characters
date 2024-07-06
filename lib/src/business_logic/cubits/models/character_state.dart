part of 'character_cubit.dart';

// ignore: must_be_immutable
class CharacterState extends Equatable {
  const CharacterState();

  @override
  List<Object?> get props => [];
}

class CharacterLoading extends CharacterState {
  const CharacterLoading();
}

class CharacterError extends CharacterState {
  const CharacterError();
}

// ignore: must_be_immutable
class CharacterLoaded extends CharacterState {
  final int id;
  final String name;
  final String description;
  final String modified;
  final String resourceUri;
  final List<Url> urls;
  final CachedNetworkImageProvider photo;
  final Thumbnail thumbnail;
  final Comics comics;
  final Stories stories;
  final Comics events;
  final Comics series;
  final bool isBookmarked;
  final ListCharacterComicsCubit listCharacterComicsCubit;

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        modified,
        resourceUri,
        urls,
        photo,
        thumbnail,
        comics,
        stories,
        events,
        series,
        isBookmarked,
      ];

  const CharacterLoaded({
    required this.id,
    required this.name,
    required this.description,
    required this.modified,
    required this.resourceUri,
    required this.urls,
    required this.photo,
    required this.thumbnail,
    required this.comics,
    required this.stories,
    required this.events,
    required this.series,
    required this.isBookmarked,
    required this.listCharacterComicsCubit,
  });

  factory CharacterLoaded.fromCharacterLoaded(
    CharacterLoaded characterLoaded, [
    bool? isBookmarked,
  ]) =>
      CharacterLoaded(
        id: characterLoaded.id,
        name: characterLoaded.name,
        description: characterLoaded.description,
        modified: characterLoaded.modified,
        resourceUri: characterLoaded.resourceUri,
        urls: characterLoaded.urls,
        photo: characterLoaded.photo,
        thumbnail: characterLoaded.thumbnail,
        comics: characterLoaded.comics,
        stories: characterLoaded.stories,
        events: characterLoaded.events,
        series: characterLoaded.series,
        isBookmarked: isBookmarked ?? characterLoaded.isBookmarked,
        listCharacterComicsCubit: characterLoaded.listCharacterComicsCubit,
      );

  factory CharacterLoaded.fromJson(
    Map<dynamic, dynamic> json,
    bool isBookmarked,
  ) =>
      CharacterLoaded(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        modified: json['modified'],
        resourceUri: json['resourceURI'],
        urls: List<Url>.from(json['urls'].map((x) => Url.fromJson(x))),
        photo: CachedNetworkImageProvider(
          json['thumbnail']['path'] + '.' + json['thumbnail']['extension'],
        ),
        thumbnail: Thumbnail.fromJson(json['thumbnail']),
        comics: Comics.fromJson(json['comics']),
        stories: Stories.fromJson(json['stories']),
        events: Comics.fromJson(json['events']),
        series: Comics.fromJson(json['series']),
        isBookmarked: isBookmarked,
        listCharacterComicsCubit: ListCharacterComicsCubit(json['id']),
      );

  Map<dynamic, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'modified': modified,
        'resourceURI': resourceUri,
        'urls': List<dynamic>.from(urls.map((x) => x.toJson())),
        'thumbnail': thumbnail.toJson(),
        'comics': comics.toJson(),
        'stories': stories.toJson(),
        'events': events.toJson(),
        'series': series.toJson(),
      };

  bool get hasWikiUrl =>
      urls.where((element) => element.type == 'wiki').isNotEmpty;

  String get wikiUrl =>
      urls.firstWhere((element) => element.type == 'wiki').url;

  bool get hasDetailsUrl =>
      urls.where((element) => element.type == 'detail').isNotEmpty;

  String get detailUrl =>
      urls.firstWhere((element) => element.type == 'detail').url;

  bool get hasComicLinkUrl =>
      urls.where((element) => element.type == 'comiclink').isNotEmpty;

  String get comiclinkUrl =>
      urls.firstWhere((element) => element.type == 'comiclink').url;
}
