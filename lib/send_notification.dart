import 'dart:convert';
import 'dart:io';
import 'package:googleapis_auth/auth_io.dart';

Future<void> main() async {
  // Ruta al archivo JSON con la cuenta de servicio
  final serviceAccountPath = 'credentials.json';

  // Lee el archivo JSON
  final serviceAccountJson = await File(serviceAccountPath).readAsString();

  // Decodifica a Map
  final Map<String, dynamic> jsonMap = jsonDecode(serviceAccountJson);

  // Crea las credenciales
  final credentials = ServiceAccountCredentials.fromJson(jsonMap);

  final client = await clientViaServiceAccount(
    credentials,
    ['https://www.googleapis.com/auth/firebase.messaging'],
  );

  final url = Uri.parse(
    // 'https://fcm.googleapis.com/v1/projects/${jsonMap['project_id']}/messages:send',
    'https://fcm.googleapis.com/v1/projects/tutorconnect-b1cb4/messages:send'
  );

  final fcmMessage = {
    "message": {
      "token": "ET0kvhv8TzaJV52G8Z2bbU:APA91bFuLt4A7GglnvLhGt3DYf1Kkhgp8NEv8nEXLesndAL3BJd94eGhPx57TV8XZcuyN0YhuKdmPObHLXd08ZsW-QBW_d7TCSgOqPe9jIOvdmC042I8cz4",
      "notification": {
        "title": "🚀 Notificación segura",
        "body": "Mensaje enviado desde Dart con credenciales externas"
      },
    }
  };

  final response = await client.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(fcmMessage),
  );

  print('Status code: ${response.statusCode}');
  print('Body: ${response.body}');

  client.close();
}
