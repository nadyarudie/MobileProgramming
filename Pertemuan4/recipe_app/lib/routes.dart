// lib/routes.dart
import 'package:flutter/material.dart';

import 'screens/home_page.dart';
import 'screens/detail_page.dart';
import 'screens/login_page.dart'; // ← tambahkan jika kamu punya halaman login
import 'models/recipe.dart';

/// Kumpulan nama rute agar tidak hardcode string di banyak tempat.
class AppRoutes {
  static const String home = '/';
  static const String detail = '/detail';
  static const String login = '/login';
}

/// Widget mini untuk melakukan redirect ke '/' di Web tanpa mengubah UI.
/// Dipakai saat /detail dipanggil tanpa arguments.
class _RedirectToHome extends StatefulWidget {
  const _RedirectToHome();

  @override
  State<_RedirectToHome> createState() => _RedirectToHomeState();
}

class _RedirectToHomeState extends State<_RedirectToHome> {
  @override
  void initState() {
    super.initState();
    // Ganti URL jadi '/'
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.home);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Tampilan kosong sementara 1 frame; tidak mengubah layout Home kamu.
    return const SizedBox.shrink();
  }
}

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
            builder: (_) => RecipeDetailPage(recipe: args),
          );
        }
        // ❗ Jika /detail tanpa data Recipe → redirect halus ke '/'
        return MaterialPageRoute(
          settings: const RouteSettings(name: AppRoutes.home),
          builder: (_) => const _RedirectToHome(),
        );

      case AppRoutes.login:
        return MaterialPageRoute(
          settings: const RouteSettings(name: AppRoutes.login),
          builder: (_) => const LoginPage(),
        );

      default:
        // Unknown route → fallback ke Home
        return MaterialPageRoute(
          settings: const RouteSettings(name: AppRoutes.home),
          builder: (_) => const HomePage(),
        );
    }
  }
}
