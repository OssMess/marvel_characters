class CharactersItem {
  final String resourceUri;
  final String name;
  final String? role;

  CharactersItem({
    required this.resourceUri,
    required this.name,
    required this.role,
  });

  factory CharactersItem.fromJson(Map<String, dynamic> json) => CharactersItem(
        resourceUri: json['resourceURI'],
        name: json['name'],
        role: json['role'],
      );

  Map<String, dynamic> toJson() => {
        'resourceURI': resourceUri,
        'name': name,
        'role': role,
      };
}
