import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  static final _firebaseMessaging = FirebaseMessaging.instance;

  /// Llamar desde el main al iniciar la app
  static Future<void> initialize() async {
    // Solicita permisos en iOS (Android los concede por defecto)
    await _firebaseMessaging.requestPermission();

    // Maneja mensajes cuando la app está en segundo plano y se toca la notificación
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

    // Maneja mensajes en primer plano
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Puedes manejar mensajes en segundo plano usando un handler global si lo necesitas
    // Veremos esto más adelante si quieres
  }

  static void _handleForegroundMessage(RemoteMessage message) {
    // Aquí puedes mostrar un snackbar, diálogo, etc.
    print('🔔 Mensaje en primer plano: ${message.notification?.title}');
  }

  static void _handleMessageOpenedApp(RemoteMessage message) {
    print('📲 Usuario abrió la app desde la notificación');
    // Aquí puedes navegar, etc.
  }

  static Future<String?> getFcmToken() async {
    return await _firebaseMessaging.getToken();
  }
}
