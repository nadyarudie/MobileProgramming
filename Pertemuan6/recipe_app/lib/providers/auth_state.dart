class AuthState {
  final bool loading;
  final String? user; // username
  final String? error;

  const AuthState({this.loading = false, this.user, this.error});

  AuthState copyWith({
    bool? loading,
    String? user,
    String? error,
  }) {
    return AuthState(
      loading: loading ?? this.loading,
      user: user,
      error: error,
    );
  }
}
