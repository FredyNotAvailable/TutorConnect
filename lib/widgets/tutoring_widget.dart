import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/providers/tutoring_provider.dart';
import 'package:tutorconnect/providers/user_provider.dart';
import 'package:tutorconnect/utils/helpers/student_helper.dart';
import 'package:tutorconnect/widgets/teacher/crear_tutoria_widget.dart';
import 'package:tutorconnect/widgets/tutoring_card.dart';

class TutoringWidget extends ConsumerStatefulWidget {
  const TutoringWidget({super.key});

  @override
  ConsumerState<TutoringWidget> createState() => _TutoringWidgetState();
}

class _TutoringWidgetState extends ConsumerState<TutoringWidget> {
  bool _loading = true;
  String? _error;
  bool _showCrearTutoria = false;
  UserRole? _currentUserRole;

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
        _currentUserRole = user.role; // Guardamos el rol para mostrar botón
      });

      final tutoringNotifier = ref.read(tutoringProvider.notifier);

      if (user.role == UserRole.teacher) {
        await tutoringNotifier.loadTutoringsByTeacherId(user.id);
      } else if (user.role == UserRole.student) {
        await tutoringNotifier.loadTutoringsByStudentId(user.id);
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
    if (_showCrearTutoria) {
      return CrearTutoriaWidget(
        onBack: () {
          setState(() {
            _showCrearTutoria = false;
          });
        },
      );
    }

    final tutorings = ref.watch(tutoringProvider);

    return Scaffold(
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : tutorings.isEmpty
                  ? const Center(child: Text('No hay tutorías disponibles.'))
                  : ListView.builder(
                      itemCount: tutorings.length,
                      itemBuilder: (context, index) {
                        final tutoring = tutorings[index];
                        return TutoringCard(tutoring: tutoring);
                      },
                    ),
      floatingActionButton: (_currentUserRole == UserRole.teacher)
          ? FloatingActionButton(
              onPressed: () {
                setState(() {
                  _showCrearTutoria = true;
                });
              },
              tooltip: 'Crear tutoría',
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
