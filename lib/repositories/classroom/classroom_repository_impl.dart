import 'package:tutorconnect/data/firebase_classroom_datasource.dart';

import '../../models/classroom.dart';
import 'classroom_repository.dart';

class ClassroomRepositoryImpl implements ClassroomRepository {
  final FirebaseClassroomDataSource dataSource;

  ClassroomRepositoryImpl({required this.dataSource});

  @override
  Future<Classroom?> getClassroomById(String id) {
    return dataSource.getClassroomById(id);
  }

  @override
  Future<List<Classroom>> getAllClassrooms() {
    return dataSource.getAllClassrooms();
  }
}
