import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:grouptalk/core/error/exception.dart';

abstract class AiRemoteDataSource {
  Future<String> generateResponse({required String prompt});
}

class AiRemoteDataSourceImpl implements AiRemoteDataSource {
  final Dio dio;

  AiRemoteDataSourceImpl({required this.dio});

  static const String _apiKey = 'AIzaSyAHykdumc7KSBfCfWnxZZEnjb6v7EbXtBk';
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1/models/gemini-2.5-flash:generateContent';

  @override
  Future<String> generateResponse({required String prompt}) async {
    final newPrompt =
        '''
        question: $prompt
      
      Respond ONLY in the following JSON format:
      {
        "requrest": "question",
        "result": "<short explanation>"
      }
    ''';
    final response;
    try {
      response = await dio.post(
        '$_baseUrl?key=$_apiKey',
        options: Options(
          headers: {'Content-Type': 'application/json'},
          validateStatus: (_) =>
              true, // don't throw on 4xx/5xx so we can inspect body
        ),
        data: {
          "contents": [
            {
              "parts": [
                {"text": newPrompt},
              ],
            },
          ],
        },
      );
    } catch (e) {
      debugPrint(e.toString());
      throw ServerException(errorMessage: e.toString());
    }

    debugPrint('Request URI: ${response.requestOptions.uri}.....................................>');
    debugPrint('Status code: ${response.statusCode}');
    debugPrint('Response data: ${response.data}');

    // Handle specific status for quota/limit first
    if (response.statusCode == 421) {
      throw ServerException(
        errorMessage: 'You\'ve exceeded your AI limit. Try again later',
      );
    }

    if (response.statusCode != 200) {
      throw ServerException(
        errorMessage:
            'Remote API returned ${response.statusCode}: ${response.data}',
      );
    }

    // Now parse safely
    dynamic textResponse =
        response.data['candidates']?[0]?['content']?['parts']?[0]?['text'];

    if (textResponse == null) {
      throw ServerException(errorMessage: 'Unexpected response shape');
    }

    if (textResponse is String && textResponse.contains('```')) {
      textResponse = textResponse
          .replaceAll(RegExp(r'```json', caseSensitive: false), '')
          .replaceAll('```', '')
          .trim();
    }

    // The Gemini API response structure parsed as JSON
    debugPrint('AI raw text response: $textResponse');
    late final dynamic decodedJson;
    try {
      decodedJson = json.decode(textResponse);
    } catch (e) {
      throw ServerException(
        errorMessage: 'Failed to parse AI response: ${e.toString()}',
      );
    }

    debugPrint('AI decoded response: $decodedJson');

    return decodedJson['result'] as String;
  }
}
