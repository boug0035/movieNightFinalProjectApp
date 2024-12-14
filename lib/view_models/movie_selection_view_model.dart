import 'package:flutter/foundation.dart';
import '../core/helpers/http_helper.dart';
import '../core/helpers/shared_prefs_helper.dart';
import '../models/movie_model.dart';

class MovieSelectionViewModel extends ChangeNotifier {
  final HttpHelper _httpHelper = HttpHelper();
  final SharedPrefsHelper _prefsHelper = SharedPrefsHelper();

  final List<MovieModel> _movies = [];
  int _currentIndex = 0;
  bool _isLoading = false;
  String? _error;
  int _currentPage = 1;
  MovieModel? _matchedMovie;
  bool _isDismissed = false;

  List<MovieModel> get movies => _movies;
  MovieModel? get currentMovie =>
      _movies.isNotEmpty && _currentIndex < _movies.length && !_isDismissed
          ? _movies[_currentIndex]
          : null;
  bool get isLoading => _isLoading;
  String? get error => _error;
  MovieModel? get matchedMovie => _matchedMovie;

  Future<void> loadMovies() async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      final result = await _httpHelper.fetchMovies(page: _currentPage);
      final List<dynamic> moviesList = result['results'];

      final newMovies =
          moviesList.map((movie) => MovieModel.fromJson(movie)).toList();

      _movies.addAll(newMovies);
      _currentPage++;
      _error = null;
      _isDismissed = false;
    } catch (e) {
      _error = 'Failed to load movies';
      if (kDebugMode) {
        print('Error loading movies: $e');
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> voteMovie(bool vote) async {
    if (currentMovie == null) return false;

    try {
      final sessionId = await _prefsHelper.getSessionId();
      if (sessionId == null) {
        throw Exception('Session ID not found');
      }

      final response =
          await _httpHelper.voteMovie(sessionId, currentMovie!.id, vote);
      final isMatch = response['data']['match'] ?? false;

      if (isMatch) {
        _matchedMovie = currentMovie;
        _isDismissed = true;
        notifyListeners();
        return true;
      }

      // Mark current movie as dismissed before moving to next
      _isDismissed = true;
      notifyListeners();

      // Move to next movie
      _currentIndex++;
      _isDismissed = false;

      // Load more movies
      if (_currentIndex >= _movies.length - 5) {
        loadMovies();
      }

      notifyListeners();
      return false;
    } catch (e) {
      _error = 'Failed to submit vote';
      if (kDebugMode) {
        print('Error voting: $e');
      }
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
