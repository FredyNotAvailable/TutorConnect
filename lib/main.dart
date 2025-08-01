import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/firebase/push_notification_service.dart';
import 'routes/app_routes.dart';
import 'firebase/firebase_initializer.dart';
import 'firebase/firebase_providers.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final connected = await initializeFirebaseAndMessaging();

  if (connected) {
    await PushNotificationService.initialize(); // Inicializa notificaciones push
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
      navigatorKey: navigatorKey, // Importante para poder mostrar SnackBar desde main
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
