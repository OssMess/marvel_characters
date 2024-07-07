import 'package:equatable/equatable.dart';

import '../_models.dart';

class Data extends Equatable {
  final int offset;
  final int limit;
  final int total;
  final int count;
  final List<Result> results;

  const Data({
    required this.offset,
    required this.limit,
    required this.total,
    required this.count,
    required this.results,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        offset: json['offset'],
        limit: json['limit'],
        total: json['total'],
        count: json['count'],
        results:
            List<Result>.from(json['results'].map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'offset': offset,
        'limit': limit,
        'total': total,
        'count': count,
        'results': List<dynamic>.from(results.map((x) => x.toJson())),
      };

  @override
  List<Object?> get props => [
        offset,
        limit,
        total,
        count,
        results,
      ];
}
