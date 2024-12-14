class ApiConstants {
  // TMDB API
  static const String tmdbBaseUrl = 'https://api.themoviedb.org/3';
  static const String tmdbApiKey =
      '61e02808a626232c79b0a3f0606bdefa'; // please don't mind the hardcoded Api key. I would never do this in a production enviroment!
  static const String tmdbImageBaseUrl = 'https://image.tmdb.org/t/p/w500';

  // MovieNight API
  static const String movieNightBaseUrl =
      'https://movie-night-api.onrender.com';

  // TMDB API Endpoints
  static String get popularMoviesUrl =>
      '$tmdbBaseUrl/movie/popular?api_key=$tmdbApiKey';
  static String get upcomingMoviesUrl =>
      '$tmdbBaseUrl/movie/upcoming?api_key=$tmdbApiKey';
  static String get nowPlayingMoviesUrl =>
      '$tmdbBaseUrl/movie/now_playing?api_key=$tmdbApiKey';

  // MovieNight API Endpoints
  static String get startSessionUrl => '$movieNightBaseUrl/start-session';
  static String get joinSessionUrl => '$movieNightBaseUrl/join-session';
  static String get voteMovieUrl => '$movieNightBaseUrl/vote-movie';

  // Helper method to get image URL
  static String getImageUrl(String? posterPath) {
    if (posterPath == null) {
      return ''; // Fallback: Return empty string or a default image
    }
    return '$tmdbImageBaseUrl$posterPath';
  }
}
