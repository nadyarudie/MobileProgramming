import 'package:flutter/material.dart';
import 'screens/home_page.dart';
import 'screens/detail_page.dart'; 
import 'screens/login_page.dart';
import 'screens/profile_page.dart';
import 'models/recipe.dart';
import 'screens/register_page.dart';

/// Defines static constants for app route names.
class AppRoutes {
  static const String home = '/';
  static const String detail = '/detail';
  static const String login = '/login';
  static const String profile = '/profile';
  static const String register = '/register';
}

/// A utility widget that redirects to the home route.
class _RedirectToHome extends StatefulWidget {
  const _RedirectToHome();

  @override
  State<_RedirectToHome> createState() => _RedirectToHomeState();
}

class _RedirectToHomeState extends State<_RedirectToHome> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.home);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

/// Handles the generation of routes for the application.
class AppRouter {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
        return MaterialPageRoute(
          settings: const RouteSettings(name: AppRoutes.home),
          builder: (_) => const HomePage(),
        );

      case AppRoutes.detail:
        final args = settings.arguments;
        if (args is Recipe) {
          return MaterialPageRoute(
            settings: const RouteSettings(name: AppRoutes.detail),
            // PERBAIKAN: Gunakan RecipeDetailPage sesuai nama class di detail_page.dart
            builder: (_) => RecipeDetailPage(recipe: args), 
          );
        }
        return MaterialPageRoute(
          settings: const RouteSettings(name: AppRoutes.home),
          builder: (_) => const _RedirectToHome(),
        );

      case AppRoutes.login:
        return MaterialPageRoute(
          settings: const RouteSettings(name: AppRoutes.login),
          builder: (_) => const LoginPage(),
        );

      case AppRoutes.register:
        return MaterialPageRoute(
          settings: const RouteSettings(name: AppRoutes.register),
          builder: (_) => const RegisterPage(),
        );

      case AppRoutes.profile:
        return MaterialPageRoute(
          settings: const RouteSettings(name: AppRoutes.profile),
          builder: (_) => const ProfilePage(),
        );

      default:
        // Fallback for any unknown routes is the home page.
        return MaterialPageRoute(
          settings: const RouteSettings(name: AppRoutes.home),
          builder: (_) => const HomePage(),
        );
    }
  }
}