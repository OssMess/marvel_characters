part of 'comic_cubit.dart';

class ComicState extends Equatable {
  const ComicState();

  @override
  List<Object?> get props => [];
}

class ComicLoading extends ComicState {
  const ComicLoading();
}

class ComicError extends ComicState {
  const ComicError();
}

// ignore: must_be_immutable
class ComicLoaded extends ComicState {
  final int code;
  final String status;
  final String copyright;
  final String attributionText;
  final String attributionHtml;
  final Data data;
  final String etag;

  @override
  List<Object?> get props => [
        code,
        status,
        copyright,
        attributionText,
        attributionHtml,
        data,
        etag,
      ];

  const ComicLoaded({
    required this.code,
    required this.status,
    required this.copyright,
    required this.attributionText,
    required this.attributionHtml,
    required this.data,
    required this.etag,
  });

  factory ComicLoaded.fromJson(Map<dynamic, dynamic> json) => ComicLoaded(
        code: json['code'],
        status: json['status'],
        copyright: json['copyright'],
        attributionText: json['attributionText'],
        attributionHtml: json['attributionHTML'],
        data: Data.fromJson(json['data']),
        etag: json['etag'],
      );

  Map<String, dynamic> toJson() => {
        'code': code,
        'status': status,
        'copyright': copyright,
        'attributionText': attributionText,
        'attributionHTML': attributionHtml,
        'data': data.toJson(),
        'etag': etag,
      };
}
