import '../models.dart';

class Stories {
  final int available;
  final int returned;
  final String collectionUri;
  final List<StoriesItem> items;

  Stories({
    required this.available,
    required this.returned,
    required this.collectionUri,
    required this.items,
  });

  factory Stories.fromJson(Map<dynamic, dynamic> json) => Stories(
        available: json['available'],
        returned: json['returned'],
        collectionUri: json['collectionURI'],
        items: List<StoriesItem>.from(
            json['items'].map((x) => StoriesItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'available': available,
        'returned': returned,
        'collectionURI': collectionUri,
        'items': List<dynamic>.from(items.map((x) => x.toJson())),
      };
}
