import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import '../models/subject.dart';

class FirebaseSubjectDataSource {
  final CollectionReference subjectsCollection =
      FirebaseFirestore.instance.collection('subjects');
  final logger = Logger();

  Future<Subject?> getSubjectById(String id) async {
    try {
      final doc = await subjectsCollection.doc(id).get();
      if (doc.exists && doc.data() != null) {
        Fluttertoast.showToast(msg: 'Materia encontrada: ID=$id');
        return Subject.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      } else {
        Fluttertoast.showToast(msg: 'No existe materia con ID: $id');
      }
    } catch (e, stackTrace) {
      logger.e('Error al obtener materia', error: e, stackTrace: stackTrace);
      Fluttertoast.showToast(msg: 'Error al obtener materia: $e');
    }
    return null;
  }

  Future<List<Subject>> getAllSubjects() async {
    try {
      final snapshot = await subjectsCollection.get();
      final subjects = snapshot.docs
          .map((doc) => Subject.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
      Fluttertoast.showToast(msg: 'Se cargaron ${subjects.length} materias');
      return subjects;
    } catch (e, stackTrace) {
      logger.e('Error al obtener todas las materias', error: e, stackTrace: stackTrace);
      Fluttertoast.showToast(msg: 'Error al cargar materias: $e');
      return [];
    }
  }
}
