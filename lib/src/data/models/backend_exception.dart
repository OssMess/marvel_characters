import 'dart:convert';

import 'package:http/http.dart' as http;

class BackendException implements Exception {
  final String? code;
  final int statusCode;

  BackendException({
    required this.code,
    required this.statusCode,
  });

  factory BackendException.fromJson(Map<String, dynamic> json) {
    return BackendException(
      code: json['code'],
      statusCode: json['statusCode'],
    );
  }

  factory BackendException.fromResponse(http.Response response) {
    Map<String, dynamic> body = jsonDecode(response.body);
    return BackendException(
      code: body['code'],
      statusCode: body['message'],
    );
  }
}
