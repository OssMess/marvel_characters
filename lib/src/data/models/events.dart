import '../_models.dart';

class Events {
  final int available;
  final int returned;
  final String collectionUri;
  final List<Series> items;

  Events({
    required this.available,
    required this.returned,
    required this.collectionUri,
    required this.items,
  });

  factory Events.fromJson(Map<String, dynamic> json) => Events(
        available: json['available'],
        returned: json['returned'],
        collectionUri: json['collectionURI'],
        items: List<Series>.from(json['items'].map((x) => Series.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'available': available,
        'returned': returned,
        'collectionURI': collectionUri,
        'items': List<dynamic>.from(items.map((x) => x.toJson())),
      };
}
