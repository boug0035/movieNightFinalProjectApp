import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_models/welcome_view_model.dart';
import '../../core/constants/spacing_constants.dart';
import 'widgets/welcome_button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WelcomeViewModel>().initializeDeviceId();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Night'),
        centerTitle: true,
      ),
      body: Consumer<WelcomeViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(Spacing.screenPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.movie_outlined,
                    size: 64,
                  ),
                  const SizedBox(height: Spacing.xl),
                  Text(
                    'Welcome to Movie Night!',
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: Spacing.xl),
                  WelcomeButton(
                    icon: Icons.add,
                    label: 'Start New Session',
                    onPressed: () {
                      Navigator.pushNamed(context, '/share-code');
                    },
                  ),
                  const SizedBox(height: Spacing.md),
                  WelcomeButton(
                    icon: Icons.input,
                    label: 'Join Session',
                    onPressed: () {
                      Navigator.pushNamed(context, '/enter-code');
                    },
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
