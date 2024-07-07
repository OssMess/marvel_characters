class Date {
  final String type;
  final String date;

  Date({
    required this.type,
    required this.date,
  });

  factory Date.fromJson(Map<String, dynamic> json) => Date(
        type: json['type'],
        date: json['date'],
      );

  Map<String, dynamic> toJson() => {
        'type': type,
        'date': date,
      };
}
