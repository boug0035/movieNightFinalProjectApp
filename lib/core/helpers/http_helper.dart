import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import 'package:flutter/foundation.dart';

class HttpHelper {
  static final HttpHelper _instance = HttpHelper._internal();
  factory HttpHelper() => _instance;
  HttpHelper._internal();

  Future<Map<String, dynamic>> get(String url) async {
    try {
      if (kDebugMode) {
        print('GET Request: $url');
      }

      final response = await http.get(Uri.parse(url));

      if (kDebugMode) {
        print('Response Status: ${response.statusCode}');
        print('Response Body: ${response.body}');
      }

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error in HTTP GET: $e');
      }
      throw Exception('Failed to load data: $e');
    }
  }

  // TMDB specific methods
  Future<Map<String, dynamic>> fetchMovies(
      {String type = 'popular', int page = 1}) async {
    String url;
    switch (type) {
      case 'upcoming':
        url =
            '${ApiConstants.tmdbBaseUrl}/movie/upcoming?api_key=${ApiConstants.tmdbApiKey}&page=$page';
        break;
      case 'now_playing':
        url =
            '${ApiConstants.tmdbBaseUrl}/movie/now_playing?api_key=${ApiConstants.tmdbApiKey}&page=$page';
        break;
      case 'popular':
      default:
        url =
            '${ApiConstants.tmdbBaseUrl}/movie/popular?api_key=${ApiConstants.tmdbApiKey}&page=$page';
    }
    return get(url);
  }

  // MovieNight API specific methods
  Future<Map<String, dynamic>> startSession(String deviceId) async {
    return get('${ApiConstants.startSessionUrl}?device_id=$deviceId');
  }

  Future<Map<String, dynamic>> joinSession(String deviceId, String code) async {
    return get('${ApiConstants.joinSessionUrl}?device_id=$deviceId&code=$code');
  }

  Future<Map<String, dynamic>> voteMovie(
      String sessionId, int movieId, bool vote) async {
    return get(
        '${ApiConstants.voteMovieUrl}?session_id=$sessionId&movie_id=$movieId&vote=$vote');
  }
}
