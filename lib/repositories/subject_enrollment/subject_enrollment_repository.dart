import '../../models/subject_enrollment.dart';

abstract class SubjectEnrollmentRepository {
  Future<SubjectEnrollment?> getSubjectEnrollmentById(String id);

  Future<List<SubjectEnrollment>> getAllSubjectEnrollments();

  Future<List<SubjectEnrollment>> getSubjectEnrollmentsByStudentId(String studentId);

  Future<List<SubjectEnrollment>> getSubjectEnrollmentsBySubjectId(String subjectId);
}
