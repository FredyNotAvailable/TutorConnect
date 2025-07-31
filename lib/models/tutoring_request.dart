import 'package:cloud_firestore/cloud_firestore.dart';

enum TutoringRequestStatus {
  pending,
  accepted,
  rejected,
}

class TutoringRequest {
  final String id;
  final DateTime? responseAt;
  final DateTime sentAt;
  final TutoringRequestStatus status;
  final String studentId;
  final String tutoringId;

  TutoringRequest({
    required this.id,
    this.responseAt,
    required this.sentAt,
    required this.status,
    required this.studentId,
    required this.tutoringId,
  });

  factory TutoringRequest.fromMap(Map<String, dynamic> map, String documentId) {
    return TutoringRequest(
      id: documentId,
      responseAt: map['responseAt'] != null ? (map['responseAt'] as Timestamp).toDate() : null,
      sentAt: (map['sentAt'] as Timestamp).toDate(),
      status: _stringToStatus(map['status'] ?? 'pending'),
      studentId: map['studentId'] ?? '',
      tutoringId: map['tutoringId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'responseAt': responseAt,
      'sentAt': sentAt,
      'status': _statusToString(status),
      'studentId': studentId,
      'tutoringId': tutoringId,
    };
  }

  static TutoringRequestStatus _stringToStatus(String status) {
    switch (status) {
      case 'accepted':
        return TutoringRequestStatus.accepted;
      case 'rejected':
        return TutoringRequestStatus.rejected;
      case 'pending':
      default:
        return TutoringRequestStatus.pending;
    }
  }

  static String _statusToString(TutoringRequestStatus status) {
    switch (status) {
      case TutoringRequestStatus.accepted:
        return 'accepted';
      case TutoringRequestStatus.rejected:
        return 'rejected';
      case TutoringRequestStatus.pending:
        return 'pending';
    }
  }
}
