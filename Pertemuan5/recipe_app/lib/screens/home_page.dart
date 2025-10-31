// lib/screens/home_page.dart

import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/recipe_state.dart';
import '../providers/recipe_view_model.dart';
import '../providers/auth_view_model.dart';

import '../widgets/category_chips_bar.dart';
import '../widgets/recipe_list_view.dart';
import '../widgets/search_bar.dart';
import '../routes.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipeState = ref.watch(recipeViewModelProvider);
    final recipeVM = ref.read(recipeViewModelProvider.notifier);
    final authState = ref.watch(authViewModelProvider);
    final username = authState.user ?? 'User';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== HEADER =====
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Halo, Sahabat Masak!',
                            maxLines: 1,
                            style: GoogleFonts.montserrat(
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // ✅ Menu profil sekarang akan ada di dalam widget _ProfileMenu
                      _ProfileMenu(username: username),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Temukan resep favoritmu di sini',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 18),
                  // Gunakan SearchBar yang sudah diperbaiki
                  SearchBar(
                    value: recipeState.query,
                    onChanged: recipeVM.setQuery,
                  ),
                ],
              ),
            ),
            
            const CategoryChipsBar(),

            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 18.0, 10.0, 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Rekomendasi Populer',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  IconButton(
                    icon: const Icon(Icons.sort, color: Colors.black54),
                    onPressed: () async {
                      final selected = await showDialog<SortOption>(
                        context: context,
                        builder: (_) => SortDialog(initialSortOption: recipeState.sort),
                      );
                      if (selected != null) {
                        recipeVM.setSort(selected);
                        final label = selected == SortOption.rating ? 'Rating Tertinggi' : 'Durasi Tercepat';
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Resep diurutkan berdasarkan $label'), duration: const Duration(seconds: 2)),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),

            Expanded(
              child: RecipeListView(
                loading: recipeState.loading,
                error: recipeState.error,
                recipes: recipeState.view,
                onRefresh: () => ref.read(recipeViewModelProvider.notifier).load(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SortDialog extends StatefulWidget {
  final SortOption initialSortOption;
  const SortDialog({super.key, required this.initialSortOption});

  @override
  State<SortDialog> createState() => _SortDialogState();
}

class _SortDialogState extends State<SortDialog> {
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
          _SortTile(
            title: 'Rating Tertinggi',
            selected: _selectedOption == SortOption.rating,
            onTap: () => setState(() => _selectedOption = SortOption.rating),
          ),
          const SizedBox(height: 6),
          _SortTile(
            title: 'Durasi Tercepat',
            selected: _selectedOption == SortOption.duration,
            onTap: () => setState(() => _selectedOption = SortOption.duration),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
        TextButton(onPressed: () => Navigator.pop(context, _selectedOption), child: const Text('Terapkan')),
      ],
    );
  }
}

class _SortTile extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;
  const _SortTile({required this.title, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? Theme.of(context).primaryColor : Colors.grey,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: selected ? FontWeight.w600 : FontWeight.w400),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileMenu extends ConsumerWidget {
  final String username;
  const _ProfileMenu({required this.username});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initial = username.isNotEmpty ? username[0].toUpperCase() : 'U';

    return PopupMenuButton<String>(
      tooltip: 'Akun',
      offset: const Offset(0, 44),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          enabled: false,
          child: Row(
            children: [
              CircleAvatar(radius: 16, child: Text(initial)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  username,
                  style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem<String>(
          value: 'profile',
          child: Row(children: [Icon(Icons.person_outline, size: 22), SizedBox(width: 10), Text('Profil & Favorit')]), // Ubah teks
        ),
        const PopupMenuItem<String>(
          value: 'logout',
          child: Row(children: [Icon(Icons.logout, size: 22), SizedBox(width: 10), Text('Logout')]),
        ),
      ],
      onSelected: (value) async {
        switch (value) {
          // ✅ PERBAIKAN: Arahkan ke rute profile
          case 'profile':
            Navigator.pushNamed(context, AppRoutes.profile);
            break;
          case 'logout':
            await ref.read(authViewModelProvider.notifier).logout();
            // Pastikan context masih valid sebelum navigasi
            if (context.mounted) Navigator.pushReplacementNamed(context, AppRoutes.login);
            break;
        }
      },
      child: CircleAvatar(
        radius: 20,
        // Perbaikan: Menggunakan withOpacity
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.15),
        child: Icon(Icons.person_outline_rounded, color: Theme.of(context).primaryColor),
      ),
    );
  }
}
