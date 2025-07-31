import '../../models/tutoring_request.dart';

abstract class TutoringRequestRepository {
  Future<TutoringRequest?> getTutoringRequestById(String id);

  Future<List<TutoringRequest>> getAllTutoringRequests();

  Future<List<TutoringRequest>> getTutoringRequestsByStudentId(String studentId);

  Future<void> addTutoringRequest(TutoringRequest tutoringRequest);

  Future<void> updateTutoringRequest(TutoringRequest tutoringRequest);

}
