import 'package:flutter/material.dart';
import 'package:movie_night/view_models/enter_code_view_model.dart';
import 'package:movie_night/view_models/movie_selection_view_model.dart';
import 'package:movie_night/views/enter_code/enter_code_screen.dart';
import 'package:movie_night/views/movie_selection/movie_selection_screen.dart';
import 'package:movie_night/views/splash/splash_screen.dart';
import 'package:movie_night/views/welcome/share_code/share_code_screen.dart';

import 'package:provider/provider.dart';
import 'view_models/welcome_view_model.dart';
import 'views/welcome/welcome_screen.dart';

import 'view_models/share_code_view_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WelcomeViewModel()),
        ChangeNotifierProvider(create: (_) => ShareCodeViewModel()),
        ChangeNotifierProvider(create: (_) => EnterCodeViewModel()),
        ChangeNotifierProvider(create: (_) => MovieSelectionViewModel()),
      ],
      child: MaterialApp(
        title: 'Movie Night',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          textTheme: const TextTheme(
            headlineLarge: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
            headlineMedium: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            bodyLarge: TextStyle(
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ),
        home: const CustomSplashScreen(),
        routes: {
          '/welcome': (context) => const WelcomeScreen(),
          '/share-code': (context) => const ShareCodeScreen(),
          '/enter-code': (context) => const EnterCodeScreen(),
          '/movie-selection': (context) => const MovieSelectionScreen(),
        },
      ),
    );
  }
}
