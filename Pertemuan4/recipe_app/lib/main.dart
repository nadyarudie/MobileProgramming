import 'package:flutter/material.dart';
import 'package:url_strategy/url_strategy.dart'; // supaya URL web tanpa #
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'routes.dart';

void main() {
  setPathUrlStrategy(); // ✅ aktifkan URL clean tanpa # di web
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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

      // 🚀 Sekarang mulai dari halaman login
      initialRoute: AppRoutes.login,

      // Gunakan router yang kamu definisikan di routes.dart
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
