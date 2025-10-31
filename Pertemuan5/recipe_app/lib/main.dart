import 'package:flutter/material.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/auth_view_model.dart';
import 'routes.dart';

void main() async {
  /// Ensure Flutter bindings are initialized before running the app.
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();

  /// Create a ProviderContainer to interact with providers before runApp.
  final container = ProviderContainer();
  
  /// Restore the user session from persistent storage.
  await container.read(authViewModelProvider.notifier).restoreSession();
  
  /// Determine the initial authentication state after restoration.
  final initialAuthState = container.read(authViewModelProvider);

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: MyApp(isLoggedIn: initialAuthState.user != null),
    ),
  );
}

class MyApp extends StatelessWidget {
  /// Determines the initial route based on whether the user is logged in.
  final bool isLoggedIn;
  
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Resep Makanan',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange, 
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.montserratTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      /// Set the initial route based on the login status.
      initialRoute: isLoggedIn ? AppRoutes.home : AppRoutes.login,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}