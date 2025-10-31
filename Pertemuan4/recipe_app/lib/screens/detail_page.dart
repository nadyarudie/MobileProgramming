// lib/screens/detail_page.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../models/recipe.dart';

class RecipeDetailPage extends StatefulWidget {
  final Recipe recipe;
  const RecipeDetailPage({super.key, required this.recipe});

  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  late List<String> _steps;      // langkah-langkah hasil split dari instructions (String)
  late List<bool> _stepStatus;   // status checkbox per langkah

  @override
  void initState() {
    super.initState();

    // Ubah String instructions → List<String> steps
    final raw = widget.recipe.instructions;
    // Coba pecah pakai newline; jika tidak ada, pecah berdasarkan titik+spasi.
    final parts = raw.contains('\n')
        ? raw.split('\n')
        : raw.split(RegExp(r'\.\s+'));

    _steps = parts
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    _stepStatus = List<bool>.filled(_steps.length, false);
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/animations/Prepare Food.json',
                width: 150,
                height: 150,
                repeat: false,
              ),
              const SizedBox(height: 20),
              Text(
                'Luar Biasa!',
                style: GoogleFonts.montserrat(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Anda telah menyelesaikan resep ini. Selamat menikmati!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ],
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('OK', style: TextStyle(fontSize: 16, color: Colors.white)),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300.0,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 1,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.white.withValues(alpha: 0.8),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: widget.recipe.id, // Hero tag unik
                child: Image.network(
                  widget.recipe.image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Optional: ganti dengan aset placeholder kamu
                    return Image.asset('assets/images/placeholder.png', fit: BoxFit.cover);
                  },
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.recipe.name,
                    style: GoogleFonts.montserrat(fontSize: 28, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildInfoPill(Icons.star_rounded, widget.recipe.rating.toStringAsFixed(1), 'Rating', Colors.amber),
                      _buildInfoPill(Icons.timer_outlined, '${widget.recipe.cookTimeMinutes} min', 'Durasi', Colors.blue),
                      _buildInfoPill(Icons.whatshot_outlined, widget.recipe.difficulty, 'Level', Colors.red),
                    ],
                  ),

                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),

                  Text('Bahan-bahan', style: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: widget.recipe.ingredients.map((ingredient) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Text('•  $ingredient', style: const TextStyle(fontSize: 16, height: 1.5)),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),

                  Text('Langkah-langkah', style: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _steps.length,
                    itemBuilder: (context, index) {
                      final step = _steps[index];
                      final done = _stepStatus[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${index + 1}.',
                              style: GoogleFonts.montserrat(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                step,
                                style: TextStyle(
                                  fontSize: 16,
                                  height: 1.5,
                                  color: done ? Colors.grey : Colors.black,
                                  decoration: done ? TextDecoration.lineThrough : TextDecoration.none,
                                ),
                              ),
                            ),
                            Checkbox(
                              value: done,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  _stepStatus[index] = newValue ?? false;
                                });
                                if (_stepStatus.isNotEmpty &&
                                    _stepStatus.every((s) => s)) {
                                  _showCompletionDialog();
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoPill(IconData icon, String value, String label, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(value, style: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        const Text(' ', style: TextStyle(fontSize: 0)), // spacer kecil untuk konsistensi
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
      ],
    );
  }
}
