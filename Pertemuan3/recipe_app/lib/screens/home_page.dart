// lib/screens/home_page.dart

import 'package:flutter/material.dart' hide SearchBar;
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/recipe_provider.dart';
import '../widgets/recipe_card.dart';
import '../models/recipe.dart';
import '../widgets/category_chips_bar.dart';
import '../widgets/search_bar.dart';

// Enum untuk menyimpan pilihan pengurutan
enum SortOption { rating, duration }

// DIUBAH: Menjadi ConsumerStatefulWidget untuk menangani Local State (pilihan urutan)
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  // BARU: "Ingatan" atau State Lokal untuk menyimpan pilihan urutan
  SortOption _currentSortOption = SortOption.rating; // Nilai default

  @override
  Widget build(BuildContext context) {
    // Membaca daftar resep yang sudah difilter berdasarkan KATEGORI & PENCARIAN dari Riverpod
    final filteredRecipes = ref.watch(displayedRecipesProvider);
    
    // Logika untuk mengurutkan daftar resep berdasarkan "ingatan" LOKAL
    final displayedRecipes = List<Recipe>.from(filteredRecipes); 
    if (_currentSortOption == SortOption.rating) {
      displayedRecipes.sort((a, b) => b.rating.compareTo(a.rating)); // Urutkan dari rating tertinggi
    } else {
      // Logika parsing durasi yang lebih baik
      displayedRecipes.sort((a, b) {
        return _parseDuration(a.duration).compareTo(_parseDuration(b.duration));
      });
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Halo, Sahabat Masak!', style: GoogleFonts.montserrat(fontSize: 32, fontWeight: FontWeight.w800, color: Colors.black87)),
                  const SizedBox(height: 10),
                  const Text('Temukan resep favoritmu di sini', style: TextStyle(fontSize: 18, color: Colors.grey, letterSpacing: 0.5)),
                  const SizedBox(height: 25),
                  const SearchBar(), // Widget search bar terpisah
                ],
              ),
            ),
            
            const CategoryChipsBar(), // Widget kategori terpisah

            // DIUBAH: Menambahkan tombol "Urutkan"
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 25.0, 15.0, 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Rekomendasi Populer',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  IconButton(
                    icon: const Icon(Icons.sort, color: Colors.black54),
                    onPressed: () {
                      _showSortDialog(context); // Panggil fungsi untuk menampilkan dialog
                    },
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 0),
                itemCount: displayedRecipes.length, 
                itemBuilder: (BuildContext context, int index) {
                  final recipe = displayedRecipes[index];
                  return RecipeCard(recipe: recipe);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // BARU: Fungsi parsing durasi yang lebih tangguh
  int _parseDuration(String duration) {
    final parts = duration.split(' ');
    if (parts.length != 2) return 999; // Default value jika format salah

    final value = double.tryParse(parts[0]) ?? 0.0;
    final unit = parts[1].toLowerCase();

    if (unit.startsWith('jam')) {
      return (value * 60).toInt(); // Konversi jam ke menit
    }
    return value.toInt(); // Asumsikan sisanya adalah menit
  }

  // BARU: Fungsi untuk menampilkan Alert/Dialog
  void _showSortDialog(BuildContext context) async {
    final selectedOption = await showDialog<SortOption>(
      context: context,
      builder: (BuildContext context) {
        // Menggunakan widget terpisah untuk dialog agar bisa punya state sendiri
        return SortDialog(initialSortOption: _currentSortOption);
      },
    );

    if (selectedOption != null) {
      // Memperbarui "ingatan" lokal dengan setState()
      setState(() {
        _currentSortOption = selectedOption;
      });

      // BARU: Memberikan umpan balik (feedback) setelah menerapkan filter
      final sortType = selectedOption == SortOption.rating ? 'Rating Tertinggi' : 'Durasi Tercepat';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Resep diurutkan berdasarkan $sortType'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}

// BARU: Widget khusus untuk konten Dialog (mengelola state-nya sendiri)
class SortDialog extends StatefulWidget {
  final SortOption initialSortOption;
  const SortDialog({super.key, required this.initialSortOption});

  @override
  State<SortDialog> createState() => _SortDialogState();
}

class _SortDialogState extends State<SortDialog> {
  // "Ingatan" lokal untuk menyimpan pilihan sementara di dalam dialog
  late SortOption _selectedOption;

  @override
  void initState() {
    super.initState();
    _selectedOption = widget.initialSortOption;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Urutkan Berdasarkan'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Widget untuk Opsi Pilihan (Radio Button)
          RadioListTile<SortOption>(
            title: const Text('Rating Tertinggi'),
            value: SortOption.rating,
            groupValue: _selectedOption,
            onChanged: (SortOption? value) {
              setState(() {
                _selectedOption = value!;
              });
            },
          ),
          RadioListTile<SortOption>(
            title: const Text('Durasi Tercepat'),
            value: SortOption.duration,
            groupValue: _selectedOption,
            onChanged: (SortOption? value) {
              setState(() {
                _selectedOption = value!;
              });
            },
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Batal'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: const Text('Terapkan'),
          onPressed: () => Navigator.of(context).pop(_selectedOption),
        ),
      ],
    );
  }
}