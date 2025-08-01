import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'routes/app_routes.dart';
import 'firebase/firebase_initializer.dart';
import 'firebase/firebase_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final connected = await initializeFirebaseAndMessaging();

  runApp(
    ProviderScope(
      overrides: [
        firebaseConnectedProvider.overrideWithValue(connected),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firebaseConnected = ref.watch(firebaseConnectedProvider);

    return MaterialApp(
      title: 'TutorConnect',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.login,
      onGenerateRoute: AppRoutes.generateRoute,
      builder: (context, child) {
        if (!firebaseConnected) {
          return const Scaffold(
            body: Center(
              child: Text(
                'Error de conexión con Firebase',
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
            ),
          );
        }
        return child!;
      },
    );
  }
}
