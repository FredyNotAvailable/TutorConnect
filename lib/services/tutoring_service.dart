import '../models/tutoring.dart';
import '../repositories/tutoring/tutoring_repository.dart';

class TutoringService {
  final TutoringRepository _repository;

  TutoringService(this._repository);

  Future<Tutoring?> getTutoringById(String id) {
    return _repository.getTutoringById(id);
  }

  Future<List<Tutoring>> getAllTutorings() {
    return _repository.getAllTutorings();
  }

  Future<List<Tutoring>> getTutoringsByTeacherId(String teacherId) {
    return _repository.getTutoringsByTeacherId(teacherId);
  }

  Future<List<Tutoring>> getTutoringsByStudentId(String studentId) {
    return _repository.getTutoringsByStudentId(studentId);
  }

  Future<Tutoring> addTutoring(Tutoring tutoring) {
    return _repository.addTutoring(tutoring);
  }

  Future<void> updateTutoring(Tutoring tutoring) {
    return _repository.updateTutoring(tutoring);
  }
}
