import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/session_model.dart';
import '../../core/constants/api_constants.dart';
import 'package:flutter/foundation.dart';

class SessionRepository {
  Future<SessionModel> startSession(String deviceId) async {
    try {
      final url =
          Uri.parse('${ApiConstants.startSessionUrl}?device_id=$deviceId');

      if (kDebugMode) {
        print('Starting session with URL: $url');
      }

      final response = await http.get(url);

      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData.containsKey('data')) {
          final data = responseData['data'];
          return SessionModel.fromJson({
            ...data,
            'device_id': deviceId,
          });
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to start session: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error in startSession: $e');
      }
      throw Exception('Failed to start session: $e');
    }
  }

  Future<bool> voteMovie(String sessionId, int movieId, bool vote) async {
    try {
      final url = Uri.parse(
          '${ApiConstants.voteMovieUrl}?session_id=$sessionId&movie_id=$movieId&vote=$vote');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final data = responseData['data'];
        return data['match'] ?? false;
      } else {
        throw Exception('Failed to vote movie: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error in voteMovie: $e');
      }
      throw Exception('Failed to vote movie: $e');
    }
  }

  Future<SessionModel> joinSession(String deviceId, String code) async {
    try {
      final url = Uri.parse(
          '${ApiConstants.joinSessionUrl}?device_id=$deviceId&code=$code');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData.containsKey('data')) {
          final data = responseData['data'];
          return SessionModel.fromJson({
            ...data,
            'device_id': deviceId,
          });
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to join session: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error in joinSession: $e');
      }
      throw Exception('Failed to join session: $e');
    }
  }
}
