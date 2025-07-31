// user_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/data/firebase_user_datasource.dart';
import 'package:tutorconnect/repositories/user/user_repository.dart';
import 'package:tutorconnect/repositories/user/user_repository_impl.dart';

import '../models/user.dart';
import '../services/user_service.dart';

// 1. Proveedor del DataSource concreto
final firebaseUserDataSourceProvider = Provider<FirebaseUserDataSource>((ref) {
  return FirebaseUserDataSource();
});

// 2. Proveedor del Repositorio que usa el DataSource
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final dataSource = ref.read(firebaseUserDataSourceProvider);
  return UserRepositoryImpl(dataSource: dataSource);
});

// 3. Proveedor del Service que usa el Repositorio
final userServiceProvider = Provider<UserService>((ref) {
  final repository = ref.read(userRepositoryProvider);
  return UserService(repository);
});

// 4. StateNotifier para manejar estado y acciones
class UserNotifier extends StateNotifier<List<User>> {
  final UserService _service;

  UserNotifier(this._service) : super([]) {
    loadUsers();
  }

  Future<void> loadUsers() async {
    final users = await _service.getAllUsers();
    // ignore: avoid_print
    print('Users loaded: ${users.length}');
    state = users;
  }

  Future<void> updateUser(User user) async {
    await _service.updateUser(user);
    await loadUsers();
  }

  Future<User?> getUserById(String id) async {
    return await _service.getUserById(id);
  }
}

// 5. Proveedor del StateNotifier
final userProvider = StateNotifierProvider<UserNotifier, List<User>>((ref) {
  final service = ref.read(userServiceProvider);
  return UserNotifier(service);
});
