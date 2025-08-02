import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/models/tutoring.dart';
import 'package:tutorconnect/models/tutoring_request.dart';
import 'package:tutorconnect/providers/tutoring_provider.dart';
import 'package:tutorconnect/providers/tutoring_request_provider.dart';
import 'package:tutorconnect/providers/user_provider.dart';
import 'package:tutorconnect/utils/helpers/student_helper.dart';
import 'package:tutorconnect/widgets/tutoring_card.dart';
import 'package:tutorconnect/routes/app_routes.dart'; // Asegúrate de tener esto

class TutoringWidget extends ConsumerStatefulWidget {
  const TutoringWidget({super.key});

  @override
  ConsumerState<TutoringWidget> createState() => _TutoringWidgetState();
}

class _TutoringWidgetState extends ConsumerState<TutoringWidget> {
  bool _loading = true;
  String? _error;
  UserRole? _currentUserRole;

  List<TutoringRequest> _studentTutoringRequests = [];

  @override
  void initState() {
    super.initState();
    _loadTutorings();
  }

  Future<void> _loadTutorings() async {
    try {
      final user = await ref.read(currentUserProvider.future);

      if (user == null) {
        setState(() {
          _error = 'No se encontró el usuario autenticado.';
          _loading = false;
        });
        return;
      }

      setState(() {
        _currentUserRole = user.role;
      });

      final tutoringNotifier = ref.read(tutoringProvider.notifier);

      if (user.role == UserRole.teacher) {
        await tutoringNotifier.loadTutoringsByTeacherId(user.id);
      } else if (user.role == UserRole.student) {
        final tutoringRequestNotifier = ref.read(tutoringRequestProvider.notifier);
        _studentTutoringRequests = await tutoringRequestNotifier.getTutoringRequestsByStudentId(user.id);

        final tutoringRequestIds = _studentTutoringRequests.map((r) => r.id).toList();
        await tutoringNotifier.loadTutoringsByTutoringRequestIds(tutoringRequestIds);
      } else {
        setState(() {
          _error = 'Rol de usuario no válido.';
          _loading = false;
        });
        return;
      }

      setState(() {
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error al cargar tutorías: $e';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tutorings = ref.watch(tutoringProvider);

    // Si es estudiante, filtrar solo tutorías con solicitudes aceptadas
    List<Tutoring> filteredTutorings = tutorings;
    if (_currentUserRole == UserRole.student) {
      final acceptedTutoringIds = _studentTutoringRequests
          .where((req) => req.status == TutoringRequestStatus.accepted)
          .map((req) => req.tutoringId)
          .toSet();

      filteredTutorings = tutorings.where((t) => acceptedTutoringIds.contains(t.id)).toList();
    }

    return Scaffold(
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : filteredTutorings.isEmpty
                  ? const Center(child: Text('No hay tutorías disponibles.'))
                  : ListView.builder(
                      itemCount: filteredTutorings.length,
                      itemBuilder: (context, index) {
                        final tutoring = filteredTutorings[index];
                        return TutoringCard(tutoring: tutoring);
                      },
                    ),
      floatingActionButton: (_currentUserRole == UserRole.teacher)
          ? FloatingActionButton(
              onPressed: () async {
                await Navigator.pushNamed(context, AppRoutes.createTutoring);
                setState(() {
                  _loading = true;
                });
                _loadTutorings();
              },
              tooltip: 'Crear tutoría',
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
