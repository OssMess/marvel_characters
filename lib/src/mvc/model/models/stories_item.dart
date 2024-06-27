class StoriesItem {
  final String resourceUri;
  final String name;
  final String type;

  StoriesItem({
    required this.resourceUri,
    required this.name,
    required this.type,
  });

  factory StoriesItem.fromJson(Map<dynamic, dynamic> json) => StoriesItem(
        resourceUri: json['resourceURI'],
        name: json['name'],
        type: json['type'],
      );

  Map<String, dynamic> toJson() => {
        'resourceURI': resourceUri,
        'name': name,
        'type': type,
      };
}
