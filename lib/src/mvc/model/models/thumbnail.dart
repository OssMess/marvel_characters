class Thumbnail {
  final String path;
  final String extension;

  Thumbnail({
    required this.path,
    required this.extension,
  });

  factory Thumbnail.fromJson(Map<dynamic, dynamic> json) => Thumbnail(
        path: json['path'],
        extension: json['extension'],
      );

  String get url => '$path.$extension';

  Map<dynamic, dynamic> toJson() => {
        'path': path,
        'extension': extension,
      };
}
