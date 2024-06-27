import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../controller/hives.dart';
import '../list_models.dart';
import '../models.dart';

class Character with ChangeNotifier {
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
  final ListCharacterComics listCharacterComics;

  Character({
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
    required this.listCharacterComics,
  });

  factory Character.fromJson(Map<dynamic, dynamic> json) => Character(
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
        isBookmarked: HiveCharacters.list
            .where((element) => element.id == json['id'])
            .isNotEmpty,
        listCharacterComics: ListCharacterComics(characterId: json['id']),
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

  Future<void> bookmark() async {
    if (isBookmarked) {
      await deleteBookmark();
    } else {
      await addBookmark();
    }
  }

  Future<void> addBookmark() async {
    isBookmarked = true;
    notifyListeners();
    await HiveCharacters.save(this);
  }

  Future<void> deleteBookmark() async {
    isBookmarked = false;
    notifyListeners();
    await HiveCharacters.delete(this);
  }

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

class Comics {
  final int available;
  final int returned;
  final String collectionUri;
  final List<ComicsItem> items;

  Comics({
    required this.available,
    required this.returned,
    required this.collectionUri,
    required this.items,
  });

  factory Comics.fromJson(Map<dynamic, dynamic> json) => Comics(
        available: json['available'],
        returned: json['returned'],
        collectionUri: json['collectionURI'],
        items: List<ComicsItem>.from(
            json['items'].map((x) => ComicsItem.fromJson(x))),
      );

  Map<dynamic, dynamic> toJson() => {
        'available': available,
        'returned': returned,
        'collectionURI': collectionUri,
        'items': List<dynamic>.from(items.map((x) => x.toJson())),
      };
}

class ComicsItem {
  final String resourceUri;
  final String name;

  ComicsItem({
    required this.resourceUri,
    required this.name,
  });

  factory ComicsItem.fromJson(Map<dynamic, dynamic> json) => ComicsItem(
        resourceUri: json['resourceURI'],
        name: json['name'],
      );

  Map<dynamic, dynamic> toJson() => {
        'resourceURI': resourceUri,
        'name': name,
      };
}
