import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthStatus {
  authenticated,
  unauthenticated,
  loading,
}

class AuthNotifier extends Notifier<AuthStatus> {
  @override
  AuthStatus build() {
    return AuthStatus.unauthenticated;
  }

  void login() {
    state = AuthStatus.authenticated;
  }

  void logout() {
    state = AuthStatus.unauthenticated;
  }
}

final authProvider =
NotifierProvider<AuthNotifier, AuthStatus>(
  AuthNotifier.new,
);