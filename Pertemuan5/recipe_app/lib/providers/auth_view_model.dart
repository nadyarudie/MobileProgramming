import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';
import 'auth_state.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

/// Manages authentication state and logic.
final authViewModelProvider =
    StateNotifierProvider<AuthViewModel, AuthState>((ref) {
  final svc = ref.read(authServiceProvider);
  final vm = AuthViewModel(svc);

  Future.microtask(() async {
    if (vm.mounted) {
      await vm.restoreSession();
    }
  });

  return vm;
});

class AuthViewModel extends StateNotifier<AuthState> {
  final AuthService _svc;

  AuthViewModel(this._svc) : super(const AuthState());

  Future<void> login(String username, String password) async {
    if (!mounted) return;
    state = state.copyWith(loading: true, error: null);
    try {
      final ok = await _svc.login(username, password);
      if (!mounted) return;

      if (ok) {
        state = state.copyWith(loading: false, user: username);
      } else {
        state = state.copyWith(loading: false, error: 'Login gagal');
      }
    } catch (e) {
      if (!mounted) return;
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<void> logout() async {
    try {
      await _svc.logout();
    } finally {
      if (!mounted) return;
      state = state.copyWith(user: null);
    }
  }

  Future<void> restoreSession() async {
    try {
      final u = await _svc.restoreUser();
      if (!mounted) return;
      state = state.copyWith(user: u);
    } catch (e) {
      if (!mounted) return;
      state = state.copyWith(error: 'Gagal memulihkan sesi: $e');
    }
  }
}