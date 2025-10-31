import 'package:flutter/material.dart';

// ✅ Diubah menjadi StatefulWidget untuk mengelola lifecycle controller
class SearchBar extends StatefulWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const SearchBar({super.key, required this.value, required this.onChanged});

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  // ✅ Controller dibuat sekali dan di-dispose dengan benar
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(covariant SearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // ✅ Sinkronkan controller jika state dari parent berubah (misal: clear filter)
    if (widget.value != _controller.text) {
      _controller.text = widget.value;
      // Pindahkan cursor ke akhir
      _controller.selection =
          TextSelection.fromPosition(TextPosition(offset: _controller.text.length));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller, // ✅ Gunakan controller yang sudah ada
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        hintText: 'Cari resep...',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}