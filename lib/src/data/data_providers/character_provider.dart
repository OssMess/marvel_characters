import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../business_logic/cubits.dart';
import '../../mvc/controller/hives.dart';
import '../data_providers.dart';
import '../models.dart';

class CharacterProvider {
  Future<Map<String, dynamic>> list({
    required int offset,
    required int limit,
  }) async {
    late http.Request request;
    request = http.Request(
      'GET',
      Uri.parse(
        '${APIMarvel.baseUrl}/characters?apikey=${APIMarvel.publicKey}&hash=${APIMarvel.hash}&ts=${APIMarvel.timestamp}&limit=$limit&offset=$offset',
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

  Future<void> addBookmark({
    required HiveCharacters hiveCharacters,
    required CharacterState character,
  }) async {
    await hiveCharacters.save(character);
  }

  Future<void> deleteBookmark({
    required HiveCharacters hiveCharacters,
    required CharacterState character,
  }) async {
    await hiveCharacters.delete(character);
  }
}
