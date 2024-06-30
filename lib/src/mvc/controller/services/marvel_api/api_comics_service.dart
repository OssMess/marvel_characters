import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../../../data/models.dart';
import '../../../model/list_models.dart';
import '../../../model/models.dart';
import '../../services.dart';

class APIComicsService {
  Future<void> list({
    required ListComics listComics,
    required bool refresh,
  }) async {
    late http.Request request;
    request = http.Request(
      'GET',
      Uri.parse(
        '${APIMarvel.baseUrl}/comics?apikey=${APIMarvel.publicKey}&hash=${APIMarvel.hash}&ts=${APIMarvel.timestamp}&limit=${listComics.limit}&offset=${listComics.offset}',
      ),
    );
    request.headers.addAll({
      HttpHeaders.acceptHeader: 'application/json',
    });
    http.Response response = await HttpRequest.attemptHttpCall(request);
    if (response.statusCode == 200) {
      Map<dynamic, dynamic> result = jsonDecode(response.body);
      List<Comic> list = List.from(result['data']['results'])
          .map((e) => Comic.fromJson(e))
          .toList();
      listComics.update(
        list.toSet(),
        result['data']['total'],
        false,
        refresh,
      );
    } else {
      throw BackendException.fromResponse(response);
    }
  }

  Future<void> listCharacterComics({
    required int characterId,
    required ListCharacterComics listCharacterComics,
    required bool refresh,
  }) async {
    late http.Request request;
    request = http.Request(
      'GET',
      Uri.parse(
        '${APIMarvel.baseUrl}/characters/$characterId/comics?apikey=${APIMarvel.publicKey}&hash=${APIMarvel.hash}&ts=${APIMarvel.timestamp}&limit=${listCharacterComics.limit}&offset=${listCharacterComics.offset}',
      ),
    );
    request.headers.addAll({
      HttpHeaders.acceptHeader: 'application/json',
    });
    http.Response response = await HttpRequest.attemptHttpCall(request);
    if (response.statusCode == 200) {
      Map<dynamic, dynamic> result = jsonDecode(response.body);
      List<CharacterComic> list = List.from(result['data']['results'])
          .map((e) => CharacterComic.fromJson(e))
          .toList();
      listCharacterComics.update(
        list.toSet(),
        result['data']['total'],
        false,
        refresh,
      );
    } else {
      throw BackendException.fromResponse(response);
    }
  }
}
