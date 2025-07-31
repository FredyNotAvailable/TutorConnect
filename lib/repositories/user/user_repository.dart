// user_repository.dart

import '../../models/user.dart';

abstract class UserRepository {
  Future<User?> getUserById(String id);

  Future<List<User>> getAllUsers();

  Future<void> addUser(User user);

  Future<void> updateUser(User user);

  Future<void> deleteUser(String id);
}
