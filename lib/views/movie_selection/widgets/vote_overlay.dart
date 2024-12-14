import 'package:flutter/material.dart';
import '../../../core/constants/spacing_constants.dart';

class VoteOverlay extends StatelessWidget {
  final bool vote;

  const VoteOverlay({
    super.key,
    required this.vote,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      color: vote ? Colors.green.withOpacity(0.3) : Colors.red.withOpacity(0.3),
      child: Center(
        child: Icon(
          vote ? Icons.thumb_up : Icons.thumb_down,
          size: Spacing.xxl,
          color: vote ? Colors.green : Colors.red,
        ),
      ),
    );
  }
}
