import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_models/movie_selection_view_model.dart';
import '../../core/constants/spacing_constants.dart';
import '../../core/constants/api_constants.dart';
import '../../models/movie_model.dart';
import 'widgets/movie_card.dart';

class MovieSelectionScreen extends StatefulWidget {
  const MovieSelectionScreen({super.key});

  @override
  State<MovieSelectionScreen> createState() => _MovieSelectionScreenState();
}

class _MovieSelectionScreenState extends State<MovieSelectionScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MovieSelectionViewModel>().loadMovies();
    });
  }

  void _showMatchDialog(BuildContext context, MovieModel movie) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('It\'s a Match! 🎉'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('You both liked "${movie.title}"!'),
            const SizedBox(height: Spacing.lg),
            if (movie.posterPath != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(Spacing.borderRadiusMd),
                child: Image.network(
                  ApiConstants.getImageUrl(movie.posterPath),
                  height: 200,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.movie, size: 100),
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Text('Back to Home'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleVote(bool vote) async {
    final viewModel = context.read<MovieSelectionViewModel>();
    final isMatch = await viewModel.voteMovie(vote);

    if (mounted && isMatch) {
      _showMatchDialog(context, viewModel.matchedMovie!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find a Movie'),
        centerTitle: true,
      ),
      body: Consumer<MovieSelectionViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading && viewModel.movies.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: Spacing.md),
                  Text(
                    'Loading movies...',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            );
          }

          if (viewModel.error != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(Spacing.screenPadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: Spacing.xxl,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(height: Spacing.md),
                    Text(
                      viewModel.error!,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: Spacing.lg),
                    ElevatedButton(
                      onPressed: () {
                        viewModel.clearError();
                        viewModel.loadMovies();
                      },
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            );
          }

          final currentMovie = viewModel.currentMovie;
          if (currentMovie == null) {
            return Center(
              child: Text(
                'No more movies available',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            );
          }

          return Center(
            child: MovieCard(
              key: ValueKey('movie_${currentMovie.id}'),
              movie: currentMovie,
              onVote: _handleVote,
            ),
          );
        },
      ),
    );
  }
}
