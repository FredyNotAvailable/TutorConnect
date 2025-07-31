import 'package:tutorconnect/data/firebase_subject_datasource.dart';

import '../../models/subject.dart';
import 'subject_repository.dart';

class SubjectRepositoryImpl implements SubjectRepository {
  final FirebaseSubjectDataSource dataSource;

  SubjectRepositoryImpl({required this.dataSource});

  @override
  Future<Subject?> getSubjectById(String id) {
    return dataSource.getSubjectById(id);
  }

  @override
  Future<List<Subject>> getAllSubjects() {
    return dataSource.getAllSubjects();
  }
}
