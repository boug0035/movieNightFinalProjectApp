import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';

class TMDBService {
  Future<Map<String, dynamic>> getMovies({
    String? type = 'popular',
    int page = 1,
  }) async {
    String url;
    switch (type) {
      case 'upcoming':
        url = '${ApiConstants.upcomingMoviesUrl}&page=$page';
        break;
      case 'now_playing':
        url = '${ApiConstants.nowPlayingMoviesUrl}&page=$page';
        break;
      case 'popular':
      default:
        url = '${ApiConstants.popularMoviesUrl}&page=$page';
    }

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load movies: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load movies: $e');
    }
  }
}
