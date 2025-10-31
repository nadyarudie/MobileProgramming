import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Menyimpan username yang sedang login; null jika belum login.
final currentUserProvider = StateProvider<String?>((ref) => null);
