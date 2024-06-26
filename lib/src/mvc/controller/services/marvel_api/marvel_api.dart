import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../../../tools.dart';
import '../../../model/list_models.dart';
import '../../../model/models.dart';
import '../../services.dart';

class MarvelAPI {
  final String publicKey = '93ace9a1531e530cc03dc5e37b1ca0e9';
  final String privateKey = 'ca027e5f35adea2eb47c4939aaacf35e7708dc41';
  final String timestamp = '1';
  final String hash =
      '1ca027e5f35adea2eb47c4939aaacf35e7708dc4193ace9a1531e530cc03dc5e37b1ca0e9';
  static const String baseUrl = 'http://gateway.marvel.com/v1/public';

  /// Get all Plan.
  Future<void> getCharacters({
    required ListCharacters listCharacters,
    required bool refresh,
  }) async {
    late http.Request request;
    request = http.Request(
      'GET',
      Uri.parse(
        '$baseUrl/characters?apikey=$publicKey&hash=$hash&ts=$timestamp&limit=${listCharacters.limit}',
      ),
    );
    request.headers.addAll({
      HttpHeaders.acceptHeader: 'application/json',
    });
    http.Response response = await HttpRequest.attemptHttpCall(request);
    if (response.statusCode == 200) {
      Map<dynamic, dynamic> result = jsonDecode(response.body);
      List<Character> sortedList = List.from(result['data']['result'])
          .map((e) => Character.fromJson(e))
          .toList();
      listCharacters.update(
        sortedList.toSet(),
        result['data']['total'],
        false,
        refresh,
      );
    } else {
      throw BackendException.fromResponse(response);
    }
  }
}
