// lib/widgets/search_bar.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/recipe_provider.dart';

class SearchBar extends ConsumerWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextField(
      onChanged: (query) {
        // Widget ini MENGUBAH state pencarian setiap kali pengguna mengetik
        ref.read(searchQueryProvider.notifier).state = query;
      },
      decoration: InputDecoration(
        hintText: 'Cari resep lezat...',
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
        prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 24),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}