import '../../models/classroom.dart';

abstract class ClassroomRepository {
  Future<Classroom?> getClassroomById(String id);

  Future<List<Classroom>> getAllClassrooms();
}
