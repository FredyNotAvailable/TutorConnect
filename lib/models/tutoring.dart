import 'package:cloud_firestore/cloud_firestore.dart';

enum TutoringStatus {
  active,
  finished,
  canceled,
}

class Tutoring {
  final String id;
  final String classroomId;
  final DateTime createdAt;
  final DateTime date;
  final String startTime; // format "HH:mm"
  final String endTime;   // format "HH:mm"
  final String notes;
  final TutoringStatus status;
  final List<String> studentIds;
  final String subjectId;
  final String teacherId;
  final String topic;

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
