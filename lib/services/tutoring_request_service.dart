import 'package:tutorconnect/repositories/tutoring_request/tutoring_request_repository.dart';
import '../models/tutoring_request.dart';

class TutoringRequestService {
  final TutoringRequestRepository _repository;

  TutoringRequestService(this._repository);

  Future<TutoringRequest?> getTutoringRequestById(String id) async {
    return await _repository.getTutoringRequestById(id);
  }

  Future<List<TutoringRequest>> getAllTutoringRequests() async {
    return await _repository.getAllTutoringRequests();
  }

  Future<List<TutoringRequest>> getTutoringRequestsByStudentId(String studentId) async {
    return await _repository.getTutoringRequestsByStudentId(studentId);
  }

  Future<void> addTutoringRequest(TutoringRequest tutoringRequest) async {
    await _repository.addTutoringRequest(tutoringRequest);
  }

  Future<void> updateTutoringRequest(TutoringRequest tutoringRequest) async {
    await _repository.updateTutoringRequest(tutoringRequest);
  }
}
