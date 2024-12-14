import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../view_models/enter_code_view_model.dart';
import '../../core/constants/spacing_constants.dart';

class EnterCodeScreen extends StatefulWidget {
  const EnterCodeScreen({super.key});

  @override
  State<EnterCodeScreen> createState() => _EnterCodeScreenState();
}

class _EnterCodeScreenState extends State<EnterCodeScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _codeController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(begin: 0.0, end: 24.0)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(_shakeController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _shakeController.reverse();
        }
      });
  }

  @override
  void dispose() {
    _codeController.dispose();
    _focusNode.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    _shakeController.forward();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(Spacing.md),
      ),
    );
  }

  Future<void> _handleSubmit(EnterCodeViewModel viewModel) async {
    if (_codeController.text.length != 4) {
      _showError('Please enter a 4-digit code');
      return;
    }

    final success = await viewModel.joinSession(_codeController.text);
    if (success && mounted) {
      Navigator.pushReplacementNamed(context, '/movie-selection');
    } else if (mounted) {
      _showError(viewModel.error ?? 'Failed to join session');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Code'),
        centerTitle: true,
      ),
      body: Consumer<EnterCodeViewModel>(
        builder: (context, viewModel, child) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(Spacing.screenPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.groups_rounded,
                    size: Spacing.xxl,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: Spacing.xl),
                  Text(
                    'Enter the code shared by your friend',
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: Spacing.xl),
                  AnimatedBuilder(
                    animation: _shakeAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(
                            _shakeAnimation.value *
                                sin(3 * 3.14159 * _shakeController.value),
                            0),
                        child: child,
                      );
                    },
                    child: TextField(
                      controller: _codeController,
                      focusNode: _focusNode,
                      decoration: InputDecoration(
                        hintText: 'Enter 4-digit code',
                        hintStyle: Theme.of(context).textTheme.bodyLarge,
                        errorText: viewModel.error,
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(Spacing.borderRadiusMd),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: Spacing.md,
                          vertical: Spacing.md,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 4,
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                letterSpacing: 8,
                              ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onChanged: (_) => viewModel.clearError(),
                      onSubmitted: (_) => _handleSubmit(viewModel),
                    ),
                  ),
                  const SizedBox(height: Spacing.xl),
                  SizedBox(
                    width: double.infinity,
                    height: Spacing.xxl,
                    child: ElevatedButton(
                      onPressed: viewModel.isLoading
                          ? null
                          : () => _handleSubmit(viewModel),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: viewModel.isLoading
                            ? SizedBox(
                                width: Spacing.lg,
                                height: Spacing.lg,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              )
                            : const Text('Join Session'),
                      ),
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
