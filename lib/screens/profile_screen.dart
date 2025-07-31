import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/utils/helpers/student_helper.dart';
import '../models/user.dart';

class ProfileScreen extends ConsumerWidget {
  final User user;

  const ProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mostrar imagen si hay URL, si no, un icono por defecto
            Center(
              child: user.photoUrl != null && user.photoUrl!.isNotEmpty
                  ? ClipOval(
                      child: Image.network(
                        user.photoUrl!,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.account_circle,
                            size: 120,
                            color: Colors.grey,
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const SizedBox(
                            width: 120,
                            height: 120,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        },
                      ),
                    )
                  : const Icon(
                      Icons.account_circle,
                      size: 120,
                      color: Colors.grey,
                    ),
            ),
            const SizedBox(height: 16),

            Text('Email: ${user.email}'),
            const SizedBox(height: 8),
            Text('UID: ${user.id}'),
            const SizedBox(height: 8),
            Text('Nombre: ${user.fullname}'),
            const SizedBox(height: 8),
            Text('Rol: ${user.role.getDisplayName()}'),
            const SizedBox(height: 8),
            Text('Token FCM: ${user.fcmToken ?? "No disponible"}'),
            const SizedBox(height: 8),
            Text('URL de Imagen: ${user.photoUrl ?? "No disponible"}'),
            const SizedBox(height: 8),
            Text('Creado en: ${user.createdAt}'),
          ],
        ),
      ),
    );
  }
}
