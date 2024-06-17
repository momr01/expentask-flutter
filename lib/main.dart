import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:payments_management/common/widgets/bottom_bar.dart';
import 'package:payments_management/constants/global_variables.dart';
import 'package:payments_management/constants/local_notifications.dart';
import 'package:payments_management/constants/navigator_keys.dart';
import 'package:payments_management/features/alerts/services/local_notifications_services.dart';
import 'package:payments_management/features/alerts/services/work_manager_services.dart';
import 'package:payments_management/features/auth/screens/login_screen.dart';
import 'package:payments_management/features/auth/services/auth_services.dart';
import 'package:payments_management/providers/user_provider.dart';
import 'package:payments_management/router.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';

/*@pragma('vm:entry-point')
void actionTask() {
  Workmanager().executeTask((taskName, inputData) async {
    LocalNotificationsServices.showBasicNotification();
    return Future.value(true);
  });
}*/

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await LocalNotificationsServices.init();
  //await WorkManagerServices().init();

  await Future.wait(
      [LocalNotificationsServices.init(), WorkManagerServices().init()]);
  //Workmanager().initialize(actionTask, isInDebugMode: true);
  //Workmanager().registerOneOffTask("task-identifier", "simpleTask");

  runApp(MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => UserProvider())],
      child: const MyApp()));
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
                return const Center(child: CircularProgressIndicator());
              });
        }));
  }
}
