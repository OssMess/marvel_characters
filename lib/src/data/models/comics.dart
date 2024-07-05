import '../models.dart';

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
