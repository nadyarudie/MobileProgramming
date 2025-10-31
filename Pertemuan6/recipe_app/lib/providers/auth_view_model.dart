// lib/providers/auth_view_model.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';
import 'auth_state.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final authViewModelProvider =
    StateNotifierProvider<AuthViewModel, AuthState>((ref) {
  final svc = ref.read(authServiceProvider);
  final vm = AuthViewModel(svc);
  vm.restoreSession(); // kalau nanti pakai SharedPreferences, akan aktif di sini
  return vm;
});

class AuthViewModel extends StateNotifier<AuthState> {
  final AuthService _svc;

  AuthViewModel(this._svc) : super(const AuthState());

  Future<void> login(String username, String password) async {
    state = state.copyWith(loading: true, error: null);
    try {
      // ✅ FIX: Use the injected AuthService (_svc) to handle login.
      final bool loginSuccessful = await _svc.login(username, password);

      if (loginSuccessful) {
        state = state.copyWith(loading: false, user: username);
      } else {
        state = state.copyWith(loading: false, error: 'Login gagal');
      }
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<void> logout() async {
    await _svc.logout();
    state = state.copyWith(user: null);
  }

  Future<void> restoreSession() async {
    final u = await _svc.restoreUser();
    state = state.copyWith(user: u);
  }
}