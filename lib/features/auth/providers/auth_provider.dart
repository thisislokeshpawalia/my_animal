import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/auth_repository.dart';

enum AuthStatus {
  authenticated,
  unauthenticated,
  loading,
}

final authRepositoryProvider = Provider((ref) => AuthRepository());

class AuthNotifier extends AsyncNotifier<AuthStatus> {
  @override
  Future<AuthStatus> build() async {
    return _checkAuthStatus();
  }

  Future<AuthStatus> _checkAuthStatus() async {
    final repo = ref.read(authRepositoryProvider);
    final isAuth = await repo.isAuthenticated();
    return isAuth ? AuthStatus.authenticated : AuthStatus.unauthenticated;
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);
      await repo.login(email, password);
      return AuthStatus.authenticated;
    });
  }

  Future<void> register(String email, String password, String name) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);
      await repo.register(email, password, name);
      return AuthStatus.authenticated;
    });
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    final repo = ref.read(authRepositoryProvider);
    await repo.logout();
    state = const AsyncValue.data(AuthStatus.unauthenticated);
  }
}

final authProvider = AsyncNotifierProvider<AuthNotifier, AuthStatus>(
  AuthNotifier.new,
);