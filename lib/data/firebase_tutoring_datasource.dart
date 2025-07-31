import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import '../models/tutoring.dart';

class FirebaseTutoringDataSource {
  final CollectionReference tutoringCollection =
      FirebaseFirestore.instance.collection('tutorings');
  final logger = Logger();

  Future<Tutoring?> getTutoringById(String id) async {
    try {
      final doc = await tutoringCollection.doc(id).get();
      if (doc.exists && doc.data() != null) {
        Fluttertoast.showToast(msg: 'Tutoring found: ID=$id');
        return Tutoring.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      } else {
        Fluttertoast.showToast(msg: 'No tutoring found with ID: $id');
      }
    } catch (e, stackTrace) {
      logger.e('Error getting tutoring', error: e, stackTrace: stackTrace);
      Fluttertoast.showToast(msg: 'Error getting tutoring: $e');
    }
    return null;
  }

  Future<List<Tutoring>> getAllTutorings() async {
    try {
      final snapshot = await tutoringCollection.get();
      final tutorings = snapshot.docs
          .map((doc) => Tutoring.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
      Fluttertoast.showToast(msg: 'Loaded ${tutorings.length} tutorings');
      return tutorings;
    } catch (e, stackTrace) {
      logger.e('Error loading tutorings', error: e, stackTrace: stackTrace);
      Fluttertoast.showToast(msg: 'Error loading tutorings: $e');
      return [];
    }
  }

  Future<List<Tutoring>> getTutoringsByTeacherId(String teacherId) async {
    try {
      final querySnapshot = await tutoringCollection.where('teacherId', isEqualTo: teacherId).get();
      final tutorings = querySnapshot.docs
          .map((doc) => Tutoring.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
      Fluttertoast.showToast(msg: 'Loaded ${tutorings.length} tutorings for teacher');
      return tutorings;
    } catch (e, stackTrace) {
      logger.e('Error loading tutorings by teacher', error: e, stackTrace: stackTrace);
      Fluttertoast.showToast(msg: 'Error loading tutorings for teacher: $e');
      return [];
    }
  }

  Future<List<Tutoring>> getTutoringsByStudentId(String studentId) async {
    try {
      final querySnapshot = await tutoringCollection.where('studentIds', arrayContains: studentId).get();
      final tutorings = querySnapshot.docs
          .map((doc) => Tutoring.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
      Fluttertoast.showToast(msg: 'Loaded ${tutorings.length} tutorings for student');
      return tutorings;
    } catch (e, stackTrace) {
      logger.e('Error loading tutorings by student', error: e, stackTrace: stackTrace);
      Fluttertoast.showToast(msg: 'Error loading tutorings for student: $e');
      return [];
    }
  }

  Future<void> addTutoring(Tutoring tutoring) async {
    try {
      await tutoringCollection.add(tutoring.toMap());
      Fluttertoast.showToast(msg: 'Tutoring added');
    } catch (e, stackTrace) {
      logger.e('Error adding tutoring', error: e, stackTrace: stackTrace);
      Fluttertoast.showToast(msg: 'Error adding tutoring: $e');
    }
  }

  Future<void> updateTutoring(Tutoring tutoring) async {
    try {
      await tutoringCollection.doc(tutoring.id).update(tutoring.toMap());
      Fluttertoast.showToast(msg: 'Tutoring updated');
    } catch (e, stackTrace) {
      logger.e('Error updating tutoring', error: e, stackTrace: stackTrace);
      Fluttertoast.showToast(msg: 'Error updating tutoring: $e');
    }
  }
}
