import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'routes/app_routes.dart';

final firebaseConnectedProvider = Provider<bool>((ref) => false);

// Handler para mensajes en segundo plano
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Mensaje en background recibido: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool connected = false;
  try {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    connected = true;
  } catch (e) {
    connected = false;
  }

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
