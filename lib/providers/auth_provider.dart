// auth_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:tutorconnect/providers/user_provider.dart' as user_prov;
import '../services/auth_service.dart';

/// Proveedor del servicio de autenticación
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

/// Stream del estado de autenticación (usuario actual o null)
final authStateProvider = StreamProvider<fb_auth.User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
});

/// Proveedor para iniciar sesión con email y contraseña
final signInProvider =
    FutureProvider.family<fb_auth.User?, Map<String, String>>((ref, credentials) async {
  final authService = ref.watch(authServiceProvider);
  final userService = ref.watch(user_prov.userServiceProvider);

  final email = credentials['email'] ?? '';
  final password = credentials['password'] ?? '';

  // Ahora pasamos userService directamente al método
  final user = await authService.signInWithEmailPassword(email, password, userService);

  return user;
});

/// Proveedor para cerrar sesión
final signOutProvider = FutureProvider<void>((ref) async {
  final authService = ref.watch(authServiceProvider);
  await authService.signOut();
});
