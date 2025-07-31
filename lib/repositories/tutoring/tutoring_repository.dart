import '../../models/tutoring.dart';

abstract class TutoringRepository {
  Future<Tutoring?> getTutoringById(String id);

  Future<List<Tutoring>> getAllTutorings();

  Future<List<Tutoring>> getTutoringsByTeacherId(String teacherId);

  Future<List<Tutoring>> getTutoringsByStudentId(String studentId);

  Future<void> addTutoring(Tutoring tutoring);

  Future<void> updateTutoring(Tutoring tutoring);
}
