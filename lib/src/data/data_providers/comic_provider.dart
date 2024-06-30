import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../mvc/controller/services.dart';
import '../../mvc/model/models.dart';

class ComicProvider {
  Future<Map<String, dynamic>> listComics({
    required int offset,
    required int limit,
  }) async {
    late http.Request request;
    request = http.Request(
      'GET',
      Uri.parse(
        '${APIMarvel.baseUrl}/comics?apikey=${APIMarvel.publicKey}&hash=${APIMarvel.hash}&ts=${APIMarvel.timestamp}&limit=$limit&offset=$offset',
      ),
    );
    request.headers.addAll({
      HttpHeaders.acceptHeader: 'application/json',
    });
    http.Response response = await HttpRequest.attemptHttpCall(request);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw BackendException.fromResponse(response);
    }
  }

  Future<Map<String, dynamic>> listCharacterComics({
    required int characterId,
    required int offset,
    required int limit,
  }) async {
    late http.Request request;
    request = http.Request(
      'GET',
      Uri.parse(
        '${APIMarvel.baseUrl}/characters/$characterId/comics?apikey=${APIMarvel.publicKey}&hash=${APIMarvel.hash}&ts=${APIMarvel.timestamp}&limit=$limit&offset=$offset',
      ),
    );
    request.headers.addAll({
      HttpHeaders.acceptHeader: 'application/json',
    });
    http.Response response = await HttpRequest.attemptHttpCall(request);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw BackendException.fromResponse(response);
    }
  }
}
