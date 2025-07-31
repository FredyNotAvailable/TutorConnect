// firebase_user_datasource.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutorconnect/repositories/user/user_repository.dart';
import '../models/user.dart';
import 'package:logger/logger.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FirebaseUserDataSource extends UserRepository {
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');
  final logger = Logger();


@override
Future<User?> getUserById(String id) async {
  try {
    final doc = await usersCollection.doc(id).get();
    if (doc.exists && doc.data() != null) {
      Fluttertoast.showToast(msg: 'Usuario encontrado: ID=$id');
      return User.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    } else {
      Fluttertoast.showToast(msg: 'No existe documento para ID: $id');
    }
  } catch (e, stackTrace) {
    logger.e('Error al obtener usuario', error: e, stackTrace: stackTrace);
    Fluttertoast.showToast(msg: 'Error al obtener usuario: $e');
  }
  return null;
}

  @override
  Future<List<User>> getAllUsers() async {
    final querySnapshot = await usersCollection.get();
    return querySnapshot.docs
        .map((doc) => User.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  @override
  Future<void> addUser(User user) async {
    await usersCollection.add(user.toMap());
  }

  @override
  Future<void> updateUser(User user) async {
    await usersCollection.doc(user.id).update(user.toMap());
  }

  @override
  Future<void> deleteUser(String id) async {
    await usersCollection.doc(id).delete();
  }
}
