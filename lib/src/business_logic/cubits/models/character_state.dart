part of 'character_cubit.dart';

// ignore: must_be_immutable
class CharacterState extends Equatable {
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
  bool isBookmarked;
  final ListCharacterComicsCubit listCharacterComicsCubit;

  CharacterState({
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

  factory CharacterState.fromJson(
    Map<dynamic, dynamic> json,
    bool isBookmarked,
  ) =>
      CharacterState(
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

  @override
  List<Object?> get props => [];
}
