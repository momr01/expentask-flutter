import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:payments_management/common/widgets/bottom_bar.dart';
import 'package:payments_management/constants/global_variables.dart';
import 'package:payments_management/constants/navigator_keys.dart';
import 'package:payments_management/features/alerts/services/local_notifications_services.dart';
import 'package:payments_management/features/alerts/services/work_manager_services.dart';
import 'package:payments_management/features/auth/screens/login_screen.dart';
import 'package:payments_management/features/auth/services/auth_services.dart';
import 'package:payments_management/features/default/screens/default_screen.dart';
import 'package:payments_management/features/names/providers/names_provider.dart';
import 'package:payments_management/providers/global_state_provider.dart';
import 'package:payments_management/providers/user_provider.dart';
import 'package:payments_management/router.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Future.wait(
      [LocalNotificationsServices.init(), WorkManagerServices().init()]);

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => UserProvider()),
    ChangeNotifierProvider(create: (context) => GlobalStateProvider()),
    ChangeNotifierProvider(create: (_) => NamesProvider()), // 👈 agregado
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthServices authServices = AuthServices();

  @override
  void initState() {
    super.initState();
    authServices.getUserData(
        //context: context
        );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: NavigatorKeys.navKey,
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
        home: Builder(builder: (context) {
          return FutureBuilder(
              future: authServices.getUserData(
                  //context: context
                  ),
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
                return const DefaultScreen();
              });
        }));
  }
}
