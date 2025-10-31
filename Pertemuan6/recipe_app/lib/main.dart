import 'package:flutter/material.dart';
import 'package:url_strategy/url_strategy.dart'; // Untuk URL web tanpa #
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/auth_view_model.dart'; // Import ViewModel untuk restore sesi
import 'routes.dart';

// 1. Jadikan main() sebagai async
void main() async {
  // 2. Pastikan binding Flutter sudah siap
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();

  // 3. Buat ProviderContainer untuk membaca provider sebelum runApp
  final container = ProviderContainer();
  
  // 4. Panggil restoreSession untuk memuat user dari SharedPreferences
  // (Pastikan auth_view_model.dart sudah di-update)
  await container.read(authViewModelProvider.notifier).restoreSession();
  
  // 5. Ambil state awal setelah restore
  final initialAuthState = container.read(authViewModelProvider);

  runApp(
    // 6. Gunakan UncontrolledProviderScope
    UncontrolledProviderScope(
      container: container,
      child: MyApp(isLoggedIn: initialAuthState.user != null),
    ),
  );
}

class MyApp extends StatelessWidget {
  // 7. Terima status login
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Resep Makanan',
      theme: ThemeData(
        // Tema dari kode Anda sebelumnya
        primarySwatch: Colors.deepOrange, 
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.montserratTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      // 8. Tentukan halaman awal berdasarkan status login
      initialRoute: isLoggedIn ? AppRoutes.home : AppRoutes.login,

      // 9. ✅ PERBAIKAN: Panggil AppRouter, bukan AppRoutes
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
