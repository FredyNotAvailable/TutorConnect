import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/models/user.dart';
import 'package:tutorconnect/utils/helpers/student_helper.dart';

class ProfileWidget extends ConsumerWidget {
  final User customUser;

  const ProfileWidget({super.key, required this.customUser});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen de perfil
          Center(
            child: customUser.photoUrl != null && customUser.photoUrl!.isNotEmpty
                ? ClipOval(
                    child: Image.network(
                      customUser.photoUrl!,
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

          // Info del usuario
          Text('Email: ${customUser.email}'),
          const SizedBox(height: 8),
          Text('UID: ${customUser.id}'),
          const SizedBox(height: 8),
          Text('Nombre: ${customUser.fullname}'),
          const SizedBox(height: 8),
          Text('Rol: ${customUser.role.getDisplayName()}'),
          const SizedBox(height: 8),
          Text('Token FCM: ${customUser.fcmToken ?? "No disponible"}'),
          const SizedBox(height: 8),
          Text('URL de Imagen: ${customUser.photoUrl ?? "No disponible"}'),
          const SizedBox(height: 8),
          Text('Creado en: ${customUser.createdAt}'),
        ],
      ),
    );
  }
}
