import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/data/firebase_subject_datasource.dart';
import 'package:tutorconnect/models/subject.dart';
import 'package:tutorconnect/repositories/subject/subject_repository.dart';
import 'package:tutorconnect/repositories/subject/subject_repository_impl.dart';
import 'package:tutorconnect/services/subject_service.dart';

// 1. Proveedor del DataSource concreto
final firebaseSubjectDataSourceProvider = Provider<FirebaseSubjectDataSource>((ref) {
  return FirebaseSubjectDataSource();
});

// 2. Proveedor del Repositorio que usa el DataSource
final subjectRepositoryProvider = Provider<SubjectRepository>((ref) {
  final dataSource = ref.read(firebaseSubjectDataSourceProvider);
  return SubjectRepositoryImpl(dataSource: dataSource);
});

// 3. Proveedor del Service que usa el Repositorio
final subjectServiceProvider = Provider<SubjectService>((ref) {
  final repository = ref.read(subjectRepositoryProvider);
  return SubjectService(repository);
});

// 4. StateNotifier para manejar estado y acciones
class SubjectNotifier extends StateNotifier<List<Subject>> {
  final SubjectService _service;

  SubjectNotifier(this._service) : super([]) {
    loadSubjects();
  }

  Future<void> loadSubjects() async {
    final subjects = await _service.getAllSubjects();
    state = subjects;
  }

  Future<Subject?> getSubjectById(String id) async {
    return await _service.getSubjectById(id);
  }
}

// 5. Proveedor del StateNotifier
final subjectProvider = StateNotifierProvider<SubjectNotifier, List<Subject>>((ref) {
  final service = ref.read(subjectServiceProvider);
  return SubjectNotifier(service);
});
