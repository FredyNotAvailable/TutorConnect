import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/models/user.dart'; // Tu modelo User
import 'package:tutorconnect/routes/app_routes.dart';
import 'package:tutorconnect/providers/auth_provider.dart';
import 'package:tutorconnect/providers/user_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final authUserAsync = ref.watch(authStateProvider);

    return authUserAsync.when(
      data: (firebaseUser) {
        if (firebaseUser == null) {
          return const Scaffold(
            body: Center(child: Text('No estás logueado')),
          );
        }

        return FutureBuilder<User?>(
          future: ref.read(userServiceProvider).getUserById(firebaseUser.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return const Scaffold(
                body: Center(child: Text('Usuario personalizado no encontrado')),
              );
            }

            final customUser = snapshot.data!;

            return Scaffold(
              appBar: AppBar(
                title: const Text('Home'),
                automaticallyImplyLeading: false,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.person),
                    tooltip: 'Perfil',
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.profile,
                        arguments: customUser,
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout),
                    tooltip: 'Cerrar sesión',
                    onPressed: () async {
                      await ref.read(signOutProvider.future);
                      Navigator.pushReplacementNamed(context, AppRoutes.login);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        body: Center(child: Text('Error: $error')),
      ),
    );
  }
}
