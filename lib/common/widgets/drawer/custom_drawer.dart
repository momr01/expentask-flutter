import 'package:flutter/material.dart';
import 'package:payments_management/common/widgets/drawer/custom_drawer_item.dart';
import 'package:payments_management/constants/utils.dart';
import 'package:payments_management/features/categories/screens/categories_screen.dart';
import 'package:payments_management/features/creditor/screens/creditor_screen.dart';
import 'package:payments_management/features/groups/screens/groups_screen.dart';
import 'package:payments_management/features/historical/screens/historical_screen.dart';
import 'package:payments_management/features/notes/screens/notes_screen.dart';
import 'package:payments_management/features/profile/screens/profile_screen.dart';
import 'package:payments_management/features/shared_duty/screens/shared_duty_screen.dart';
import 'package:payments_management/features/tasks/screens/tasks_screen.dart';
import 'package:payments_management/models/drawer_item.dart';
import 'package:payments_management/providers/user_provider.dart';
import 'package:provider/provider.dart';

final List<DrawerItem> items = [
  DrawerItem('Historial', const Icon(Icons.history_outlined),
      HistoricalScreen.routeName, [], [], false),
  DrawerItem('Tareas', const Icon(Icons.home_work), TasksScreen.routeName, [],
      [], false),
  DrawerItem(
      'Categorías',
      const Icon(
        Icons.category,
      ),
      CategoriesScreen.routeName,
      [],
      [],
      false),
  DrawerItem(
      'Grupos',
      const Icon(
        Icons.list,
      ),
      GroupsScreen.routeName,
      [],
      [],
      false),
  // DrawerItem(
  //     'Mi Perfil',
  //     const Icon(
  //       Icons.person,
  //     ),
  //     ProfileScreen.routeName,
  //     [],
  //     false),
  // DrawerItem(
  //     'Estadísticas',
  //     const Icon(
  //       Icons.dashboard_customize,
  //     ),
  //     ProfileScreen.routeName,
  //     [],
  //     false),
  /* DrawerItem(
       'Notas',
       const Icon(
         Icons.note_add,
       ),*/
  DrawerItem(
      'Notas',
      const Icon(
        Icons.notes,
      ),
      NotesScreen.routeName,
      [],
      [false],
      false),
  //     ProfileScreen.routeName,
  //     [],
  //     false),
  // DrawerItem(
  //     'Administración',
  //     const Icon(
  //       Icons.settings_system_daydream,
  //     ),
  //     ProfileScreen.routeName,
  //     [],
  //     false),
  DrawerItem(
      'Acreedores',
      const Icon(
        Icons.payment,
      ),
      CreditorScreen.routeName,
      [],
      [false],
      false),
  DrawerItem(
      'Obligaciones compartidas',
      const Icon(
        Icons.person_2,
      ),
      SharedDutyScreen.routeName,
      [],
      [false],
      false),
  DrawerItem(
      'Cerrar Sesión',
      const Icon(
        Icons.logout,
      ),
      '',
      [],
      [],
      true),
];

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
              decoration:
                  BoxDecoration(color: Theme.of(context).colorScheme.primary),
              accountName: Text(
                capitalizeFirstLetter(user.name),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              accountEmail: Text(
                user.email,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              // currentAccountPicture: const FlutterLogo(),
              currentAccountPicture: Image.asset("assets/images/user.png")),
          Flexible(
            child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: items.length,
                itemBuilder: (context, index) => CustomDrawerItem(
                      icon: items[index].icon,
                      title: items[index].title,
                      route: items[index].route,
                      args: items[index].title == 'Historial'
                          ? items[index].argsHistorical
                          : items[index].args,
                      closeSession: items[index].closeSession,
                    )),
          )
        ],
      ),
    );
  }
}
