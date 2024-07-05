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
