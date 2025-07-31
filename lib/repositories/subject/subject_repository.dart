import '../../models/subject.dart';

abstract class SubjectRepository {
  Future<Subject?> getSubjectById(String id);

  Future<List<Subject>> getAllSubjects();
}
