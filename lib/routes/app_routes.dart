import 'package:flutter/material.dart';
import 'package:tutorconnect/models/user.dart';
import 'package:tutorconnect/screens/home_screen.dart';
import 'package:tutorconnect/screens/profile_screen.dart';
import '../screens/login_screen.dart';
// Importa aquí otras pantallas cuando las tengas

class AppRoutes {
  static const login = '/login';
  // Define más rutas estáticas aquí, por ejemplo:
  static const home = '/home';
  static const profile = '/profile';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      // Agrega más casos para otras rutas aquí
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      // Profile
      case profile:
        final user = settings.arguments as User?; // o String si solo UID
        if (user == null) {
          return MaterialPageRoute(
            builder: (_) => const Scaffold(
              body: Center(child: Text('Usuario no proporcionado')),
            ),
          );
        } else {
          return MaterialPageRoute(builder: (_) => ProfileScreen(user: user,)
          );
        }
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
