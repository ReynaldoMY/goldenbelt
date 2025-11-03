import 'package:flutter/material.dart';
import 'package:goldenbelt/src/_env/gbEnvironment.dart';
import 'package:goldenbelt/src/_env/gbNotifications.dart';
import 'package:goldenbelt/src/_models/gb_notification_model.dart';
import 'package:goldenbelt/src/gbLogin/gbLogin_page.dart';
import 'package:goldenbelt/src/gbMain/gbMain_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:goldenbelt/src/_models/gb_tgroup_model.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';


Future<void> _handleBackgroundMessage(RemoteMessage message) async
{
  print('background');
  print('Title: ${message.notification!.title}');
  print('Body: ${message.notification!.body}');
}

final navigatorKey = GlobalKey<NavigatorState>();

// Instancia de Parámetro Global de Grupo (Caso de Notificaciones).
gb_notification lo_event_gb_notification = gb_notification();
int ln_event_index_page = 0;

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await gbSessionSettings.configurePrefs();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseMessaging.instance.setAutoInitEnabled(true);

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage remoteMessage)
  {

    lo_event_gb_notification = gb_notification.fromJson(remoteMessage.data);

    // Si no es un grupo, se navega a la Sección respectiva dependiendo del mail_template.
    switch (lo_event_gb_notification.notification_type)
    {
      case 'MOBILE_GROUP_CHAT': ln_event_index_page = 2; break;
      case 'MOBILE_DARE_NOTIF': ln_event_index_page = 1; break;
      case 'MOBILE_REQUEST_MAIL': ln_event_index_page = 1; break;
    }

    navigatorKey.currentState!.pushNamed("gbMainFrontPage");
  });

  FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => gbCountNotificationProvider()),
      ],
      child: MyApp(),
    ),
  );

}

class MyApp extends StatefulWidget {

  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  var initialRoute =

  // Si es que no se ha definido la variable de usuario.
  gbSessionSettings.prefs.getString('ses_tuser_id') == 'null' ||
      gbSessionSettings.prefs.getString('ses_tuser_id') == null ||
      gbSessionSettings.prefs.getString('ses_tuser_id') == '0' ? 'gbLogin' : 'gbMainFrontPage';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Goldenbelt', debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      routes:{
        'gbLogin': (BuildContext context) => gbLoginPage(startup_msg:""),
        'gbMainFrontPage': (BuildContext context) => gbMainFrontPage(ln_event_index_page: ln_event_index_page, lo_event_gb_notification: lo_event_gb_notification)
      }
    );
  }
}
