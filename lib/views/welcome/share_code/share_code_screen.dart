import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_night/core/constants/spacing_constants.dart';
import 'package:movie_night/view_models/share_code_view_model.dart';
import 'package:provider/provider.dart';
import 'widgets/code_display.dart';

class ShareCodeScreen extends StatefulWidget {
  const ShareCodeScreen({super.key});

  @override
  State<ShareCodeScreen> createState() => _ShareCodeScreenState();
}

class _ShareCodeScreenState extends State<ShareCodeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ShareCodeViewModel>().generateCode();
    });
  }

  void _copyCodeToClipboard(String code) {
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Code copied to clipboard!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Share Code'),
        centerTitle: true,
      ),
      body: Consumer<ShareCodeViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.error != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(Spacing.screenPadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      viewModel.error!,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: Spacing.lg),
                    ElevatedButton(
                      onPressed: () => viewModel.generateCode(),
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            );
          }

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(Spacing.screenPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Share this code with your friend',
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: Spacing.xl),
                  if (viewModel.session?.code != null)
                    CodeDisplay(
                      code: viewModel.session!.code!,
                      onTap: () =>
                          _copyCodeToClipboard(viewModel.session!.code!),
                    ),
                  const SizedBox(height: Spacing.xl),
                  Text(
                    'Waiting for your friend to join...',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: Spacing.xl),
                  SizedBox(
                    width: double.infinity,
                    height: Spacing.xxl,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, '/movie-selection');
                      },
                      child: const Text('Start Movie Selection'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
