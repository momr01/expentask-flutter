import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:payments_management/common/widgets/bottom_bar.dart';
import 'package:payments_management/constants/global_variables.dart';
import 'package:payments_management/constants/local_notifications.dart';
import 'package:payments_management/constants/navigator_keys.dart';
import 'package:payments_management/features/alerts/services/local_notifications_services.dart';
import 'package:payments_management/features/alerts/services/work_manager_services.dart';
import 'package:payments_management/features/auth/screens/login_screen.dart';
import 'package:payments_management/features/auth/services/auth_services.dart';
import 'package:payments_management/features/default/screens/default_screen.dart';
import 'package:payments_management/providers/user_provider.dart';
import 'package:payments_management/router.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';
import 'package:background_fetch/background_fetch.dart';

/*@pragma('vm:entry-point')
void actionTask() {
  Workmanager().executeTask((taskName, inputData) async {
    LocalNotificationsServices.showBasicNotification();
    return Future.value(true);
  });
}*/

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // Inicializa flutter_local_notifications dentro del task
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Configura y muestra la notificación
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      styleInformation:
          BigTextStyleInformation('Esta es una notificación programada.'),
      color: Colors.blue, // Cambia el color de la notificación
      ledColor: Colors.red, // Configura la luz LED (si aplica)
      ledOnMs: 1000,
      ledOffMs: 500,
      icon: '@mipmap/ic_launcher', // Ícono personalizado
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Título Personalizado',
      'Contenido de la notificación personalizada',
      platformChannelSpecifics,
    );

    return Future.value(true);
  });
}

void registerDailyPeriodicTask() async {
  // await Workmanager().registerPeriodicTask(
  //   'id1', // ID único de la tarea
  //   'WARNING!', // Nombre de la tarea
  //   frequency: Duration(hours: 24), // Frecuencia de la tarea
  //   initialDelay: Duration(seconds: 10), // Retraso inicial opcional
  //   inputData: <String, dynamic>{},
  //   constraints: Constraints(
  //     networkType: NetworkType.not_required, // Restricciones opcionales
  //     requiresCharging: false,
  //     requiresDeviceIdle: false,
  //     requiresBatteryNotLow: false,
  //   ),
  // );

  await Workmanager().registerPeriodicTask(
      'id1', // ID único de la tarea
      'WARNING!', // Nombre de la tarea
      tag: "jjjk"
      // frequency: Duration(hours: 24), // Frecuencia de la tarea
      // initialDelay: Duration(seconds: 10), // Retraso inicial opcional
      // inputData: <String, dynamic>{},
      // constraints: Constraints(
      //   networkType: NetworkType.not_required, // Restricciones opcionales
      //   requiresCharging: false,
      //   requiresDeviceIdle: false,
      //   requiresBatteryNotLow: false,
      //),
      );
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await LocalNotificationsServices.init();
  //await WorkManagerServices().init();

//este si
  // await Future.wait(
  //     [LocalNotificationsServices.init(), WorkManagerServices().init()]);

//esto no
  //Workmanager().initialize(actionTask, isInDebugMode: true);
  //Workmanager().registerOneOffTask("task-identifier", "simpleTask");

  //este si
  //LocalNotificationsServices.showDailyScheduledNotification();

  // Inicializa el WorkManager
  // Workmanager().initialize(
  //   callbackDispatcher,
  //   isInDebugMode: false,
  // );

  //registerDailyPeriodicTask();

  runApp(MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => UserProvider())],
      child: const MyApp()));

  // Inicializar flutter_local_notifications
  final initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Configurar Background Fetch
  BackgroundFetch.configure(
    BackgroundFetchConfig(
      minimumFetchInterval: 15, // Intervalo en minutos
      stopOnTerminate: false,
      startOnBoot: true,
    ),
    onBackgroundFetch,
  ).then((int status) {
    print('BackgroundFetch configurado: $status');
  }).catchError((e) {
    print('Error configurando BackgroundFetch: $e');
  });
}

// Función que se ejecuta en segundo plano
void onBackgroundFetch(String taskId) async {
  // Aquí realizas la tarea en segundo plano

  // Mostrar notificación
  await showNotification(
      "Tarea en segundo plano o sea", "Se ha ejecutado correctamenteeeeeeee.");

  // Finalizar tarea
  BackgroundFetch.finish(taskId);
}

Future<void> showNotification(String title, String body) async {
  const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      // 'your_channel_id', 'your_channel_name', 'your_channel_description',
      'id_background',
      'name_background',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false);
  const platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin
      .show(0, title, body, platformChannelSpecifics, payload: 'data');
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthServices authServices = AuthServices();

  // bool userDataAvailable = false;

  @override
  void initState() {
    super.initState();
    authServices.getUserData(context: context);

    // fetchUserData();
  }

  // fetchUserData() async {
  //   userDataAvailable = await authServices.getDataFromUser(context: context);
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: NavigatorKeys.navKey,
        // navigatorKey: nnnavigatorKey,
        //    navigatorKey: locator<NavigationService>().navigatorKey,
        title: 'Expentask',
        theme: ThemeData(
            scaffoldBackgroundColor: GlobalVariables.backgroundColor,
            colorScheme:
                const ColorScheme.light(primary: GlobalVariables.primaryColor),
            appBarTheme: const AppBarTheme(
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.black),
            )),
        onGenerateRoute: (settings) => generateRoute(settings),
        // home: Provider.of<UserProvider>(context).user.token.isNotEmpty
        //     ? const BottomBar(
        //         page: 0,
        //       )
        //     : const LoginScreen(),

        // home: userDataAvailable
        //     ? Provider.of<UserProvider>(context).user.token.isNotEmpty
        //         ? const BottomBar(
        //             page: 0,
        //           )
        //         : const LoginScreen()
        //     : const NotFoundScreen()

        home: Builder(builder: (context) {
          return FutureBuilder(
              future: authServices.getUserData(context: context),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Provider.of<UserProvider>(context)
                          .user
                          .token
                          .isNotEmpty
                      ? const BottomBar(
                          page: 0,
                        )
                      : const LoginScreen();
                }

                // return const Center(child: CircularProgressIndicator());
                return const DefaultScreen();
              });
        }));
  }
}
