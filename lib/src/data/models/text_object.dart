class TextObject {
  final String type;
  final String language;
  final String text;

  TextObject({
    required this.type,
    required this.language,
    required this.text,
  });

  factory TextObject.fromJson(Map<String, dynamic> json) => TextObject(
        type: json['type'],
        language: json['language'],
        text: json['text'],
      );

  Map<String, dynamic> toJson() => {
        'type': type,
        'language': language,
        'text': text,
      };
}
