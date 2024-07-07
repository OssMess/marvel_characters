class Price {
  final String type;
  final num price;

  Price({
    required this.type,
    required this.price,
  });

  factory Price.fromJson(Map<String, dynamic> json) => Price(
        type: json['type'],
        price: json['price'],
      );

  Map<String, dynamic> toJson() => {
        'type': type,
        'price': price,
      };
}
