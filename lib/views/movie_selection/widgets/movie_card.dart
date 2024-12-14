import 'package:flutter/material.dart';
import '../../../core/constants/api_constants.dart';
import '../../../models/movie_model.dart';
import '../../../core/constants/spacing_constants.dart';

class MovieCard extends StatefulWidget {
  final MovieModel movie;
  final Function(bool) onVote;

  const MovieCard({
    super.key,
    required this.movie,
    required this.onVote,
  });

  @override
  State<MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  double _dragOffset = 0;
  bool _isDragging = false;

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffset += details.delta.dx;
      _isDragging = true;
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    final threshold = MediaQuery.of(context).size.width * 0.3;

    if (_dragOffset.abs() > threshold) {
      widget.onVote(_dragOffset > 0);
    } else {
      setState(() {
        _dragOffset = 0;
        _isDragging = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final rotationAngle = _dragOffset / 800;
    final opacity = (1 - (_dragOffset.abs() / 400)).clamp(0.5, 1.0);

    return GestureDetector(
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      onHorizontalDragEnd: _onHorizontalDragEnd,
      child: Transform.translate(
        offset: Offset(_dragOffset, 0),
        child: Transform.rotate(
          angle: rotationAngle,
          child: Opacity(
            opacity: opacity,
            child: Card(
              elevation: 8,
              margin: const EdgeInsets.all(Spacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        if (widget.movie.posterPath != null)
                          Image.network(
                            ApiConstants.getImageUrl(widget.movie.posterPath),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.movie, size: 100),
                          )
                        else
                          const Icon(Icons.movie, size: 100),
                        if (_isDragging)
                          Container(
                            decoration: BoxDecoration(
                              color: _dragOffset > 0
                                  ? Colors.green.withOpacity(0.3)
                                  : Colors.red.withOpacity(0.3),
                            ),
                            child: Center(
                              child: Icon(
                                _dragOffset > 0
                                    ? Icons.thumb_up
                                    : Icons.thumb_down,
                                size: 64,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(Spacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.movie.title,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: Spacing.sm),
                        if (widget.movie.releaseDate != null) ...[
                          Text(
                            'Release Date: ${widget.movie.releaseDate}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: Spacing.xs),
                        ],
                        if (widget.movie.voteAverage != null) ...[
                          Text(
                            'Rating: ${widget.movie.voteAverage!.toStringAsFixed(1)}/10',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: Spacing.sm),
                        ],
                        if (widget.movie.overview != null)
                          Text(
                            widget.movie.overview!,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
