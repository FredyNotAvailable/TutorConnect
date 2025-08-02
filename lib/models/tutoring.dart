import 'package:cloud_firestore/cloud_firestore.dart';

enum TutoringStatus {
  active,
  finished,
  canceled,
}

class Tutoring {
  final String id;               // ID único de la tutoría
  final String classroomId;      // ID del aula donde se realizará la tutoría
  final DateTime createdAt;      // Fecha y hora en que se creó la tutoría
  final DateTime date;           // Fecha de la tutoría
  final String startTime;        // Hora de inicio (formato "HH:mm")
  final String endTime;          // Hora de fin (formato "HH:mm")
  final String notes;            // Notas o comentarios adicionales sobre la tutoría
  final TutoringStatus status;   // Estado de la tutoría (activo, finalizada, cancelada)
  final List<String> studentIds; // Lista de IDs de los estudiantes inscritos o invitados
  final String subjectId;        // ID de la materia o asignatura
  final String teacherId;        // ID del docente que imparte la tutoría
  final String topic;            // Tema o asunto que se tratará en la tutoría

  Tutoring({
    required this.id,
    required this.classroomId,
    required this.createdAt,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.notes,
    required this.status,
    required this.studentIds,
    required this.subjectId,
    required this.teacherId,
    required this.topic,
  });

  factory Tutoring.fromMap(Map<String, dynamic> map, String documentId) {
    return Tutoring(
      id: documentId,
      classroomId: map['classroomId'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      date: (map['date'] as Timestamp).toDate(),
      startTime: map['startTime'] ?? '',
      endTime: map['endTime'] ?? '',
      notes: map['notes'] ?? '',
      status: _stringToStatus(map['status'] ?? 'active'),
      studentIds: List<String>.from(map['studentIds'] ?? []),
      subjectId: map['subjectId'] ?? '',
      teacherId: map['teacherId'] ?? '',
      topic: map['topic'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'classroomId': classroomId,
      'createdAt': createdAt,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'notes': notes,
      'status': _statusToString(status),
      'studentIds': studentIds,
      'subjectId': subjectId,
      'teacherId': teacherId,
      'topic': topic,
    };
  }

  static TutoringStatus _stringToStatus(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return TutoringStatus.active;
      case 'finished':
        return TutoringStatus.finished;
      case 'canceled':
        return TutoringStatus.canceled;
      default:
        return TutoringStatus.active;
    }
  }

  static String _statusToString(TutoringStatus status) {
    return status.toString().split('.').last;
  }
}
