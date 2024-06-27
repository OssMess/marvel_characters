class Url {
  final String type;
  final String url;

  Url({
    required this.type,
    required this.url,
  });

  factory Url.fromJson(Map<dynamic, dynamic> json) => Url(
        type: json['type'],
        url: json['url'],
      );

  Map<dynamic, dynamic> toJson() => {
        'type': type,
        'url': url,
      };
}
