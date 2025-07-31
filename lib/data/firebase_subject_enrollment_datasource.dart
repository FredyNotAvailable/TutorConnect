import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import '../models/subject_enrollment.dart';

class FirebaseSubjectEnrollmentDataSource {
  final CollectionReference subjectEnrollmentsCollection =
      FirebaseFirestore.instance.collection('subject_enrollments');
  final logger = Logger();

  Future<SubjectEnrollment?> getSubjectEnrollmentById(String id) async {
    try {
      final doc = await subjectEnrollmentsCollection.doc(id).get();
      if (doc.exists && doc.data() != null) {
        Fluttertoast.showToast(msg: 'Matrícula de materia encontrada: ID=$id');
        return SubjectEnrollment.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      } else {
        Fluttertoast.showToast(msg: 'No existe matrícula con ID: $id');
      }
    } catch (e, stackTrace) {
      logger.e('Error al obtener matrícula', error: e, stackTrace: stackTrace);
      Fluttertoast.showToast(msg: 'Error al obtener matrícula: $e');
    }
    return null;
  }

  Future<List<SubjectEnrollment>> getAllSubjectEnrollments() async {
    try {
      final snapshot = await subjectEnrollmentsCollection.get();
      final enrollments = snapshot.docs
          .map((doc) => SubjectEnrollment.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
      Fluttertoast.showToast(msg: 'Se cargaron ${enrollments.length} matrículas');
      return enrollments;
    } catch (e, stackTrace) {
      logger.e('Error al obtener matrículas', error: e, stackTrace: stackTrace);
      Fluttertoast.showToast(msg: 'Error al cargar matrículas: $e');
      return [];
    }
  }

  Future<List<SubjectEnrollment>> getSubjectEnrollmentsByStudentId(String studentId) async {
    try {
      final querySnapshot = await subjectEnrollmentsCollection
          .where('studentId', isEqualTo: studentId)
          .orderBy('enrollmentDate', descending: true)
          .get();
      final enrollments = querySnapshot.docs
          .map((doc) => SubjectEnrollment.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
      Fluttertoast.showToast(msg: 'Se cargaron ${enrollments.length} matrículas para estudiante');
      return enrollments;
    } catch (e, stackTrace) {
      logger.e('Error al obtener matrículas por estudiante', error: e, stackTrace: stackTrace);
      Fluttertoast.showToast(msg: 'Error al cargar matrículas del estudiante: $e');
      return [];
    }
  }

  Future<List<SubjectEnrollment>> getSubjectEnrollmentsBySubjectId(String subjectId) async {
    try {
      final querySnapshot = await subjectEnrollmentsCollection
          .where('subjectId', isEqualTo: subjectId)
          .orderBy('enrollmentDate', descending: true)
          .get();
      final enrollments = querySnapshot.docs
          .map((doc) => SubjectEnrollment.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
      Fluttertoast.showToast(msg: 'Se cargaron ${enrollments.length} matrículas para materia');
      return enrollments;
    } catch (e, stackTrace) {
      logger.e('Error al obtener matrículas por materia', error: e, stackTrace: stackTrace);
      Fluttertoast.showToast(msg: 'Error al cargar matrículas de materia: $e');
      return [];
    }
  }
}
