import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tutorconnect/models/tutoring.dart';
import 'package:tutorconnect/routes/app_routes.dart'; // Asegúrate de importar tu AppRoutes

class TutoringCard extends StatelessWidget {
  final Tutoring tutoring;

  const TutoringCard({required this.tutoring, super.key});

  @override
  Widget build(BuildContext context) {
    final dateFormatted = DateFormat('yyyy-MM-dd').format(tutoring.date);
    final statusText = tutoring.status.name.toUpperCase();

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.tutoring,
          arguments: tutoring,
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Topic: ${tutoring.topic}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Date: $dateFormatted'),
              Text('Time: ${tutoring.startTime} - ${tutoring.endTime}'),
              const SizedBox(height: 8),
              Text('Status: $statusText',
                  style: TextStyle(
                    color: _statusColor(tutoring.status),
                    fontWeight: FontWeight.w600,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Color _statusColor(TutoringStatus status) {
    switch (status) {
      case TutoringStatus.active:
        return Colors.green;
      case TutoringStatus.finished:
        return Colors.grey;
      case TutoringStatus.canceled:
        return Colors.red;
      default:
        return Colors.black; // O algún color neutro
    }
  }
}
