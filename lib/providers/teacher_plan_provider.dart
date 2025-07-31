import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/data/firebase_teacher_plan_datasource.dart';
import 'package:tutorconnect/repositories/teacher_plan/teacher_plan_repository.dart';
import 'package:tutorconnect/repositories/teacher_plan/teacher_plan_repository_impl.dart';
import 'package:tutorconnect/services/teacher_plan_service.dart';
import 'package:tutorconnect/models/teacher_plan.dart';

/// Proveedor del DataSource concreto
final firebaseTeacherPlanDataSourceProvider = Provider<FirebaseTeacherPlanDataSource>((ref) {
  return FirebaseTeacherPlanDataSource();
});

/// Proveedor del Repositorio que usa el DataSource
final teacherPlanRepositoryProvider = Provider<TeacherPlanRepository>((ref) {
  final dataSource = ref.read(firebaseTeacherPlanDataSourceProvider);
  return TeacherPlanRepositoryImpl(dataSource: dataSource);
});

/// Proveedor del Service que usa el Repositorio
final teacherPlanServiceProvider = Provider<TeacherPlanService>((ref) {
  final repository = ref.read(teacherPlanRepositoryProvider);
  return TeacherPlanService(repository);
});

/// Obtener un TeacherPlan por ID
final teacherPlanByIdProvider = FutureProvider.family<TeacherPlan?, String>((ref, id) {
  final service = ref.read(teacherPlanServiceProvider);
  return service.getTeacherPlanById(id);
});

/// Obtener todos los TeacherPlans
final allTeacherPlansProvider = FutureProvider<List<TeacherPlan>>((ref) {
  final service = ref.read(teacherPlanServiceProvider);
  return service.getAllTeacherPlans();
});

/// Obtener TeacherPlans activos por careerId
final activeTeacherPlansByCareerProvider = FutureProvider.family<List<TeacherPlan>, String>((ref, careerId) {
  final service = ref.read(teacherPlanServiceProvider);
  return service.getActiveTeacherPlansByCareerId(careerId);
});

/// Obtener TeacherPlans por teacherId
final teacherPlansByTeacherIdProvider = FutureProvider.family<List<TeacherPlan>, String>((ref, teacherId) {
  final service = ref.read(teacherPlanServiceProvider);
  return service.getTeacherPlansByTeacherId(teacherId);
});
