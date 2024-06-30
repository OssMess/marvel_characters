import '../models.dart';

class Characters {
  final int available;
  final int returned;
  final String collectionUri;
  final List<CharactersItem> items;

  Characters({
    required this.available,
    required this.returned,
    required this.collectionUri,
    required this.items,
  });

  factory Characters.fromJson(Map<String, dynamic> json) => Characters(
        available: json['available'],
        returned: json['returned'],
        collectionUri: json['collectionURI'],
        items: List<CharactersItem>.from(
            json['items'].map((x) => CharactersItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'available': available,
        'returned': returned,
        'collectionURI': collectionUri,
        'items': List<dynamic>.from(items.map((x) => x.toJson())),
      };
}
