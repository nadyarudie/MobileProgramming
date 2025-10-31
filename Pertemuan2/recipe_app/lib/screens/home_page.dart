// lib/screens/home_page.dart

import 'package:flutter/material.dart' hide SearchBar;
import 'package:google_fonts/google_fonts.dart';
import '../widgets/category_chips_bar.dart';
import '../widgets/recipe_list_view.dart';
import '../widgets/search_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Halo, Sahabat Masak!',
                    style: GoogleFonts.montserrat(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Temukan resep favoritmu di sini',
                    style: TextStyle(fontSize: 18, color: Colors.grey, letterSpacing: 0.5),
                  ),
                  const SizedBox(height: 25),
                  // Menggunakan Widget SearchBar yang baru
                  const SearchBar(),
                ],
              ),
            ),
            
            // Menggunakan Widget CategoryChipsBar yang baru
            const CategoryChipsBar(),

            const Padding(
              padding: EdgeInsets.fromLTRB(20.0, 25.0, 20.0, 15.0),
              child: Text(
                'Rekomendasi Populer',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ),
            
            // Menggunakan Widget RecipeListView yang baru
            const Expanded(
              child: RecipeListView(),
            ),
          ],
        ),
      ),
    );
  }
}