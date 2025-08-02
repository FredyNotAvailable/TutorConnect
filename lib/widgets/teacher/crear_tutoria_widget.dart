import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/models/tutoring.dart';
import 'package:tutorconnect/providers/classroom_provider.dart';
import 'package:tutorconnect/providers/tutoring_provider.dart';
import 'package:tutorconnect/providers/user_provider.dart';

class CrearTutoriaWidget extends ConsumerStatefulWidget {
  final VoidCallback onBack;

  const CrearTutoriaWidget({super.key, required this.onBack});

  @override
  ConsumerState<CrearTutoriaWidget> createState() => _CrearTutoriaWidgetState();
}

class _CrearTutoriaWidgetState extends ConsumerState<CrearTutoriaWidget> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _topicController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  String? _classroomId;
  String? _subjectId;
  List<String> _studentIds = [];
  String? _teacherId;

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _topicController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
    );
    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  Future<void> _pickTime({required bool isStart}) async {
    final now = TimeOfDay.now();
    final time = await showTimePicker(
      context: context,
      initialTime: isStart ? (_startTime ?? now) : (_endTime ?? now),
    );
    if (time != null) {
      setState(() {
        if (isStart) {
          _startTime = time;
        } else {
          _endTime = time;
        }
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null || _startTime == null || _endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor selecciona fecha y hora.')),
      );
      return;
    }
    if (_classroomId == null || _subjectId == null || _teacherId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Faltan datos necesarios para crear la tutoría.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final createdAt = DateTime.now();

    final tutoring = Tutoring(
      id: '', // Asignado por backend/Firebase
      classroomId: _classroomId!,
      createdAt: createdAt,
      date: DateTime(_selectedDate!.year, _selectedDate!.month, _selectedDate!.day),
      startTime: _startTime!.format(context),
      endTime: _endTime!.format(context),
      notes: _notesController.text.trim(),
      status: TutoringStatus.active,
      studentIds: _studentIds,
      subjectId: _subjectId!,
      teacherId: _teacherId!,
      topic: _topicController.text.trim(),
    );

    try {
      await ref.read(tutoringProvider.notifier).addTutoring(tutoring);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tutoría creada exitosamente')),
      );
      widget.onBack();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al crear tutoría: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Obtenemos la lista actualizada de aulas desde el provider
    final classrooms = ref.watch(classroomProvider);
    final currentUserAsync = ref.watch(currentUserProvider);

    String? currentTeacherId;
    currentUserAsync.whenData((user) {
      if (user != null) {
        currentTeacherId = user.id;
        if (_teacherId == null) {
          _teacherId = currentTeacherId;
        }
      }
    });

    return Column(
      children: [
        // Barra simple con botón atrás
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: widget.onBack,
            ),
            const SizedBox(width: 8),
            const Text(
              'Crear Tutoría',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),

        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Tema
                  TextFormField(
                    controller: _topicController,
                    decoration: const InputDecoration(labelText: 'Tema'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'El tema es obligatorio';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 12),

                  // Notas
                  TextFormField(
                    controller: _notesController,
                    decoration: const InputDecoration(labelText: 'Notas (opcional)'),
                    minLines: 1,
                    maxLines: 5,
                    keyboardType: TextInputType.multiline,
                  ),

                  const SizedBox(height: 12),

                  // Selector Aula dinámico
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Aula'),
                    items: classrooms.isEmpty
                        ? [
                            const DropdownMenuItem(
                              value: null,
                              child: Text('No hay aulas disponibles'),
                            )
                          ]
                        : classrooms.map((aula) => DropdownMenuItem(
                              value: aula.id,
                              child: Text('${aula.name} - ${aula.type.name}'),
                            )).toList(),
                    onChanged: classrooms.isEmpty
                        ? null
                        : (value) => setState(() => _classroomId = value),
                    value: classrooms.any((a) => a.id == _classroomId) ? _classroomId : null,
                    validator: (value) => value == null ? 'Selecciona un aula' : null,
                  ),

                  const SizedBox(height: 12),

                  // Fecha
                  Row(
                    children: [
                      const Text('Fecha: '),
                      TextButton(
                        onPressed: _pickDate,
                        child: Text(_selectedDate == null
                            ? 'Seleccionar fecha'
                            : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'),
                      ),
                    ],
                  ),

                  // Hora inicio
                  Row(
                    children: [
                      const Text('Hora inicio: '),
                      TextButton(
                        onPressed: () => _pickTime(isStart: true),
                        child: Text(_startTime == null
                            ? 'Seleccionar hora'
                            : _startTime!.format(context)),
                      ),
                    ],
                  ),

                  // Hora fin
                  Row(
                    children: [
                      const Text('Hora fin: '),
                      TextButton(
                        onPressed: () => _pickTime(isStart: false),
                        child: Text(_endTime == null
                            ? 'Seleccionar hora'
                            : _endTime!.format(context)),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  ElevatedButton(
                    onPressed: _isSubmitting ? null : _submit,
                    child: _isSubmitting
                        ? const CircularProgressIndicator()
                        : const Text('Crear Tutoría'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}