import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../../../data/list_models.dart';
import '../../../../data/models.dart';
import '../../../model/models.dart';
import '../../services.dart';

class APICharactersService {
  Future<void> list({
    required List<Character> bookmarkedCharacters,
    required ListCharacters listCharacters,
    required bool refresh,
  }) async {
    late http.Request request;
    request = http.Request(
      'GET',
      Uri.parse(
        '${APIMarvel.baseUrl}/characters?apikey=${APIMarvel.publicKey}&hash=${APIMarvel.hash}&ts=${APIMarvel.timestamp}&limit=${listCharacters.limit}&offset=${listCharacters.offset}',
      ),
    );
    request.headers.addAll({
      HttpHeaders.acceptHeader: 'application/json',
    });
    http.Response response = await HttpRequest.attemptHttpCall(request);
    if (response.statusCode == 200) {
      Map<dynamic, dynamic> result = jsonDecode(response.body);
      List<Character> list = List.from(result['data']['results'])
          .map((e) => Character.fromJson(e, bookmarkedCharacters))
          .toList();
      listCharacters.update(
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
