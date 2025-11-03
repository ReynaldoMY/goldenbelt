 import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async
{
  // print('Title: ${message.notification?.title}');
  // print('Body: ${message.notification?.body}');
  // print('Payload: ${message.data}');
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<String?> initNotifications() async {
    await _firebaseMessaging.requestPermission();

      try {
        String? token = await _firebaseMessaging.getToken();
        if (token != null) {
          print("Token de Firebase: $token");
        } else {
          print("El token es nulo");
        }

        return token;

      } catch (e) {
        print("Error al obtener el token: $e");
        return '';
      }

  }

}

class gbCountNotificationProvider extends ChangeNotifier {

  int _ses_count_notification = 0;

  int get ses_count_notification => _ses_count_notification;

  void increment() {
    _ses_count_notification++;
    notifyListeners();
  }

  void reset()
  {
    _ses_count_notification = 0;
  }

}