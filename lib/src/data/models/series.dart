class Series {
  final String resourceUri;
  final String name;

  Series({
    required this.resourceUri,
    required this.name,
  });

  factory Series.fromJson(Map<String, dynamic> json) => Series(
        resourceUri: json['resourceURI'],
        name: json['name'],
      );

  Map<String, dynamic> toJson() => {
        'resourceURI': resourceUri,
        'name': name,
      };
}
